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

lookin.default <- function(x, what, object.name, ...) {
    if(is.list(x))
        lookin.list(x, what, ...)
    else 
        structure(setNames(.in_values(x, what, ...), "values"), 
                  class = "lookin",
                  object = if(missing(object.name)) deparse(substitute(x)) else object.name,
                  what = what)
}

lookin.character <- function(x, what, object.name, ...) {
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
        class = "lookin.character",
        object = if(missing(object.name)) deparse(substitute(x)) else object.name,
        what = what)
}

lookin.numeric <- function(x, what, object.name, ...) {
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
        class = "lookin.numeric",
        object = if(missing(object.name)) deparse(substitute(x)) else object.name,
        what = what)
}

lookin.logical <- function(x, what, object.name, ...) {
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
        class = "lookin.logical",
        object = if(missing(object.name)) deparse(substitute(x)) else object.name,
        what = what)
}

lookin.factor <- function(x, what, object.name, ...) {
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
        class = "lookin.factor",
        object = if(missing(object.name)) deparse(substitute(x)) else object.name,
        what = what)
}

lookin.data.frame <- function(x, what, object.name, ...) {
    if(class(x) != 'data.frame')
        stop("Object must be a data.frame")
    structure(list(attributes = .in_attributes(x, what, ...),
                   comment = .in_comment(x, what, ...),
                   variables = lapply(x, lookin, what = what, ...)), 
              class = "lookin.data.frame",
              object = if(missing(object.name)) deparse(substitute(x)) else object.name,
              what = what)
}

lookin.list <- function(x, what, check.attributes = TRUE, object.name, ...) {
    out1 <- lapply(x, lookin, what = what, ...)
    out1 <- setNames(out1, names(x))
    out1$comment <- .in_comment(x, what, ...)
    if(check.attributes) {
        z <- attributes(x)
        #z$names <- NULL
        if(length(z)) {
            out1$attributes <- list()
            for(i in seq_along(z)) {
                out1$attributes[[i]] <- lookin(z[[i]], what = what, 
                                               object.name = paste0(names(z)[i]), ...)
            }
        }
    }
    structure(out1, 
              class = "lookin.list",
              object = if(missing(object.name)) deparse(substitute(x)) else object.name,
              what = what)
}

lookin.pairlist <- function(x, what, object.name, ...) {
    out1 <- list()
    for(i in seq_along(x))
        out1[[i]] <- .in_values(as.character(x[[i]]), what, ...)
    out2 <- .in_values(names(x), what, ...)
    structure(c(names = out2, values = out1), 
              class = "lookin.pairlist",
              object = if(missing(object.name)) deparse(substitute(x)) else object.name,
              what = what)
}

lookin.matrix <- function(x, what, object.name, ...) {
    if(class(x) != 'matrix')
        stop("Object must be a matrix")
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
        class = "lookin.matrix",
        object = if(missing(object.name)) deparse(substitute(x)) else object.name,
        what = what)
}

lookin.environment <- function(x, what, object.name, ...) {
    s <- ls(x)
    structure(list(comment = .in_comment(x, what, ...), 
         environment = lapply(s, lookin, what = what)),
         class = "lookin.environment",
         object = if(missing(object.name)) deparse(substitute(x)) else object.name,
         what = what)
}

lookin.function <- function(x, what, object.name, ...) {
    f <- sapply(formals(x), function(z) as.character(as.expression(z)))
    f <- lookin(f, what, ...)
    b <- lookin(as.character(body(x)), what, ...)
    structure(list(arguments = f, 
                   body = b, 
                   comment = .in_comment(x, what, ...)), 
              class = "lookin.function",
              object = if(missing(object.name)) deparse(substitute(x)) else object.name,
              what = what)
}
