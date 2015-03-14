print.lookin.character <- 
print.lookin.numeric <- 
print.lookin.logical <- 
print.lookin.factor <- 
function(x, ...){
    if(length(x$values) | length(x$comment)) {
        if(length(x$values)) {
            message("Matches found for '",attributes(x)$what,"' in '", attributes(x)$object, "':", sep = "")
            print(data.frame(Match = names(x$values), Position = x$values), row.names = FALSE)
        }
        if(length(x$comment)) {
            message("Matches found for '",attributes(x)$what,"' in comment(", attributes(x)$object, "):", sep = "")
            print(data.frame(Match = names(x$comment), Position = x$comment), row.names = FALSE)
        }
        # handle attributes...
    } else {
        message("lookfor did not find '",attributes(x)$what,"' anywhere in '", attributes(x)$object, "'. Bummer!\n", sep = "")
    }
    invisible(x)
}

print.lookin.data.frame <- function(x, ...){
    
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
