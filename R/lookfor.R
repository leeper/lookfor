lookfor <- function(what, ls_opts = list(name = ".GlobalEnv"), ...){
    
    # list objects in 
    s <- do.call("ls", ls_opts)
    
    # look for objects from global environment
    s1 <- lookin(s, what)
    
    # look for objects in objects from global environment
    d <- lapply(mget(s, envir = parent.frame()), lookin, what = what, ...)
    
    # look for objects in loaded namespaces
    ns <- loadedNamespaces()
    ns <- ns[!ns == ".GlobalEnv"]
    ns_names <- lookin(ns, what, ...)
    in_ns <- setNames(lapply(ns, function(x) lookin(ls(asNamespace(x)), what = what, ...)), ns)
    
    # return value should be a list with the string matching the search, along with details of its position
    # big challenge is doing this recursively because, e.g., lists of lists of dataframes would be really difficult to search
    
    structure(list(environment = s1, objects = d, namespaces = ns_names, fromNamespaces = in_ns), class = "lookfor")
}

# print.lookfor <- function(x, ...){
#     anywhere <- rapply(x, function(z) if(length(z)) TRUE else FALSE, how = "replace")
#     for(i in seq_along(x))
#         cat(x[[i]]$object, '\t\t', x[[i]]$location,'\n')
#     return(invisible(x))
# }
