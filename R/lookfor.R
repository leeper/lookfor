lookfor <- function(what, ls_opts = list(), ...){
    s <- do.call("ls", ls_opts)
    d <- lapply(s, lookin, what = what, ...)
    
    # return value should be a list with the string matching the search, along with details of its position
    # big challenge is doing this recursively because, e.g., lists of lists of dataframes would be really difficult to search
    
    class(d) <- 'lookfor'
    return(d)
}

print.lookfor <- function(x, ...){
    # something like:
    cat('Item\t\tLocation\n')
    for(i in seq_along(x))
        cat(x[[i]]$object, '\t\t', x[[i]]$location,'\n')
    return(invisible(x))
}

