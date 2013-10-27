#' @export
grab <- function(json, ...){
  what  <- named_dots(...)
  parent_frame <- parent.frame()
  columns <- lapply( what, function(e){
    sapply( json, function(.) {
      eval(e, list2env(., parent = parent_frame) ) 
    })
  })
  names(columns) <- names(what)
  as.data.frame(columns, stringsAsFactors = FALSE)
}

