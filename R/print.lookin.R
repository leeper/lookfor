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
    } else {
        message("lookfor did not find '",attributes(x)$what,"' anywhere in '", attributes(x)$object, "'. Bummer!\n", sep = "")
    }
    invisible(x)
}

print.lookin.data.frame <- function(x, ...){
    lv <- sapply(x$variables, function(z) { if(length(z[["values"]]) | length(z[["comment"]])) { TRUE } else { FALSE } })
    aa <- any(rapply(x$attributes, length))
    ac <- any(rapply(x$comment, length))
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
    } else {
        message("lookfor did not find '",attributes(x)$what,"' anywhere in '", attributes(x)$object, "'. Bummer!\n", sep = "")
    }
    invisible(x)
}

print.lookin.pairlist <- function(x, ...){
    
    invisible(x)
}

print.lookin.matrix <- function(x, ...){
    
    invisible(x)
}

print.lookin.environment <- function(x, ...){
    
    invisible(x)
}

print.lookin.function <- function(x, ...){
    
    invisible(x)
}

#print.lookin.list <- function(x, ...){    
#    invisible(x)
#}
