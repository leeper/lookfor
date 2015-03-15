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

The major weakness of Stata's `lookfor` command is that it relies only on a plain text, exact matching search algorithm. This makes it difficult to search for variables or labels that match a pattern (e.g., a pattern that migth easily be described by a regular expression). As a result, the R port uses `grepl` to find matches, meaning that regular expressions are used by default when trying to find something.

### Look in a data.frame ###


```r
library("lookfor")
```

```
## Error in library("lookfor"): there is no package called 'lookfor'
```

```r
data(USArrests)

# look for observation
lookin(USArrests, "Alaska")
```

```
## Matches found for 'Alaska' in attributes(USArrests):
## lookfor did not find 'Alaska' anywhere in 'X[[1L]]'. Bummer!
## 
## lookfor did not find 'Alaska' anywhere in 'X[[2L]]'. Bummer!
## 
## Matches found for 'Alaska' in 'X[[3L]]':
```

```
##   Match Position
##  Alaska        2
## [[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
```

```r
# look for variable
lookin(USArrests, "Assault")
```

```
## Matches found for 'Assault' in attributes(USArrests):
## Matches found for 'Assault' in 'X[[1L]]':
```

```
##    Match Position
##  Assault        2
```

```
## lookfor did not find 'Assault' anywhere in 'X[[2L]]'. Bummer!
## 
## lookfor did not find 'Assault' anywhere in 'X[[3L]]'. Bummer!
```

```
## [[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
```


### Look in an environment ###


```r
x <- new.env()
x$mtcars <- mtcars
x$cars <- letters[1:10]
x$cards <- 1:5
lookin(x, "car")
```


### Look in a list ###


```r
m <- lm(mpg ~ cyl, data = mtcars)
lookin(m, "mpg")
```

```
## Error in setNames(w, x[w]): attempt to apply non-function
```


### Look everywhere ###


```r
data(mtcars)
lookfor("Mazda")
```

```
## lookfor found matches for 'Mazda' in the following locations...
```

```
## Within objects from global environment:
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[1L]]'. Bummer!
## 
## lookfor did not find 'Mazda' anywhere in 'X[[2L]]'. Bummer!
## 
## lookfor did not find 'Mazda' anywhere in 'X[[3L]]'. Bummer!
## 
## lookfor did not find 'Mazda' anywhere in 'X[[17L]]'. Bummer!
```

```
## $coefficients
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## $residuals
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[2L]]'. Bummer!
```

```
## 
## $effects
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[3L]]'. Bummer!
```

```
## 
## $rank
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[4L]]'. Bummer!
```

```
## 
## $fitted.values
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[5L]]'. Bummer!
```

```
## 
## $assign
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[6L]]'. Bummer!
```

```
## 
## $qr
## $qr
## 
## $qraux
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[2L]]'. Bummer!
```

```
## 
## $pivot
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[3L]]'. Bummer!
```

```
## 
## $tol
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[4L]]'. Bummer!
```

```
## 
## $rank
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[5L]]'. Bummer!
```

```
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $attributes
## $attributes$class
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "Mazda"
## 
## $df.residual
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[8L]]'. Bummer!
```

```
## 
## $xlevels
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "X[[9L]]"
## attr(,"what")
## [1] "Mazda"
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
```

```
## Matches found for 'Mazda' in attributes(X[[12L]]):
## lookfor did not find 'Mazda' anywhere in 'X[[1L]]'. Bummer!
```

```
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
```

```
## Matches found for 'Mazda' in 'X[[3L]]':
```

```
##          Match Position
##      Mazda RX4        1
##  Mazda RX4 Wag        2
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[4L]]'. Bummer!
```

```
## [[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $attributes
## $attributes$class
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "Mazda"
```

```
## Matches found for 'Mazda' in attributes(X[[19L]]):
## lookfor did not find 'Mazda' anywhere in 'X[[1L]]'. Bummer!
## 
## Matches found for 'Mazda' in 'X[[2L]]':
```

```
##          Match Position
##      Mazda RX4        1
##  Mazda RX4 Wag        2
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[3L]]'. Bummer!
```

```
## [[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## $names
## $values
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $attributes
## $attributes$class
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## $attributes$object
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[2L]]'. Bummer!
```

