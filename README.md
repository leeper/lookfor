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
## [1] Matches found for 'Alaska' in 'X[[3L]]':
##   Match Position
##  Alaska        2
```

```r
# look for variable
lookin(USArrests, "Assault")
```

```
## [1] Matches found for 'Assault' in attributes(USArrests):
## $names
## [1] Matches found for 'Assault' in 'X[[1L]]':
##    Match Position
##  Assault        2
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
## [1] Matches found for 'car' in 'X[[1L]]':
##  Match Position
##   carb       11
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
data(mtcars)
lookfor("Mazda")
```

```
## [1] lookfor found matches for 'Mazda' in the following locations...
## Within objects from global environment:
## [1] Matches found for 'Mazda' in 'x':
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
## [1] Matches found for 'Mazda' in 'x':
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
## [1] "Mazda"
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
## [1] "Mazda"
## 
## $model
## [1] Matches found for 'Mazda' in attributes(X[[12L]]):
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
## [1] "Mazda"
## 
## $row.names
## [1] Matches found for 'Mazda' in 'X[[3L]]':
##          Match Position
##      Mazda RX4        1
##  Mazda RX4 Wag        2
## 
## $class
## 
## 
## [[1]]
## 
## [[2]]
## 
## [1] Matches found for 'Mazda' in attributes(mtcars):
## $names
## 
## $row.names
## [1] Matches found for 'Mazda' in 'X[[2L]]':
##          Match Position
##      Mazda RX4        1
##  Mazda RX4 Wag        2
## 
## $class
## 
## [1] Matches found for 'Mazda' in attributes(mtcars):
## $names
## 
## $row.names
## [1] Matches found for 'Mazda' in 'X[[2L]]':
##          Match Position
##      Mazda RX4        1
##  Mazda RX4 Wag        2
## 
## $class
```

### Look using regular expression ###

As noted above, Stata's `lookfor` command can only match exact/partial character strings. The R port by uses `grepl`, meaning that regular expressions are supported by default, thus allowing for complex pattern matching.


```r
data(mtcars)

# Look for car names containing letters and numbers (anywhere)
lookfor("[[:alpha:]]+ [[:digit:]]")
```

```
## [1] lookfor found matches for '[[:alpha:]]+ [[:digit:]]' in the following locations...
## Within objects from global environment:
## [1] Matches found for '[[:alpha:]]+ [[:digit:]]' in 'x':
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
## [1] Matches found for '[[:alpha:]]+ [[:digit:]]' in 'x':
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
## [1] Matches found for '[[:alpha:]]+ [[:digit:]]' in 'X[[3L]]':
##           Match Position
##      Datsun 710        3
##  Hornet 4 Drive        4
##      Duster 360        7
##       Merc 240D        8
##        Merc 230        9
##        Merc 280       10
##       Merc 280C       11
##      Merc 450SE       12
##      Merc 450SL       13
##     Merc 450SLC       14
##        Fiat 128       18
##   Porsche 914-2       27
##      Volvo 142E       32
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
## [1] Matches found for '[[:alpha:]]+ [[:digit:]]' in 'X[[2L]]':
##           Match Position
##      Datsun 710        3
##  Hornet 4 Drive        4
##      Duster 360        7
##       Merc 240D        8
##        Merc 230        9
##        Merc 280       10
##       Merc 280C       11
##      Merc 450SE       12
##      Merc 450SL       13
##     Merc 450SLC       14
##        Fiat 128       18
##   Porsche 914-2       27
##      Volvo 142E       32
## 
## $class
## 
## [1] Matches found for '[[:alpha:]]+ [[:digit:]]' in attributes(mtcars):
## $names
## 
## $row.names
## [1] Matches found for '[[:alpha:]]+ [[:digit:]]' in 'X[[2L]]':
##           Match Position
##      Datsun 710        3
##  Hornet 4 Drive        4
##      Duster 360        7
##       Merc 240D        8
##        Merc 230        9
##        Merc 280       10
##       Merc 280C       11
##      Merc 450SE       12
##      Merc 450SL       13
##     Merc 450SLC       14
##        Fiat 128       18
##   Porsche 914-2       27
##      Volvo 142E       32
## 
## $class
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
## [1] Matches found for '[[:alpha:]]+ [[:digit:]]' in 'X[[2L]]':
##           Match Position
##      Datsun 710        3
##  Hornet 4 Drive        4
##      Duster 360        7
##       Merc 240D        8
##        Merc 230        9
##        Merc 280       10
##       Merc 280C       11
##      Merc 450SE       12
##      Merc 450SL       13
##     Merc 450SLC       14
##        Fiat 128       18
##   Porsche 914-2       27
##      Volvo 142E       32
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
## [1] lookfor found matches for 'model using' in the following locations...
## Within objects from global environment:
## [1] Matches found for 'model using' in attributes(x):
## [1] Matches found for 'model using' in 'comment':
##                            Match Position
##  model using continuous cylinder        1
## [1] Matches found for 'model using' in comment(x):
## function (..., recursive = FALSE)  .Primitive("c")
## [1] Matches found for 'model using' in attributes(x):
## [1] Matches found for 'model using' in 'comment':
##                           Match Position
##  model using factor of cylinder        1
## [1] Matches found for 'model using' in comment(x):
## function (..., recursive = FALSE)  .Primitive("c")
```

