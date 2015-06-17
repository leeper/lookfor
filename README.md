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
```

```
## 
## Attaching package: 'lookfor'
## 
## The following objects are masked _by_ '.GlobalEnv':
## 
##     lookfor, lookin
```

```r
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
data(mtcars)
lookfor("Mazda")
```

```
## lookfor found matches for 'Mazda' in the following locations...
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
##   Object Position         Match
##  X[[3L]]        1     Mazda RX4
##  X[[3L]]        2 Mazda RX4 Wag
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
##   Object Position         Match
##  X[[2L]]        1     Mazda RX4
##  X[[2L]]        2 Mazda RX4 Wag
## 
## $class
## 
## [1] Matches found for 'Mazda' in attributes(mtcars):
## $names
## 
## $row.names
##   Object Position         Match
##  X[[2L]]        1     Mazda RX4
##  X[[2L]]        2 Mazda RX4 Wag
## 
## $class
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
## 
## $attributes
## $values
## $names
## 
## $row.names
## $values
## 
## $comment
## 
## [[1]]
## 
## [[2]]
## 
## [[3]]
## 
## [[4]]
## 
## 
## $class
## 
## [[1]]
## 
## 
## [[1]]
## 
## [[2]]
## 
## [[3]]
## 
## [[4]]
## 
## [[5]]
## 
## 
## $comment
## 
## $variables
## 
## [[1]]
## 
## [[2]]
## 
## [[3]]
## 
## [[4]]
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