```
## 
## $attributes$what
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[3L]]'. Bummer!
```

```
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "Mazda"
## 
## $row.names
## $values
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $attributes
## $attributes$class
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## $attributes$object
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[2L]]'. Bummer!
```

```
## 
## $attributes$what
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[3L]]'. Bummer!
```

```
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "Mazda"
## 
## $class
## $values
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $attributes
## $attributes$class
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## $attributes$object
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[2L]]'. Bummer!
```

```
## 
## $attributes$what
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[3L]]'. Bummer!
```

```
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "Mazda"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "X[[20L]]"
## attr(,"what")
## [1] "Mazda"
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[31L]]'. Bummer!
## 
## lookfor did not find 'Mazda' anywhere in 'X[[32L]]'. Bummer!
```

```
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "X[[34L]]"
## attr(,"what")
## [1] "Mazda"
## coming soon...
```

### Look using regular expression ###


```r
data(mtcars)

# Look for car names containing letters and numbers (anywhere)
lookfor("[[:alpha:]]+ [[:digit:]]")
```

```
## lookfor found matches for '[[:alpha:]]+ [[:digit:]]' in the following locations...
```

```
## Within objects from global environment:
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[1L]]'. Bummer!
## 
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[2L]]'. Bummer!
## 
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[3L]]'. Bummer!
## 
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[17L]]'. Bummer!
```

```
## $coefficients
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## $residuals
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[2L]]'. Bummer!
```

```
## 
## $effects
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[3L]]'. Bummer!
```

```
## 
## $rank
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[4L]]'. Bummer!
```

```
## 
## $fitted.values
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[5L]]'. Bummer!
```

```
## 
## $assign
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[6L]]'. Bummer!
```

```
## 
## $qr
## $qr
## 
## $qraux
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[2L]]'. Bummer!
```

```
## 
## $pivot
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[3L]]'. Bummer!
```

```
## 
## $tol
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[4L]]'. Bummer!
```

```
## 
## $rank
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[5L]]'. Bummer!
```

```
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $attributes
## $attributes$class
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $df.residual
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[8L]]'. Bummer!
```

```
## 
## $xlevels
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "X[[9L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
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
```

```
## Matches found for '[[:alpha:]]+ [[:digit:]]' in attributes(X[[12L]]):
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[1L]]'. Bummer!
```

```
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
```

```
## Matches found for '[[:alpha:]]+ [[:digit:]]' in 'X[[3L]]':
```

```
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
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[4L]]'. Bummer!
```

```
## [[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $attributes
## $attributes$class
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
```

```
## Matches found for '[[:alpha:]]+ [[:digit:]]' in attributes(X[[19L]]):
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[1L]]'. Bummer!
## 
## Matches found for '[[:alpha:]]+ [[:digit:]]' in 'X[[2L]]':
```

```
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
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[3L]]'. Bummer!
```

```
## [[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## $names
## $values
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $attributes
## $attributes$class
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## $attributes$object
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[2L]]'. Bummer!
```

```
## 
## $attributes$what
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[3L]]'. Bummer!
```

```
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $row.names
## $values
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $attributes
## $attributes$class
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## $attributes$object
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[2L]]'. Bummer!
```

```
## 
## $attributes$what
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[3L]]'. Bummer!
```

```
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $class
## $values
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $attributes
## $attributes$class
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[1L]]'. Bummer!
```

```
## 
## $attributes$object
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[2L]]'. Bummer!
```

```
## 
## $attributes$what
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[3L]]'. Bummer!
```

```
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "X[[20L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[31L]]'. Bummer!
## 
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[32L]]'. Bummer!
```

```
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "X[[34L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## coming soon...
```

```r
# Look for car names containing letters and numbers (in mtcars)
lookin(mtcars, "[[:alpha:]]+ [[:digit:]]")
```

```
## Matches found for '[[:alpha:]]+ [[:digit:]]' in attributes(mtcars):
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[1L]]'. Bummer!
## 
## Matches found for '[[:alpha:]]+ [[:digit:]]' in 'X[[2L]]':
```

```
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
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[3L]]'. Bummer!
```

```
## [[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
```
