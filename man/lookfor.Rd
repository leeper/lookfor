\name{lookfor}
\alias{lookin}
\alias{lookfor}
\title{Look for something somewhere}
\description{Look for something in an object or anywhere in the active workspace}
\usage{
lookfor(what, ls_opts = list(name = ".GlobalEnv"), \dots)
lookin(x, what, \dots)
}
\arguments{
    \item{x}{An object to look in.}
    \item{what}{What to look for: either a character string or a regular expression.}
    \item{ls_opts}{A list of optional arguments passed \code{ls}. This can be used to look in an environment other than \code{.GlobalEnv}.}
    \item{\dots}{Additional arguments passed to methods, and eventually passed to \code{grepl}.}
}
\details{Find something you're looking for in a specified object, or anywhere in the active workspace.}
\value{An object of class \dQuote{lookfor} or \dQuote{lookin}.}
\author{Thomas J. Leeper}
%\references{}
%\seealso{}
\examples{
require("datasets")

# look in a data.frame
data(USArrests)
## look for observation
lookin(USArrests, "Alaska")
## look for variable
lookin(USArrests, "Assault")

# look in an environment
x <- new.env()
x$mtcars <- mtcars
x$cars <- letters[1:10]
x$cards <- 1:5
lookin(x, "car")

# look in a list
data(mtcars)
x <- structure(mtcars, class = "list")
lookin(x, "mpg")

# look everywhere
lookfor("package")

# use regular expressions
## Look for car names containing letters and numbers (anywhere)
lookfor("[[:alpha:]]+ [[:digit:]]")
## Look for car names containing letters and numbers (in mtcars)
lookin(mtcars, "[[:alpha:]]+ [[:digit:]]")
}
