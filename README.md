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
data(USArrests)

# look for observation
lookin(USArrests, "Alaska")
```

```
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
## NULL
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
## 
## attr(,"class")
## [1] "lookin.list"
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
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$Assault
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$UrbanPop
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$Rape
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## 
## attr(,"class")
## [1] "lookin.data.frame"
```

```r
# look for variable
lookin(USArrests, "Assault")
```

```
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
## NULL
## 
## $row.names
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## 
## attr(,"class")
## [1] "lookin.list"
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
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$Assault
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$UrbanPop
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$Rape
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## 
## attr(,"class")
## [1] "lookin.data.frame"
```


### Look in an environment ###


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
## 
## 
## attr(,"class")
## [1] "lookin.environment"
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
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## 
## attr(,"class")
## [1] "lookin.list"
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
## $terms
## NULL
## 
## $row.names
## NULL
## 
## $class
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## 
## attr(,"class")
## [1] "lookin.list"
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
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$cyl
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## 
## attr(,"class")
## [1] "lookin.data.frame"
## 
## attr(,"class")
## [1] "lookin.list"
```


### Look everywhere ###


```r
data(mtcars)
lookfor("Mazda")
```

### Look using regular expression ###


```r
data(mtcars)

# Look for car names containing letters and numbers (anywhere)
lookfor("[[:alpha:]]+ [[:digit:]]")
```

```r
# Look for car names containing letters and numbers (in mtcars)
lookin(mtcars, "[[:alpha:]]+ [[:digit:]]")
```

```
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
## $row.names
## NULL
## 
## $class
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.character"
## 
## attr(,"class")
## [1] "lookin.list"
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
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$cyl
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$disp
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$hp
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$drat
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$wt
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$qsec
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$vs
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$am
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$gear
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## $variables$carb
## $values
## named integer(0)
## 
## $comment
## integer(0)
## 
## attr(,"class")
## [1] "lookin.numeric"
## 
## 
## attr(,"class")
## [1] "lookin.data.frame"
```
