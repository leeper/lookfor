.in_values <- function(x, what, ignore.case = FALSE, ...) {
    w <- which(grepl(what, x, ...))
    structure(setNames(w, x[w]), location = "values")
}

.in_names <- function(x, what, ignore.case = FALSE, ...) {
    w <- which(grepl(what, names(x), ...))
    structure(setNames(w, names(x)[w]), location = "names")
}

.in_colnames <- function(x, what, ignore.case = FALSE, ...) {
    w <- which(grepl(what, colnames(x), ...))
    structure(setNames(w, colnames(x)[w]), location = "colnames")
}

.in_rownames <- function(x, what, ignore.case = FALSE, ...) {
    w <- which(grepl(what, rownames(x), ...))
    structure(setNames(w, rownames(x)[w]), location = "rownames")
}

.in_comment <- function(x, what, ignore.case = FALSE, ...) {
    w <- which(grepl(what, comment(x), ...))
    structure(setNames(w, comment(x)[w]), location = "comment")
}

.in_levels <- function(x, what, ignore.case = FALSE, ...) {
    w <- which(grepl(what, levels(x), ...))
    structure(setNames(w, levels(x)[w]), location = "levels")
}

.in_attributes <- function(x, what, ignore.case = FALSE, ...) {
    a <- attributes(x)
    a$class <- NULL
    a$levels <- NULL
    if(length(a))
        structure(lookin(a, what, ...), location = "attributes")
    else
        structure(NULL, location = "attributes")
}


lookin <- function(x, what, ...) UseMethod("lookin")

lookin.default <- function(x, what, ...) {
    
}

lookin.character <- function(x, what, ...){
    c(.in_values(x, what, ...),
      .in_comment(x, what, ...),
      #.in_attributes(x, what, ...),
      .in_names(x, what, ...))
}

lookin.numeric <- function(x, what, ...){
    c(.in_comment(x, what, ...),
      #.in_attributes(x, what, ...),
      .in_names(x, what, ...))
}

lookin.logical <- function(x, what, ...){
    c(.in_values(x, what, ...),
      .in_comment(x, what, ...),
      #.in_attributes(x, what, ...),
      .in_names(x, what, ...))
}

lookin.factor <- function(x, what, ...){
    c(.in_levels(x, what, ...),
      .in_comment(x, what, ...),
      #.in_attributes(x, what, ...),
      .in_names(x, what, ...))
}

lookin.data.frame <- function(x, what, ...){
    if(class(x) != 'data.frame')
        stop("Object must be a data.frame")
    c(.in_names(names(x), what, ...),
      #.in_attributes(x, what, ...),
      .in_comment(x, what, ...),
      sapply(x, lookin, ...))
}

lookin.list <- function(x, what, ...){
    c(.in_names(names(x), what, ...),
      #.in_attributes(x, what, ...),
      .in_comment(x, what, ...),
      sapply(x, lookin, ...))
}

lookin.matrix <- function(x, what, ...){
    if(class(x) != 'matrix')
        stop("Object must be a matrix")
    c(.in_rownames(x, what, ...),
      .in_colnames(x, what, ...),
      #.in_attributes(x, what, ...),
      .in_comment(x, what, ...),
      .in_values(x, what, ...))
}
