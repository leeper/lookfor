print.lookin.character <- 
print.lookin.numeric <- 
print.lookin.logical <- 
print.lookin.factor <- 
function(x, ...){
    a <- x$attributes
    b <- x$values
    com <- x$comment
    
    if(!is.null(a))
        aa <- any(unlist(rapply(a, length)))
    else
        aa <- FALSE
    if(!is.null(b))
        ab <- length(b)
    else
        ab <- FALSE
    if(!is.null(com))
        ac <- any(unlist(sapply(com, length)))
    else
        ac <- FALSE
    
    if(aa | ab | ac) {
        if(ab) {
            #print(paste0("Matches found for '",attributes(x)$what,"' in '", attributes(x)$object, "':", sep = ""), quote = FALSE)
            print(data.frame(Object = attributes(x)$object, Position = x$values, Match = names(x$values)), row.names = FALSE)
        }
        if(aa) {
            #print(paste0("Matches found for '",attributes(x)$what,"' in attributes(", attributes(x)$object, "):", sep = ""), quote = FALSE)
            print(data.frame(Object = paste0("attributes(", attributes(x)$object, ")"), 
                             Position = x$values, 
                             Match = names(x$values)), row.names = FALSE)
        }
        if(ac) {
            print(paste0("Matches found for '",attributes(x)$what,"' in comment(", attributes(x)$object, "):", sep = ""), quote = FALSE)
            print(x$comment)
        }
    } 
    invisible(x)
}

print.lookin.data.frame <- function(x, ...){
    a <- x$attributes
    b <- x$variables
    com <- x$comment
    
    if(!is.null(a))
        aa <- any(unlist(rapply(a, length)))
    else
        aa <- FALSE
    if(!is.null(b))
        ab <- any(unlist(rapply(b, length)))
    else
        ab <- FALSE
    if(!is.null(com))
        ac <- any(unlist(sapply(com, length)))
    else
        ac <- FALSE
    
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
    if(length(x$names)){
        print(data.frame(Object = attributes(x)$object, Position = x$names, Match = names(x$names)), row.names = FALSE)
    }
    if(any(sapply(v, length))){
        print(data.frame(Object = attributes(x)$object, Position = x$names, Match = names(x$names)), row.names = FALSE)
    }
    invisible(x)
}

print.lookin.matrix <- function(x, ...){
    
    invisible(x)
}

print.lookin.environment <- function(x, ...){
    a <- x$attributes
    b <- x$environment
    com <- x$comment
    
    if(!is.null(a))
        aa <- any(unlist(rapply(a, length)))
    else
        aa <- FALSE
    if(!is.null(b))
        ab <- any(unlist(rapply(b, length)))
    else
        ab <- FALSE
    if(!is.null(com))
        ac <- any(unlist(sapply(com, length)))
    else
        ac <- FALSE
    
    if(aa | ab | ac) {
        if(ab) {
            for(i in seq_along(x$environment)) {
                print(x$environment[[i]])
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
            print(c)
        }
    }
    invisible(x)
}

print.lookin.function <- function(x, ...){
    a <- x$arguments
    b <- x$body
    com <- x$comment
    
    if(!is.null(a))
        aa <- any(unlist(rapply(a, length)))
    else
        aa <- FALSE
    if(!is.null(b))
        ab <- any(unlist(rapply(b, length)))
    else
        ab <- FALSE
    if(!is.null(com))
        ac <- any(unlist(sapply(com, length)))
    else
        ac <- FALSE
    
    if(aa | ab | ac) {
        if(aa) {
            print(paste0("Matches found for '",attributes(x)$what,"' in arguments for function `", attributes(x)$object, "`:", sep = ""), quote = FALSE)
            print(a)
        }
        if(ab) {
            #print(paste0("Matches found for '",attributes(x)$what,"' in body of function `", attributes(x)$object, "`:", sep = ""), quote = FALSE)
            print(data.frame(Object = paste0("`", attributes(x)$object, "` function body"),
                             Line = b$values, 
                             Match = paste0(substring(names(b$values), 1, 40), " ...")), row.names = FALSE)
        }
        if(ac) {
            print(paste0("Matches found for '",attributes(x)$what,"' in comment(", attributes(x)$object, "):", sep = ""), quote = FALSE)
            print(c)
        }
    } 
    invisible(x)
}

print.lookin.list <- function(x, ...){    
    a <- x$attributes$values
    b <- x$values
    com <- x$comment
    
    if(!is.null(a))
        aa <- any(unlist(rapply(a, length)))
    else
        aa <- FALSE
    if(!is.null(b))
        ab <- any(unlist(rapply(b, length)))
    else
        ab <- FALSE
    if(!is.null(com))
        ac <- any(unlist(sapply(com, length)))
    else
        ac <- FALSE
    
    if(aa | ab | ac) {
        if(ab) {
            #print(paste0("Matches found for '",attributes(x)$what,"' in '", attributes(x)$object, "':", sep = ""), quote = FALSE)
            for(i in seq_along(x)) {
                print(x[[i]])
            }
        }
        if(aa) {
            print(paste0("Matches found for '",attributes(x)$what,"' in attributes(", attributes(x)$object, "):", sep = ""), quote = FALSE)
            print(a)
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
        print(data.frame(Position = x$values, Match = names(x$values)), row.names = FALSE)
}

print.lookin.lookin <- function(x, ...) {
    invisible(x)
}

print.lookin.lookfor <- function(x, ...) {
    invisible(x)
}
