print.lookin.character <- 
print.lookin.numeric <- 
print.lookin.logical <- 
print.lookin.factor <- 
function(x, ...){
    if(length(x$values) | length(x$comment) | length(x$attributes)) {
        if(length(x$values)) {
            print(paste0("Matches found for '",attributes(x)$what,"' in '", attributes(x)$object, "':", sep = ""), quote = FALSE)
            print(data.frame(Match = names(x$values), Position = x$values), row.names = FALSE)
        }
        if(any(rapply(x$attributes, length))) {
            print(paste0("Matches found for '",attributes(x)$what,"' in attributes(", attributes(x)$object, "):", sep = ""), quote = FALSE)
            print(data.frame(Match = names(x$values), Position = x$values), row.names = FALSE)
        }
        if(length(x$comment)) {
            print(paste0("Matches found for '",attributes(x)$what,"' in comment(", attributes(x)$object, "):", sep = ""), quote = FALSE)
            print(x$comment)
        }
    } 
    invisible(x)
}

print.lookin.data.frame <- function(x, ...){
    a <- x$attributes
    b <- x$variables
    c <- x$comment
    
    aa <- any(unlist(rapply(a, length)))
    ab <- any(unlist(rapply(b, length)))
    ac <- any(unlist(rapply(c, length)))
    
    if(aa | ab | ac) {
        if(ab) {
            print(paste0("Matches found for '",attributes(x)$what,"' in '", attributes(x)$object, "':", sep = ""), quote = FALSE)
            for(i in seq_along(x$variables)) {
                print(x$variables[[i]])
            }
        }
        if(aa) {
            print(paste0("Matches found for '",attributes(x)$what,"' in attributes(", attributes(x)$object, "):", sep = ""), quote = FALSE)
            for(i in seq_along(x$attributes)) {
                print(x$attributes[[i]])
            }
        }
        if(ac) {
            print(paste0("Matches found for '",attributes(x)$what,"' in comment(", attributes(x)$object, "):", sep = ""), quote = FALSE)
            print(x$comment)
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
        print(paste0("Matches found for '",attributes(x)$what,"' in comment(", attributes(x)$object, "):", sep = ""), quote = FALSE)
        print(c)
    }
    invisible(x)
}

print.lookin.function <- function(x, ...){
    a <- x$arguments
    b <- x$body
    c <- x$comment
    if(any(rapply(a, length)) | any(rapply(b, length)) | any(rapply(c, length))) {
        if(any(rapply(a, length))) {
            print(paste0("Matches found for '",attributes(x)$what,"' in arguments for function `", attributes(x)$object, "`:", sep = ""), quote = FALSE)
            print(a)
        }
        if(any(rapply(b, length))) {
            print(paste0("Matches found for '",attributes(x)$what,"' in in body of function `", attributes(x)$object, "`:", sep = ""), quote = FALSE)
            print(data.frame(Match = paste0(substring(names(b$values), 1, 40), " ..."), Line = b$values), row.names = FALSE)
        }
        if(any(rapply(c, length))) {
            print(paste0("Matches found for '",attributes(x)$what,"' in comment(", attributes(x)$object, "):", sep = ""), quote = FALSE)
            print(c)
        }
    } 
    invisible(x)
}

print.lookin.list <- function(x, ...){    
    a <- x$attributes
    b <- x$values
    c <- x$comment
    
    aa <- any(unlist(rapply(a, length)))
    ab <- any(unlist(rapply(b, length)))
    ac <- any(unlist(rapply(c, length)))
    
    if(aa | ab | ac) {
        if(ab) {
            print(paste0("Matches found for '",attributes(x)$what,"' in '", attributes(x)$object, "':", sep = ""), quote = FALSE)
            for(i in seq_along(x)) {
                print(x[[i]])
            }
        }
        if(aa) {
            print(paste0("Matches found for '",attributes(x)$what,"' in attributes(", attributes(x)$object, "):", sep = ""), quote = FALSE)
            for(i in seq_along(a)) {
                print(a[[i]])
            }
        }
        if(ac) {
            print(paste0("Matches found for '",attributes(x)$what,"' in comment(", attributes(x)$object, "):", sep = ""), quote = FALSE)
            print(c)
        }
    } 
    invisible(x)
}

print.lookin.comment <- function(x, ...) {
    if(length(x$values))
        print(data.frame(Match = names(x$values), Position = x$values), row.names = FALSE)
}

print.lookin.lookin <- function(x, ...) {
    invisible(x)
}

print.lookin.lookfor <- function(x, ...) {
    invisible(x)
}
