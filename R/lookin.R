.in_values <- function(x, what, ignore.case = FALSE, ...) {
    w <- which(grepl(what, x, ...))
    structure(list(setNames(w, x[w])), location = "values")
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
        structure(setNames(.in_values(x, what, ...), "values"), class = "lookin")
}

lookin.character <- function(x, what, ...) {
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
    class = "lookin.character")
}

lookin.numeric <- function(x, what, ...) {
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
    class = "lookin.numeric")
}

lookin.logical <- function(x, what, ...) {
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
    class = "lookin.logical")
}

lookin.factor <- function(x, what, ...) {
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
    class = "lookin.factor")
}

lookin.data.frame <- function(x, what, ...) {
    if(class(x) != 'data.frame')
        stop("Object must be a data.frame")
    structure(list(attributes = .in_attributes(x, what, ...),
         comment = .in_comment(x, what, ...),
         variables = lapply(x, lookin, what = what, ...)), class = "lookin.data.frame")
}

lookin.list <- function(x, what, check.attributes = TRUE, ...) {
    out1 <- .in_comment(x, what, ...)
    a <- attributes(x)
    a$names <- NULL
    if(length(a)) {
        out1 <- list(comment = out1, attributes = .in_attributes(x, what, ...))
    } else {
        out1 <- list(comment = out1)
    }
    out2 <- list()
    for(i in length(x)) {
        out2[[i]] <- lookin(x[[i]], what, ...)
    }
    structure((c(out1, setNames(out2, names(x)))), class = "lookin.list")
}

lookin.pairlist <- function(x, what, ...) {
    out1 <- list()
    for(i in seq_along(x))
        out1[[i]] <- .in_values(as.character(x[[i]]), what, ...)
    out2 <- .in_values(names(x), what, ...)
    structure(c(names = out2, values = out1), class = "lookin.pairlist")
}

lookin.matrix <- function(x, what, ...) {
    if(class(x) != 'matrix')
        stop("Object must be a matrix")
    structure(
    c(setNames(.in_values(x, what, ...), "values"),
      setNames(.in_comment(x, what, ...), "comment"),
      if(!is.null(attributes(x))) .in_attributes(x, what, ...) else NULL),
    class = "lookin.matrix")
}

lookin.environment <- function(x, what, ...) {
    s <- ls(x)
    structure(list(comment = .in_comment(x, what, ...), 
         environment = lapply(s, lookin, what = what)),
         class = "lookin.environment")
}

lookin.function <- function(x, what, ...) {
    f <- lookin(formals(x), what, ...)
    b <- lookin(as.character(body(x)), what, ...)
    structure(list(arguments = f, body = b), class = "lookin.function")
}
