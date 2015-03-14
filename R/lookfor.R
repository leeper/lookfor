lookfor <- function(what, ls_opts = list(name = ".GlobalEnv"), ...){
    
    # list objects in 
    s <- do.call("ls", ls_opts)
    
    # look for objects from global environment
    genv <- lookin(s, what)
    
    # look for objects in objects from global environment
    d <- lapply(mget(s, envir = .GlobalEnv), lookin, what = what, ...)
    
    # look for objects in loaded namespaces
    ns <- loadedNamespaces()
    ns_names <- lookin(ns, what, ...)
    in_ns <- setNames(lapply(ns, function(x) lookin(ls(asNamespace(x)), what = what, ...)), ns)
    
    # look for objects on search path
    search_path <- lookin(search(), what, ...)
    
    structure(list(what = what, 
                   environment = genv, 
                   objects = d, 
                   namespaces = ns_names, 
                   fromNamespaces = in_ns,
                   search = search_path),
              class = "lookfor")
}
