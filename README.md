# lookfor: Find what you're looking for #

**lookfor** is an R port of Stata's `lookfor` command, which helps you find stuff you're looking for inside a dataset (e.g., variables, variable values, variable labels, etc.).

## Package Installation ##

[![CRAN](http://www.r-pkg.org/badges/version/lookfor)](http://cran.r-project.org/web/packages/lookfor/)
![Downloads](http://cranlogs.r-pkg.org/badges/lookfor)
[![Travis-CI Build Status](https://travis-ci.org/leeper/lookfor.png?branch=master)](https://travis-ci.org/leeper/lookfor)
[![Codecov](http://www.r-pkg.org/badges/version/lookfor)](http://cran.r-project.org/web/packages/lookfor/)
[![codecov.io](http://codecov.io/github/leeper/lookfor/coverage.svg?branch=master)](http://codecov.io/github/leeper/lookfor?branch=master)
[![Project Status: Wip - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)

The latest development version on GitHub can be installed using **devtools**:

```R
if(!require("devtools")){
    install.packages("devtools")
    library("devtools")
}
install_github("leeper/lookfor")
```

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


```r
options(width = 100)
```

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
##  Object Position  Match
##  X[[i]]        2 Alaska
```

```r
# look for variable
lookin(USArrests, "Assault")
```

```
## [1] Matches found for 'Assault' in attributes(USArrests):
## $names
##  Object Position   Match
##  X[[i]]        2 Assault
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
##  Object Position Match
##  X[[i]]       11  carb
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
```

```
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
## package:base                         9
```

```
## 
## Objects from Namespaces:
```

```
##       Namespace Object                                        Position in Namespace
##  [1,] tools     check_packages_in_dir                         33                   
##  [2,] tools     check_packages_in_dir_changes                 34                   
##  [3,] tools     check_packages_in_dir_details                 35                   
##  [4,] tools     check_packages_in_dir_results                 36                   
##  [5,] tools     check_packages_in_dir_results_summary         37                   
##  [6,] tools     CRAN_package_db                               73                   
##  [7,] tools     format.check_code_usage_in_package            110                  
##  [8,] tools     format.check_package_code_assign_to_globalenv 116                  
##  [9,] tools     format.check_package_code_attach              117                  
## [10,] tools     format.check_package_code_data_into_globalenv 118                  
## [11,] tools     format.check_package_code_startup_functions   119                  
## [12,] tools     format.check_package_code_unload_functions    120                  
## [13,] tools     format.check_package_CRAN_incoming            121                  
## [14,] tools     format.check_package_datasets                 122                  
## [15,] tools     format.check_package_depends                  123                  
## [16,] tools     format.check_package_description_encoding     124                  
## [17,] tools     format.check_package_description2             125                  
## [18,] tools     format.check_package_license                  126                  
## [19,] tools     format.check_packages_in_dir_changes          127                  
## [20,] tools     format.check_packages_used                    128                  
## [21,] tools     package.dependencies                          221                  
## [22,] tools     package_dependencies                          222                  
## [23,] tools     print.check_package_code_syntax               273                  
## [24,] tools     print.check_package_compact_datasets          274                  
## [25,] tools     print.check_package_description               275                  
## [26,] tools     print.check_packages_in_dir                   276                  
## [27,] tools     print.check_packages_in_dir_changes           277                  
## [28,] tools     Rd_package_author                             317                  
## [29,] tools     Rd_package_description                        318                  
## [30,] tools     Rd_package_DESCRIPTION                        319                  
## [31,] tools     Rd_package_indices                            320                  
## [32,] tools     Rd_package_maintainer                         321                  
## [33,] tools     Rd_package_title                              322                  
## [34,] tools     summarize_check_packages_in_dir_depends       384                  
## [35,] tools     summarize_check_packages_in_dir_results       385                  
## [36,] tools     summarize_check_packages_in_dir_timings       386                  
## [37,] tools     summary.check_packages_in_dir                 389                  
## [38,] tools     toHTML.packageIQR                             408                  
## [39,] tools     url_db_from_installed_packages                418                  
## [40,] tools     url_db_from_package_citation                  419                  
## [41,] tools     url_db_from_package_HTML_files                420                  
## [42,] tools     url_db_from_package_metadata                  421                  
## [43,] tools     url_db_from_package_news                      422                  
## [44,] tools     url_db_from_package_Rd_db                     423                  
## [45,] tools     url_db_from_package_README_md                 424                  
## [46,] tools     url_db_from_package_sources                   425                  
## [47,] utils     aspell_control_package_vignettes              32                   
## [48,] utils     aspell_package                                41                   
## [49,] utils     aspell_package_C_files                        42                   
## [50,] utils     aspell_package_description                    43                   
## [51,] utils     aspell_package_pot_files                      44                   
## [52,] utils     aspell_package_R_files                        45                   
## [53,] utils     aspell_package_Rd_files                       46                   
## [54,] utils     aspell_package_vignettes                      47                   
## [55,] utils     available.packages                            57                   
## [56,] utils     available_packages_filters_db                 58                   
## [57,] utils     available_packages_filters_default            59                   
## [58,] utils     CRAN.packages                                 152                  
## [59,] utils     download.packages                             166                  
## [60,] utils     filter_packages_by_depends_predicates         181                  
## [61,] utils     install.packages                              248                  
## [62,] utils     installed.packages                            249                  
## [63,] utils     make.packages.html                            261                  
## [64,] utils     new.packages                                  280                  
## [65,] utils     old.packages                                  285                  
## [66,] utils     package.skeleton                              286                  
## [67,] utils     packageDescription                            287                  
## [68,] utils     packageName                                   288                  
## [69,] utils     packageStatus                                 289                  
## [70,] utils     packageVersion                                290                  
## [71,] utils     print.packageDescription                      313                  
## [72,] utils     print.packageIQR                              314                  
## [73,] utils     print.packageStatus                           315                  
## [74,] utils     print.summary.packageStatus                   320                  
## [75,] utils     remove.packages                               354                  
## [76,] utils     summary.packageStatus                         411                  
## [77,] utils     update.packages                               448                  
## [78,] utils     update.packageStatus                          449                  
## [79,] utils     upgrade.packageStatus                         451                  
## [80,] knitr     has_package                                   93                   
## [81,] methods   packageSlot                                   196                  
## [82,] methods   packageSlot<-                                 197                  
## [83,] base      $.package_version                             11                   
## [84,] base      as.package_version                            211                  
## [85,] base      find.package                                  450                  
## [86,] base      format.packageInfo                            474                  
## [87,] base      is.package_version                            587                  
## [88,] base      package_version                               765                  
## [89,] base      packageEvent                                  766                  
## [90,] base      packageHasNamespace                           767                  
## [91,] base      packageStartupMessage                         768                  
## [92,] base      path.package                                  779                  
## [93,] base      print.packageInfo                             816
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
```

```
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
## [1] "X[[i]]"
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
## [1] "X[[i]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $model
## [1] Matches found for '[[:alpha:]]+ [[:digit:]]' in attributes(X[[i]]):
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
## [1] "X[[i]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $row.names
##  Object Position          Match
##  X[[i]]        3     Datsun 710
##  X[[i]]        4 Hornet 4 Drive
##  X[[i]]        7     Duster 360
##  X[[i]]        8      Merc 240D
##  X[[i]]        9       Merc 230
##  X[[i]]       10       Merc 280
##  X[[i]]       11      Merc 280C
##  X[[i]]       12     Merc 450SE
##  X[[i]]       13     Merc 450SL
##  X[[i]]       14    Merc 450SLC
##  X[[i]]       18       Fiat 128
##  X[[i]]       27  Porsche 914-2
##  X[[i]]       32     Volvo 142E
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
##  Object Position          Match
##  X[[i]]        3     Datsun 710
##  X[[i]]        4 Hornet 4 Drive
##  X[[i]]        7     Duster 360
##  X[[i]]        8      Merc 240D
##  X[[i]]        9       Merc 230
##  X[[i]]       10       Merc 280
##  X[[i]]       11      Merc 280C
##  X[[i]]       12     Merc 450SE
##  X[[i]]       13     Merc 450SL
##  X[[i]]       14    Merc 450SLC
##  X[[i]]       18       Fiat 128
##  X[[i]]       27  Porsche 914-2
##  X[[i]]       32     Volvo 142E
## 
## $class
## 
## [1] Matches found for '[[:alpha:]]+ [[:digit:]]' in attributes(mtcars):
## $names
## 
## $row.names
##  Object Position          Match
##  X[[i]]        3     Datsun 710
##  X[[i]]        4 Hornet 4 Drive
##  X[[i]]        7     Duster 360
##  X[[i]]        8      Merc 240D
##  X[[i]]        9       Merc 230
##  X[[i]]       10       Merc 280
##  X[[i]]       11      Merc 280C
##  X[[i]]       12     Merc 450SE
##  X[[i]]       13     Merc 450SL
##  X[[i]]       14    Merc 450SLC
##  X[[i]]       18       Fiat 128
##  X[[i]]       27  Porsche 914-2
##  X[[i]]       32     Volvo 142E
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
##  Object Position          Match
##  X[[i]]        3     Datsun 710
##  X[[i]]        4 Hornet 4 Drive
##  X[[i]]        7     Duster 360
##  X[[i]]        8      Merc 240D
##  X[[i]]        9       Merc 230
##  X[[i]]       10       Merc 280
##  X[[i]]       11      Merc 280C
##  X[[i]]       12     Merc 450SE
##  X[[i]]       13     Merc 450SL
##  X[[i]]       14    Merc 450SLC
##  X[[i]]       18       Fiat 128
##  X[[i]]       27  Porsche 914-2
##  X[[i]]       32     Volvo 142E
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
```

```
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

