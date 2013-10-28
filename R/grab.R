#' @export
grab <- function(json, ...){
  what  <- named_dots(...)
  columns <- lapply( what, function(e){
    sapply( json, function(.) {
      eval(e, list2env(.) ) 
    })
  })
  names(columns) <- names(what)
  as.data.frame(columns, stringsAsFactors = FALSE)
}

