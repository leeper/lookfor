print.lookin.character <- 
print.lookin.numeric <- 
print.lookin.logical <- 
print.lookin.factor <- 
function(x, ...){
    if(length(x$values) | length(x$comment) | length(x$attributes)) {
        if(length(x$values)) {
            message("Matches found for '",attributes(x)$what,"' in '", attributes(x)$object, "':", sep = "")
            print(data.frame(Match = names(x$values), Position = x$values), row.names = FALSE)
        }
        if(length(x$attributes)) {
            message("Matches found for '",attributes(x)$what,"' in attributes(", attributes(x)$object, "):", sep = "")
            print(data.frame(Match = names(x$values), Position = x$values), row.names = FALSE)
        }
        if(length(x$comment)) {
            message("Matches found for '",attributes(x)$what,"' in comment(", attributes(x)$object, "):", sep = "")
            print(data.frame(Match = names(x$comment), Position = x$comment), row.names = FALSE)
        }
    } 
    invisible(x)
}

print.lookin.data.frame <- function(x, ...){
    lv <- sapply(x$variables, function(z) { if(length(z[["values"]]) | length(z[["comment"]])) { TRUE } else { FALSE } })
    aa <- any(unlist(rapply(x$attributes, length)))
    ac <- any(unlist(rapply(x$comment, length)))
    if(any(lv) | aa | ac) {
        if(any(lv)) {
            message("Matches found for '",attributes(x)$what,"' in '", attributes(x)$object, "':", sep = "")
            for(i in seq_along(x$variables)) {
                print(x$variables[[i]])
            }
        }
        if(aa) {
            message("Matches found for '",attributes(x)$what,"' in attributes(", attributes(x)$object, "):", sep = "")
            for(i in seq_along(x$attributes)) {
                print(x$attributes[[i]])
            }
        }
        if(ac) {
            message("Matches found for '",attributes(x)$what,"' in comment(", attributes(x)$object, "):", sep = "")
            print(data.frame(Match = names(x$comment), Position = x$comment), row.names = FALSE)
        }
    } 
    invisible(x)
}

print.lookin.pairlist <- function(x, ...){
    if(length(a$names)){
        print(data.frame(Match = names(a$names), Position = a$names), row.names = FALSE)
    }
    if(any(sapply(v, length))){
        print(data.frame(Match = names(a$names), Position = a$names), row.names = FALSE)
    }
    invisible(x)
}

print.lookin.matrix <- function(x, ...){
    
    invisible(x)
}

print.lookin.environment <- function(x, ...){
    for(i in seq_along(x$environment)) {
        print(x$environment[[i]])
    }
    if(length(x$comment)) {
        message("Matches found for '",attributes(x)$what,"' in comment(", attributes(x)$object, "):", sep = "")
        print(data.frame(Match = names(x$comment), Position = x$comment), row.names = FALSE)
    }
    invisible(x)
}

print.lookin.function <- function(x, ...){
    a <- x$arguments
    b <- x$body
    c <- x$comment
    if(any(rapply(a, length)) | any(rapply(b, length)) | any(rapply(c, length))) {
        if(any(rapply(a, length))) {
            message("Matches found for '",attributes(x)$what,"' in arguments for function `", attributes(x)$object, "`:", sep = "")
            print(a)
        }
        if(any(rapply(b, length))) {
            message("Matches found for '",attributes(x)$what,"' in in body of function `", attributes(x)$object, "`:", sep = "")
            print(data.frame(Match = paste0(substring(names(b$values), 1, 30), "..."), Line = b$values), row.names = FALSE)
        }
        if(any(rapply(c, length))) {
            message("Matches found for '",attributes(x)$what,"' in comment(", attributes(x)$object, "):", sep = "")
            print(data.frame(Match = names(x$comment), Position = x$comment), row.names = FALSE)
        }
    } 
    invisible(x)
}

print.lookin.list <- function(x, ...){    
    a <- x$attributes
    x$attributes <- NULL
    b <- x$comment
    x$comment <- NULL
    
    lv <- sapply(x, function(z) { if(length(z[["values"]]) | length(z[["comment"]])) { TRUE } else { FALSE } })
    if(length(a))
        aa <- any(unlist(rapply(a, length)))
    else
        aa <- FALSE
    ab <- any(unlist(rapply(b, length)))
    
    if(any(unlist(lv)) | aa | ab) {
        if(any(unlist(lv))) {
            message("Matches found for '",attributes(x)$what,"' in '", attributes(x)$object, "':", sep = "")
            for(i in seq_along(x)) {
                print(x[[i]])
            }
        }
        if(aa) {
            message("Matches found for '",attributes(x)$what,"' in attributes(", attributes(x)$object, "):", sep = "")
            for(i in seq_along(a)) {
                print(a[[i]])
            }
        }
        if(ab) {
            message("Matches found for '",attributes(x)$what,"' in comment(", attributes(x)$object, "):", sep = "")
            print(data.frame(Match = names(b), Position = b), row.names = FALSE)
        }
    } 
    invisible(x)
}
