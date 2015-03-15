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
## $attributes
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "Alaska"
## 
## $class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "Alaska"
## 
## $row.names
## $values
## Alaska 
##      2 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "Alaska"
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
## [1] "a"
## attr(,"what")
## [1] "Alaska"
## attr(,"location")
## [1] "attributes"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $variables
## $variables$Murder
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "Alaska"
## 
## $variables$Assault
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "Alaska"
## 
## $variables$UrbanPop
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "Alaska"
## 
## $variables$Rape
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "Alaska"
## 
## 
## attr(,"class")
## [1] "lookin.data.frame"
## attr(,"object")
## [1] "USArrests"
## attr(,"what")
## [1] "Alaska"
```

```r
# look for variable
lookin(USArrests, "Assault")
```

```
## $attributes
## $names
## $values
## Assault 
##       2 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "Assault"
## 
## $class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "Assault"
## 
## $row.names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "Assault"
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
## [1] "a"
## attr(,"what")
## [1] "Assault"
## attr(,"location")
## [1] "attributes"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $variables
## $variables$Murder
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "Assault"
## 
## $variables$Assault
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "Assault"
## 
## $variables$UrbanPop
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "Assault"
## 
## $variables$Rape
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "Assault"
## 
## 
## attr(,"class")
## [1] "lookin.data.frame"
## attr(,"object")
## [1] "USArrests"
## attr(,"what")
## [1] "Assault"
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
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $environment
## $environment[[1]]
## $values
## cards 
##     1 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "c(\"cards\", \"cars\", \"mtcars\")[[1L]]"
## attr(,"what")
## [1] "car"
## 
## $environment[[2]]
## $values
## cars 
##    1 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "c(\"cards\", \"cars\", \"mtcars\")[[2L]]"
## attr(,"what")
## [1] "car"
## 
## $environment[[3]]
## $values
## mtcars 
##      1 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "c(\"cards\", \"cars\", \"mtcars\")[[3L]]"
## attr(,"what")
## [1] "car"
## 
## 
## attr(,"class")
## [1] "lookin.environment"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "car"
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
```

```
## Within objects from global environment:
## $coefficients
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
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
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $residuals
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
##     Mazda RX4 Mazda RX4 Wag 
##             1             2 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
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
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $effects
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
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
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $rank
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $fitted.values
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
##     Mazda RX4 Mazda RX4 Wag 
##             1             2 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
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
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[5L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $assign
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[6L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $qr
## $qr
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $dim
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $dimnames
## [[1]]
## $values
##     Mazda RX4 Mazda RX4 Wag 
##             1             2 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "Mazda"
## 
## [[2]]
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[2L]]"
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
## [1] "X[[2L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $assign
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
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
## [1] "lookin.matrix"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $qraux
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $pivot
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $tol
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $rank
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[5L]]"
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
## $attributes
## $attributes$class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "Mazda"
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
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[8L]]"
## attr(,"what")
## [1] "Mazda"
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
## $attributes
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
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
## [1] "X[[2L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $row.names
## $values
##     Mazda RX4 Mazda RX4 Wag 
##             1             2 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[4L]]"
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
## [1] "a"
## attr(,"what")
## [1] "Mazda"
## attr(,"location")
## [1] "attributes"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $variables
## $variables$mpg
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "Mazda"
## 
## $variables$cyl
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "Mazda"
## 
## 
## attr(,"class")
## [1] "lookin.data.frame"
## attr(,"object")
## [1] "X[[12L]]"
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
## $attributes
## $attributes$class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "Mazda"
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
## Matches found for 'Mazda' in attributes(X[[2L]]):
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
```

```
## lookfor did not find 'Mazda' anywhere in 'X[[3L]]'. Bummer!
```

```
## coming soon...
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
## Within objects from global environment:
## $coefficients
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
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
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $residuals
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
##     Datsun 710 Hornet 4 Drive     Duster 360      Merc 240D       Merc 230 
##              3              4              7              8              9 
##       Merc 280      Merc 280C     Merc 450SE     Merc 450SL    Merc 450SLC 
##             10             11             12             13             14 
##       Fiat 128  Porsche 914-2     Volvo 142E 
##             18             27             32 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
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
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $effects
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
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
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $rank
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $fitted.values
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
##     Datsun 710 Hornet 4 Drive     Duster 360      Merc 240D       Merc 230 
##              3              4              7              8              9 
##       Merc 280      Merc 280C     Merc 450SE     Merc 450SL    Merc 450SLC 
##             10             11             12             13             14 
##       Fiat 128  Porsche 914-2     Volvo 142E 
##             18             27             32 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
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
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[5L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $assign
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[6L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $qr
## $qr
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $dim
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $dimnames
## [[1]]
## $values
##     Datsun 710 Hornet 4 Drive     Duster 360      Merc 240D       Merc 230 
##              3              4              7              8              9 
##       Merc 280      Merc 280C     Merc 450SE     Merc 450SL    Merc 450SLC 
##             10             11             12             13             14 
##       Fiat 128  Porsche 914-2     Volvo 142E 
##             18             27             32 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## [[2]]
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[2L]]"
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
## [1] "X[[2L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $assign
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
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
## [1] "lookin.matrix"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $qraux
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $pivot
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $tol
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $rank
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[5L]]"
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
## $attributes
## $attributes$class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
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
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[8L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
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
## $attributes
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
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
## [1] "X[[2L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $row.names
## $values
##     Datsun 710 Hornet 4 Drive     Duster 360      Merc 240D       Merc 230 
##              3              4              7              8              9 
##       Merc 280      Merc 280C     Merc 450SE     Merc 450SL    Merc 450SLC 
##             10             11             12             13             14 
##       Fiat 128  Porsche 914-2     Volvo 142E 
##             18             27             32 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[4L]]"
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
## [1] "a"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## attr(,"location")
## [1] "attributes"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $variables
## $variables$mpg
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $variables$cyl
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## 
## attr(,"class")
## [1] "lookin.data.frame"
## attr(,"object")
## [1] "X[[12L]]"
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
## $attributes
## $attributes$class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
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
## Matches found for '[[:alpha:]]+ [[:digit:]]' in attributes(X[[2L]]):
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

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere in 'X[[3L]]'. Bummer!
```

```
## coming soon...
```

```r
# Look for car names containing letters and numbers (in mtcars)
lookin(mtcars, "[[:alpha:]]+ [[:digit:]]")
```

```
## $attributes
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $row.names
## $values
##     Datsun 710 Hornet 4 Drive     Duster 360      Merc 240D       Merc 230 
##              3              4              7              8              9 
##       Merc 280      Merc 280C     Merc 450SE     Merc 450SL    Merc 450SLC 
##             10             11             12             13             14 
##       Fiat 128  Porsche 914-2     Volvo 142E 
##             18             27             32 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[3L]]"
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
## [1] "a"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## attr(,"location")
## [1] "attributes"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $variables
## $variables$mpg
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $variables$cyl
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $variables$disp
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $variables$hp
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $variables$drat
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[5L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $variables$wt
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[6L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $variables$qsec
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[7L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $variables$vs
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[8L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $variables$am
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[9L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $variables$gear
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[10L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## $variables$carb
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[11L]]"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
## 
## 
## attr(,"class")
## [1] "lookin.data.frame"
## attr(,"object")
## [1] "mtcars"
## attr(,"what")
## [1] "[[:alpha:]]+ [[:digit:]]"
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
## Within objects from global environment:
## $coefficients
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $residuals
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## $effects
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "model using"
## 
## $rank
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "model using"
## 
## $fitted.values
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[5L]]"
## attr(,"what")
## [1] "model using"
## 
## $assign
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[6L]]"
## attr(,"what")
## [1] "model using"
## 
## $qr
## $qr
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $dim
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $dimnames
## [[1]]
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## [[2]]
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## $assign
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.matrix"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $qraux
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## $pivot
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "model using"
## 
## $tol
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "model using"
## 
## $rank
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[5L]]"
## attr(,"what")
## [1] "model using"
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
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "model using"
## 
## $df.residual
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[8L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "model using"
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
## [1] "model using"
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
## [1] "model using"
## 
## $model
## $attributes
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "model using"
## 
## $row.names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "model using"
## 
## $class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "a"
## attr(,"what")
## [1] "model using"
## attr(,"location")
## [1] "attributes"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $variables
## $variables$mpg
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $variables$cyl
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## 
## attr(,"class")
## [1] "lookin.data.frame"
## attr(,"object")
## [1] "X[[12L]]"
## attr(,"what")
## [1] "model using"
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
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "model using"
## $coefficients
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $residuals
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## $effects
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "model using"
## 
## $rank
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "model using"
## 
## $fitted.values
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[5L]]"
## attr(,"what")
## [1] "model using"
## 
## $assign
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[6L]]"
## attr(,"what")
## [1] "model using"
## 
## $qr
## $qr
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $dim
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $dimnames
## [[1]]
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## [[2]]
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## $assign
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.matrix"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $qraux
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## $pivot
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "model using"
## 
## $tol
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "model using"
## 
## $rank
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[5L]]"
## attr(,"what")
## [1] "model using"
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
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "model using"
## 
## $df.residual
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[8L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "model using"
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
## [1] "model using"
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
## [1] "model using"
## 
## $model
## $attributes
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "model using"
## 
## $row.names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "model using"
## 
## $class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "a"
## attr(,"what")
## [1] "model using"
## attr(,"location")
## [1] "attributes"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $variables
## $variables$mpg
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $variables$cyl
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## 
## attr(,"class")
## [1] "lookin.data.frame"
## attr(,"object")
## [1] "X[[12L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## model using continuous cylinder 
##                               1 
## 
## attr(,"location")
## [1] "comment"
## 
## $attributes
## $attributes$class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $attributes$comment
## $values
## model using continuous cylinder 
##                               1 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "model using"
## $coefficients
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $residuals
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## $effects
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "model using"
## 
## $rank
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "model using"
## 
## $fitted.values
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[5L]]"
## attr(,"what")
## [1] "model using"
## 
## $assign
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[6L]]"
## attr(,"what")
## [1] "model using"
## 
## $qr
## $qr
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $dim
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $dimnames
## [[1]]
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## [[2]]
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## $assign
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "model using"
## 
## $contrasts
## $`factor(cyl)`
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "X[[4L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.matrix"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $qraux
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## $pivot
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "model using"
## 
## $tol
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "model using"
## 
## $rank
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[5L]]"
## attr(,"what")
## [1] "model using"
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
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "model using"
## 
## $df.residual
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[8L]]"
## attr(,"what")
## [1] "model using"
## 
## $contrasts
## $`factor(cyl)`
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "X[[9L]]"
## attr(,"what")
## [1] "model using"
## 
## $xlevels
## $`factor(cyl)`
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "X[[10L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "X[[11L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "X[[12L]]"
## attr(,"what")
## [1] "model using"
## 
## $model
## $attributes
## $names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "model using"
## 
## $row.names
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[3L]]"
## attr(,"what")
## [1] "model using"
## 
## $class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[4L]]"
## attr(,"what")
## [1] "model using"
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
## [1] "a"
## attr(,"what")
## [1] "model using"
## attr(,"location")
## [1] "attributes"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $variables
## $variables$mpg
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $variables$`factor(cyl)`
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## $levels
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## attr(,"class")
## [1] "lookin.factor"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## 
## attr(,"class")
## [1] "lookin.data.frame"
## attr(,"object")
## [1] "X[[13L]]"
## attr(,"what")
## [1] "model using"
## 
## $comment
## $comment[[1]]
## model using factor of cylinder 
##                              1 
## 
## attr(,"location")
## [1] "comment"
## 
## $attributes
## $attributes$class
## $values
## integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[1L]]"
## attr(,"what")
## [1] "model using"
## 
## $attributes$comment
## $values
## model using factor of cylinder 
##                              1 
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## attr(,"object")
## [1] "X[[2L]]"
## attr(,"what")
## [1] "model using"
## 
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "model using"
```

```
## lookfor did not find 'model using' anywhere in 'X[[4L]]'. Bummer!
## 
## lookfor did not find 'model using' anywhere in 'X[[5L]]'. Bummer!
```

```
## coming soon...
```

