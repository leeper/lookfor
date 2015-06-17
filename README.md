# lookfor: Find what you're looking for #

**lookfor** is an R port of Stata's `lookfor` command, which helps you find stuff you're looking for inside a dataset (e.g., variables, variable values, variable labels, etc.).

## Package Installation ##

The package might be available on [CRAN](http://cran.r-project.org/web/packages/lookfor/) and can be installed directly in R using:

```R
install.packages("lookfor")
```

The latest development version on GitHub can be installed using **devtools**:

```R
if(!require("devtools")){
    install.packages("devtools")
    library("devtools")
}
install_github("leeper/lookfor")
```

[![Build Status](https://travis-ci.org/leeper/lookfor.png?branch=master)](https://travis-ci.org/leeper/lookfor)

## Examples ##

Stata's `lookfor` command searches variables and variable labels for an exact matching text string:

```
. webuse auto
(1978 Automobile Data)

. lookfor weight

              storage   display    value
variable name   type    format     label      variable label
---------------------------------------------------------------------
weight          int     %8.0gc                Weight (lbs.)

. lookfor ft

              storage   display    value
variable name   type    format     label      variable label
---------------------------------------------------------------------
trunk           int     %8.0g                 Trunk space (cu. ft.)
turn            int     %8.0g                 Turn Circle (ft.)
```

This is helpful and something easily replicated by searching within the `names` attribute of a data.frame. But R allows multiple objects to be present at one time, meaning that it would be time consuming to `grep` the names of all data.frames that might be active in memory at any given point in time. Similarly, those R objects are also themselves named, have numerous other attributes (`rownames`, `colnames`, `levels`, `class`, etc.), and might be stored within lists or environments. While the `lookfor` command in Stata is helpful, it's actually solving a relatively simple problem. Porting `lookfor` to R requires a much more robust solution for searching many different features of potentially numerous data objects stored in various parts of the R environment.

The major weakness of Stata's `lookfor` command is that it relies only on a plain text, exact matching search algorithm. This makes it difficult to search for variables or labels that match a pattern (e.g., a pattern that might easily be described by a regular expression). As a result, the R port uses `grepl` to find matches, meaning that regular expressions are used by default when trying to find something and arguments can be passed via `...` to control the behavior of `grepl` (e.g., setting `fixed=TRUE` will match an exact string, and `perl=TRUE` will use Perl-style regular expressions).

### Look in a data.frame ###

A basic use case is to search for an observation or a variable within a dataset.


```r
library("lookfor")
data(USArrests)

# look for observation
lookin(USArrests, "Alaska")
```

```
## [1] Matches found for 'Alaska' in attributes(USArrests):
## $names
## 
## $class
## 
## $row.names
##   Object Position  Match
##  X[[3L]]        2 Alaska
```

```r
# look for variable
lookin(USArrests, "Assault")
```

```
## [1] Matches found for 'Assault' in attributes(USArrests):
## $names
##   Object Position   Match
##  X[[1L]]        2 Assault
## 
## $class
## 
## $row.names
```


### Look in an environment ###

Relatedly, it is possible to search for objects within an environment (and values or attributes within those objects).


```r
x <- new.env()
x$mtcars <- mtcars
x$cars <- letters[1:10]
x$cards <- 1:5
lookin(x, "car")
```

```
## [1] Matches found for 'car' in attributes(mtcars):
## $names
##   Object Position Match
##  X[[1L]]       11  carb
## 
## $row.names
## 
## $class
```


### Look in a list ###

And the same can be applied to a potentially deeply nested list.


```r
m <- lm(mpg ~ cyl, data = mtcars)
lookin(m, "mpg")
```

```
## Error in setNames(w, x[w]): attempt to apply non-function
```


### Look everywhere ###

Lastly, the `lookfor` command can be used to look anywhere (within `.GlobalEnv`, the R search path, objects within objects on the search path, loaded namespaces, etc.).


```r
lookfor("package")
```

```
## lookfor found matches for 'package' in the following locations...
## 
## Objects on search() path:
```

```
##                   Position in search()
## package:lookfor                      2
## package:stats                        3
## package:graphics                     4
## package:grDevices                    5
## package:utils                        6
## package:datasets                     7
## package:devtools                     8
## package:methods                      9
## package:base                        11
```

```
## 
## Objects from Namespaces:
```

```
##        Namespace Object                                       
##   [1,] base      $.package_version                            
##   [2,] base      as.package_version                           
##   [3,] base      find.package                                 
##   [4,] base      format.packageInfo                           
##   [5,] base      is.package_version                           
##   [6,] base      package_version                              
##   [7,] base      packageEvent                                 
##   [8,] base      packageHasNamespace                          
##   [9,] base      packageStartupMessage                        
##  [10,] base      path.package                                 
##  [11,] base      print.packageInfo                            
##  [12,] devtools  add_desc_package                             
##  [13,] devtools  as.package                                   
##  [14,] devtools  available_packages                           
##  [15,] devtools  bioc_packages                                
##  [16,] devtools  check_package_name                           
##  [17,] devtools  check_summary_package                        
##  [18,] devtools  cran_packages                                
##  [19,] devtools  dev_package_deps                             
##  [20,] devtools  dev_packages                                 
##  [21,] devtools  extract_package_name                         
##  [22,] devtools  install_packages                             
##  [23,] devtools  is.package                                   
##  [24,] devtools  loaded_packages                              
##  [25,] devtools  package_deps                                 
##  [26,] devtools  package_find_repo                            
##  [27,] devtools  package_info                                 
##  [28,] devtools  package_root                                 
##  [29,] devtools  package_url                                  
##  [30,] devtools  packages                                     
##  [31,] devtools  print.package_deps                           
##  [32,] devtools  print.packages_info                          
##  [33,] devtools  update.package_deps                          
##  [34,] devtools  update_packages                              
##  [35,] devtools  use_package                                  
##  [36,] devtools  use_package_doc                              
##  [37,] git2r     bundle_r_package                             
##  [38,] httr      need_package                                 
##  [39,] knitr     has_package                                  
##  [40,] methods   packageSlot                                  
##  [41,] methods   packageSlot<-                                
##  [42,] Rcpp      Rcpp.package.skeleton                        
##  [43,] tools     check_packages_in_dir                        
##  [44,] tools     check_packages_in_dir_details                
##  [45,] tools     check_packages_in_dir_results                
##  [46,] tools     format.check_code_usage_in_package           
##  [47,] tools     format.check_package_code_assign_to_globalenv
##  [48,] tools     format.check_package_code_attach             
##  [49,] tools     format.check_package_code_data_into_globalenv
##  [50,] tools     format.check_package_code_startup_functions  
##  [51,] tools     format.check_package_code_unload_functions   
##  [52,] tools     format.check_package_CRAN_incoming           
##  [53,] tools     format.check_package_datasets                
##  [54,] tools     format.check_package_depends                 
##  [55,] tools     format.check_package_description_encoding    
##  [56,] tools     format.check_package_description2            
##  [57,] tools     format.check_package_license                 
##  [58,] tools     format.check_packages_used                   
##  [59,] tools     package.dependencies                         
##  [60,] tools     package_dependencies                         
##  [61,] tools     print.check_package_code_syntax              
##  [62,] tools     print.check_package_compact_datasets         
##  [63,] tools     print.check_package_description              
##  [64,] tools     summarize_check_packages_in_dir_depends      
##  [65,] tools     summarize_check_packages_in_dir_results      
##  [66,] tools     summarize_check_packages_in_dir_timings      
##  [67,] tools     toHTML.packageIQR                            
##  [68,] utils     aspell_control_package_vignettes             
##  [69,] utils     aspell_package_C_files                       
##  [70,] utils     aspell_package_description                   
##  [71,] utils     aspell_package_pot_files                     
##  [72,] utils     aspell_package_R_files                       
##  [73,] utils     aspell_package_Rd_files                      
##  [74,] utils     aspell_package_vignettes                     
##  [75,] utils     available.packages                           
##  [76,] utils     available_packages_filters_db                
##  [77,] utils     available_packages_filters_default           
##  [78,] utils     CRAN.packages                                
##  [79,] utils     download.packages                            
##  [80,] utils     filter_packages_by_depends_predicates        
##  [81,] utils     install.packages                             
##  [82,] utils     installed.packages                           
##  [83,] utils     make.packages.html                           
##  [84,] utils     new.packages                                 
##  [85,] utils     old.packages                                 
##  [86,] utils     package.skeleton                             
##  [87,] utils     packageDescription                           
##  [88,] utils     packageName                                  
##  [89,] utils     packageStatus                                
##  [90,] utils     packageVersion                               
##  [91,] utils     print.packageDescription                     
##  [92,] utils     print.packageIQR                             
##  [93,] utils     print.packageStatus                          
##  [94,] utils     print.summary.packageStatus                  
##  [95,] utils     remove.packages                              
##  [96,] utils     summary.packageStatus                        
##  [97,] utils     update.packages                              
##  [98,] utils     update.packageStatus                         
##  [99,] utils     upgrade.packageStatus                        
##        Position in Namespace
##   [1,] 11                   
##   [2,] 207                  
##   [3,] 438                  
##   [4,] 461                  
##   [5,] 572                  
##   [6,] 747                  
##   [7,] 748                  
##   [8,] 749                  
##   [9,] 750                  
##  [10,] 761                  
##  [11,] 797                  
##  [12,] 5                    
##  [13,] 15                   
##  [14,] 20                   
##  [15,] 22                   
##  [16,] 44                   
##  [17,] 46                   
##  [18,] 66                   
##  [19,] 79                   
##  [20,] 80                   
##  [21,] 98                   
##  [22,] 160                  
##  [23,] 169                  
##  [24,] 190                  
##  [25,] 206                  
##  [26,] 207                  
##  [27,] 208                  
##  [28,] 209                  
##  [29,] 210                  
##  [30,] 211                  
##  [31,] 225                  
##  [32,] 226                  
##  [33,] 327                  
##  [34,] 328                  
##  [35,] 342                  
##  [36,] 343                  
##  [37,] 14                   
##  [38,] 99                   
##  [39,] 87                   
##  [40,] 193                  
##  [41,] 194                  
##  [42,] 67                   
##  [43,] 32                   
##  [44,] 33                   
##  [45,] 34                   
##  [46,] 95                   
##  [47,] 101                  
##  [48,] 102                  
##  [49,] 103                  
##  [50,] 104                  
##  [51,] 105                  
##  [52,] 106                  
##  [53,] 107                  
##  [54,] 108                  
##  [55,] 109                  
##  [56,] 110                  
##  [57,] 111                  
##  [58,] 112                  
##  [59,] 196                  
##  [60,] 197                  
##  [61,] 246                  
##  [62,] 247                  
##  [63,] 248                  
##  [64,] 344                  
##  [65,] 345                  
##  [66,] 346                  
##  [67,] 365                  
##  [68,] 32                   
##  [69,] 41                   
##  [70,] 42                   
##  [71,] 43                   
##  [72,] 44                   
##  [73,] 45                   
##  [74,] 46                   
##  [75,] 56                   
##  [76,] 57                   
##  [77,] 58                   
##  [78,] 151                  
##  [79,] 165                  
##  [80,] 180                  
##  [81,] 241                  
##  [82,] 242                  
##  [83,] 253                  
##  [84,] 272                  
##  [85,] 277                  
##  [86,] 278                  
##  [87,] 279                  
##  [88,] 280                  
##  [89,] 281                  
##  [90,] 282                  
##  [91,] 304                  
##  [92,] 305                  
##  [93,] 306                  
##  [94,] 311                  
##  [95,] 345                  
##  [96,] 401                  
##  [97,] 438                  
##  [98,] 439                  
##  [99,] 441
```

```
## 
```

### Look using regular expression ###

As noted above, Stata's `lookfor` command can only match exact/partial character strings. The R port by uses `grepl`, meaning that regular expressions are supported by default, thus allowing for complex pattern matching.


```r
data(mtcars)

# Look for car names containing letters and numbers (anywhere)
lookfor("[[:alpha:]]+ [[:digit:]]")
```

```
## lookfor found matches for '[[:alpha:]]+ [[:digit:]]' in the following locations...
## 
## Within objects from global environment:
```

```
## $coefficients
## 
## $residuals
## 
## $effects
## 
## $rank
## 
## $fitted.values
## 
## $assign
## 
## $qr
## $qr
## 
## $qraux
## 
## $pivot
## 
## $tol
## 
## $rank
## 
## [[1]]
## 
## [[2]]
## 
## 
## $df.residual
## 
## $xlevels
## 
## $call
## $values
## integer(0)
## 
## attr(,"location")
## [1] "values"
## attr(,"class")
## [1] "lookin"
## attr(,"object")
## [1] "X[[10L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $terms
## $values
## integer(0)
## 
## attr(,"location")
## [1] "values"
## attr(,"class")
## [1] "lookin"
## attr(,"object")
## [1] "X[[11L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $model
## [1] Matches found for '[[:alpha:]]+ [[:digit:]]' in attributes(X[[12L]]):
## $names
## 
## $terms
## $values
## integer(0)
## 
## attr(,"location")
## [1] "values"
## attr(,"class")
## [1] "lookin"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $row.names
##   Object Position          Match
##  X[[3L]]        3     Datsun 710
##  X[[3L]]        4 Hornet 4 Drive
##  X[[3L]]        7     Duster 360
##  X[[3L]]        8      Merc 240D
##  X[[3L]]        9       Merc 230
##  X[[3L]]       10       Merc 280
##  X[[3L]]       11      Merc 280C
##  X[[3L]]       12     Merc 450SE
##  X[[3L]]       13     Merc 450SL
##  X[[3L]]       14    Merc 450SLC
##  X[[3L]]       18       Fiat 128
##  X[[3L]]       27  Porsche 914-2
##  X[[3L]]       32     Volvo 142E
## 
## $class
## 
## 
## [[1]]
## 
## [[2]]
## 
## [1] Matches found for '[[:alpha:]]+ [[:digit:]]' in attributes(mtcars):
## $names
## 
## $row.names
##   Object Position          Match
##  X[[2L]]        3     Datsun 710
##  X[[2L]]        4 Hornet 4 Drive
##  X[[2L]]        7     Duster 360
##  X[[2L]]        8      Merc 240D
##  X[[2L]]        9       Merc 230
##  X[[2L]]       10       Merc 280
##  X[[2L]]       11      Merc 280C
##  X[[2L]]       12     Merc 450SE
##  X[[2L]]       13     Merc 450SL
##  X[[2L]]       14    Merc 450SLC
##  X[[2L]]       18       Fiat 128
##  X[[2L]]       27  Porsche 914-2
##  X[[2L]]       32     Volvo 142E
## 
## $class
## 
## [1] Matches found for '[[:alpha:]]+ [[:digit:]]' in attributes(mtcars):
## $names
## 
## $row.names
##   Object Position          Match
##  X[[2L]]        3     Datsun 710
##  X[[2L]]        4 Hornet 4 Drive
##  X[[2L]]        7     Duster 360
##  X[[2L]]        8      Merc 240D
##  X[[2L]]        9       Merc 230
##  X[[2L]]       10       Merc 280
##  X[[2L]]       11      Merc 280C
##  X[[2L]]       12     Merc 450SE
##  X[[2L]]       13     Merc 450SL
##  X[[2L]]       14    Merc 450SLC
##  X[[2L]]       18       Fiat 128
##  X[[2L]]       27  Porsche 914-2
##  X[[2L]]       32     Volvo 142E
## 
## $class
```

```
## 
```

```r
# Look for car names containing letters and numbers (in mtcars)
lookin(mtcars, "[[:alpha:]]+ [[:digit:]]")
```

```
## [1] Matches found for '[[:alpha:]]+ [[:digit:]]' in attributes(mtcars):
## $names
## 
## $row.names
##   Object Position          Match
##  X[[2L]]        3     Datsun 710
##  X[[2L]]        4 Hornet 4 Drive
##  X[[2L]]        7     Duster 360
##  X[[2L]]        8      Merc 240D
##  X[[2L]]        9       Merc 230
##  X[[2L]]       10       Merc 280
##  X[[2L]]       11      Merc 280C
##  X[[2L]]       12     Merc 450SE
##  X[[2L]]       13     Merc 450SL
##  X[[2L]]       14    Merc 450SLC
##  X[[2L]]       18       Fiat 128
##  X[[2L]]       27  Porsche 914-2
##  X[[2L]]       32     Volvo 142E
## 
## $class
```

### Search `comment()` values ###

R's `comment()` function is an underutilized feature that allows users to attach hidden comments to R objects. This is intended (see `? comment`) for helping to annotate R objects with relevant metadata. The value of `comment()` for an object is `NULL` unless it has been set, in which case it is usually a character vector of length 1 (or possibly greater). `lookfor` searches `comment()` values automatically, allowing you to make better use of these annotations.


```r
m1 <- lm(mpg ~ cyl, data = mtcars)
comment(m1) <- "model using continuous cylinder"

m2 <- lm(mpg ~ factor(cyl), data = mtcars)
comment(m2) <- "model using factor of cylinder"

lookfor("model using", fixed = TRUE)
```

```
## lookfor found matches for 'model using' in the following locations...
## 
## Within objects from global environment:
```

```
## [1] Matches found for 'model using' in comment(x):
## function (..., recursive = FALSE)  .Primitive("c")
## [1] Matches found for 'model using' in comment(x):
## function (..., recursive = FALSE)  .Primitive("c")
```

```
## 
```

