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

# look for variable
lookin(USArrests, "Assault")
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
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $attributes
## $comment
## $comment[[1]]
## integer(0)
## 
## attr(,"location")
## [1] "comment"
## 
## $names
## NULL
## 
## $class
```

```
## lookfor did not find 'mpg' anywhere in 'x[[i]]'. Bummer!
```

```
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "a"
## attr(,"what")
## [1] "mpg"
## attr(,"location")
## [1] "attributes"
## 
## $coefficients
## NULL
## 
## $residuals
## NULL
## 
## $effects
## NULL
## 
## $rank
## NULL
## 
## $fitted.values
## NULL
## 
## $assign
## NULL
## 
## $qr
## NULL
## 
## $df.residual
## NULL
## 
## $xlevels
## NULL
## 
## $call
## NULL
## 
## $terms
## NULL
## 
## $model
## 
## attr(,"class")
## [1] "lookin.list"
## attr(,"object")
## [1] "x"
## attr(,"what")
## [1] "mpg"
```


### Look everywhere ###


```r
data(mtcars)
lookfor("Mazda")
```

```
## lookfor did not find 'Mazda' anywhere. Bummer!
```

### Look using regular expression ###


```r
data(mtcars)

# Look for car names containing letters and numbers (anywhere)
lookfor("[[:alpha:]]+ [[:digit:]]")
```

```
## lookfor did not find '[[:alpha:]]+ [[:digit:]]' anywhere. Bummer!
```

```r
# Look for car names containing letters and numbers (in mtcars)
lookin(mtcars, "[[:alpha:]]+ [[:digit:]]")
```
