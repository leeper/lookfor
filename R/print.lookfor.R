print.lookfor <- function(x, ...){
    checkany <- function(obj) {
        rapply(obj, function(z) if(length(z)) rep(TRUE, length(z)) else FALSE, how = "replace")
    }
    any_environment <- checkany(x$environment)
    any_objects <- checkany(x$objects)
    any_namespaces <- checkany(x$namespaces)
    any_fromNamespaces <- checkany(x$fromNamespaces)
    any_search <- checkany(x$search)
    if((sum(unlist(any_environment)) + 
        sum(unlist(any_objects)) + 
        sum(unlist(any_namespaces)) + 
        sum(unlist(any_fromNamespaces)) +
        sum(unlist(any_search))) == 0) {
        message("lookfor did not find '",x$what,"' anywhere. Bummer!\n", sep = "")
        return(invisible(x))
    } else {
        message("lookfor found matches for '",x$what,"' in the following locations...\n", sep = "")
    }
    if(any(unlist(any_environment))) {
        cat("Global environment objects:\n")
        if(length(x$environment$values)) {
            print(setNames(as.data.frame(x$environment$values), "Position in ls()"))
        }
        cat("\n")
    }
    if(any(unlist(any_objects))) {
        cat("Within objects from global environment:\n")
        
        # method dispatch on all the lookin.* objects
        #for(i in seq_along(x$objects)) {
            #print(x$objects[[i]])
        #}
        
        cat("coming soon...\n\n")
    }
    if(any(unlist(any_search))) {
        cat("Objects on search() path:\n")
        if(length(x$search$values)) {
            print(setNames(as.data.frame(x$search$values), "Position in search()"))
        }
        cat("\n")
    }
    if(any(unlist(any_namespaces))) {
        cat("Namespaces:\n")
        if(length(x$namespaces$values)) {
            print(setNames(as.data.frame(x$namespaces$values), "Position in loadedNamespaces()"))
        }
        cat("\n")
    }
    if(any(unlist(any_fromNamespaces))) {
        cat("Objects from Namespaces:\n")
        tmp <- matrix(character(), nrow = sum(unlist(any_fromNamespaces)), ncol = 4)
        colnames(tmp) <- c("Namespace", "Object", "Position in Namespace", "Comment")
        j <- 1
        for(i in seq_along(x$fromNamespaces)) {
            lv <- length(x$fromNamespaces[[i]]$values)
            if(lv) {
                tmplen <- length(x$fromNamespaces[[i]]$values)
                index <- if(tmplen > 1) j:(j+tmplen-1) else j
                tmp[index,"Namespace"] <- names(x$fromNamespaces)[i]
                tmp[index,"Object"] <- names(x$fromNamespaces[[i]]$values)
                tmp[index,"Position in Namespace"] <- x$fromNamespaces[[i]]$values
                #tmp[index,"Value"] <- as.character(x$fromNamespaces[[i]]$values)
                tmp[index,"Comment"] <- ""
                j <- j + max(index)
            }
        }
        if(nrow(tmp) > 0) {
            if(all(tmp[,"Comment"] == ""))
                tmp <- tmp[,-4]
            print(tmp, quote = FALSE, row.names = FALSE)
        }
        cat("\n")
    }
    #anywhere <- rapply(x, I)
    #print(anywhere)
    invisible(x)
}