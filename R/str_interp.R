#' @export
str_interp <- function(string, env = parent.frame()) {
  if (is.list(env)) env <- list2env(env)

  var_matches <- gregexpr(":[a-zA-Z_0-9]+", string)
  vars <- regmatches(string, var_matches)[[1]]
  vars <- unique(unlist(gsub(":", "", vars)))

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
json_api <- function(prefix = "https://api.github.com/" ){
  if( !grepl( "/$", prefix ) ) prefix <- paste( prefix, "/", sep = "" )
  list(
    GET = function(text, env){
      url <- str_interp( sprintf( "%s%s", prefix, text ), env )
      fromJSON( content( GET(url), "text" ) )
    }
  )  
}

