#' @export
grab <- function(json, ...){
  what  <- named_dots(...)
  parent_frame <- parent.frame()
  columns <- lapply( what, function(e){
    sapply( json, function(.) {
      env <- as.environment(.)
      parent.env(env) <- parent_frame
      eval(e, env ) 
    })
  })
  names(columns) <- names(what)
  as.data.frame(columns, stringsAsFactors = FALSE)
}

