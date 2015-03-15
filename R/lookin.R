.in_values <- function(x, what, ignore.case = FALSE, ...) {
    w <- which(grepl(what, x, ...))
    if(length(w))
        structure(list(setNames(w, x[w])), location = "values")
    else
        structure(list(integer()), location = "values")
}

.in_comment <- function(x, what, ignore.case = FALSE, ...) {
    w <- which(grepl(what, comment(x), ...))
    structure(list(setNames(w, comment(x)[w])), location = "comment")
}

.in_attributes <- function(x, what, ignore.case = FALSE, ...) {
    a <- attributes(x)
    if(length(a))
        structure(lookin(a, what, check.attributes = FALSE, ...), location = "attributes")
    else
        structure(list(), location = "attributes")
}

lookin <- function(x, what, ...) UseMethod("lookin")

lookin.default <- function(x, what, ...) {
    if(is.list(x))
        lookin.list(x, what, ...)
    else 
        structure(setNames(.in_values(x, what, ...), "values"), 
                  class = "lookin",
                  object = deparse(substitute(x)),
                  what = what)
}

lookin.character <- function(x, what, ...) {
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
        class = "lookin.character",
        object = deparse(substitute(x)),
        what = what)
}

lookin.numeric <- function(x, what, ...) {
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
        class = "lookin.numeric",
        object = deparse(substitute(x)),
        what = what)
}

lookin.logical <- function(x, what, ...) {
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
        class = "lookin.logical",
        object = deparse(substitute(x)),
        what = what)
}

lookin.factor <- function(x, what, ...) {
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
        class = "lookin.factor",
        object = deparse(substitute(x)),
        what = what)
}

lookin.data.frame <- function(x, what, ...) {
    if(class(x) != 'data.frame')
        stop("Object must be a data.frame")
    structure(list(attributes = .in_attributes(x, what, ...),
                   comment = .in_comment(x, what, ...),
                   variables = lapply(x, lookin, what = what, ...)), 
              class = "lookin.data.frame",
              object = deparse(substitute(x)),
              what = what)
}

lookin.list <- function(x, what, check.attributes = TRUE, ...) {
    out1 <- lapply(x, lookin, what = what, ...)
    out1 <- setNames(out1, names(x))
    out1$comment <- .in_comment(x, what, ...)
    z <- attributes(x)
    z$names <- NULL
    if(length(z))
        out1$attributes <- lapply(z, lookin, what = what, ...)
    structure(out1, 
              class = "lookin.list",
              object = deparse(substitute(x)),
              what = what)
}

lookin.pairlist <- function(x, what, ...) {
    out1 <- list()
    for(i in seq_along(x))
        out1[[i]] <- .in_values(as.character(x[[i]]), what, ...)
    out2 <- .in_values(names(x), what, ...)
    structure(c(names = out2, values = out1), 
              class = "lookin.pairlist",
              object = deparse(substitute(x)),
              what = what)
}

lookin.matrix <- function(x, what, ...) {
    if(class(x) != 'matrix')
        stop("Object must be a matrix")
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
        class = "lookin.matrix",
        object = deparse(substitute(x)),
        what = what)
}

lookin.environment <- function(x, what, ...) {
    s <- ls(x)
    structure(list(comment = .in_comment(x, what, ...), 
         environment = lapply(s, lookin, what = what)),
         class = "lookin.environment",
         object = deparse(substitute(x)),
         what = what)
}

lookin.function <- function(x, what, ...) {
    f <- lookin(formals(x), what, ...)
    b <- lookin(as.character(body(x)), what, ...)
    structure(list(arguments = f, body = b), 
              class = "lookin.function",
              object = deparse(substitute(x)),
              what = what)
}
