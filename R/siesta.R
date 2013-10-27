
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

