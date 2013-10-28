
#---------- borrowed from dplyr
dots <- function(...) {
  eval(substitute(alist(...)))
}
 
named_dots <- function(...) {
  auto_name(dots(...))
}

auto_names <- function(x) {
  nms <- names2(x)
  missing <- nms == ""
  if (all(!missing)) return(nms)
  
  deparse2 <- function(x) paste(deparse(x, 500L), collapse = "")
  defaults <- vapply(x[missing], deparse2, character(1), USE.NAMES = FALSE)
  
  nms[missing] <- defaults
  nms
}

auto_name <- function(x) {
  names(x) <- auto_names(x)
  x
}

is.lang <- function(x) {
  is.name(x) || is.atomic(x) || is.call(x)
}
is.lang.list <- function(x) {
  if (is.null(x)) return(TRUE)
  
  is.list(x) && all_apply(x, is.lang)
}
names2 <- function(x) {
  names(x) %||% rep("", length(x))
}

"%||%" <- function(x, y) if(is.null(x)) y else x

#----------

get_vars <- function(string) {
  var_matches <- gregexpr(":[a-zA-Z_0-9]+", string)
  vars <- regmatches(string, var_matches)[[1]]
  vars <- unique(unlist(gsub(":", "", vars)))
  vars  
}

str_interp <- function(string, env = parent.frame()) {
  if (is.list(env)) env <- list2env(env)
  
  vars <- get_vars(string)
  # Do backwards, so positions don't change
  for (var in vars) {
    if (!exists(var, envir = env, inherits = FALSE)) {
      stop("Could not find ", var, " in env", call. = FALSE)
    }
    value <- get(var, envir = env, inherits = FALSE)

    string <- gsub(paste0(":", var), value, string)
  }

  string  
}

#' @export
grab <- function(json, ..., .dots = named_dots(...) ){
  columns <- lapply( .dots, function(e){
    sapply( json, function(.) {
      eval(e, list2env(.) ) 
    })
  })
  names(columns) <- names(.dots)
  as.data.frame(columns, stringsAsFactors = FALSE)
}


#' @export
json_api <- function(prefix = "https://api.github.com/" ){
  if( !grepl( "/$", prefix ) ) prefix <- paste( prefix, "/", sep = "" )
  
  .GET <- function(text, env = globalenv() ){
    url <- str_interp( sprintf( "%s%s", prefix, text ), env )
    fromJSON( content( GET(url), "text" ) )
  }
  bind <- function(string, ...){
    .dots <- named_dots(...)
    vars <- get_vars(string)
    fun <- function(){
      env <- environment()
      url <- str_interp( sprintf( "%s%s", prefix, string ), env )
      data <- fromJSON( content( GET(url), "text" ) )
      if( length(.dots) ) grab( data, .dots = .dots ) else data 
    }
    formals(fun) <- generate_formals(vars)
    fun
  }
  list(
    GET = .GET, 
    bind = bind
  )  
}


