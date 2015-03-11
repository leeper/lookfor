\name{lookfor}
\alias{lookin}
\alias{lookfor}
\title{Look for something somewhere}
\description{Look for something in an object or anywhere in the active workspace}
\usage{
lookfor(what, \dots)
lookin(x, what, \dots)
}
\arguments{
    \item{x}{An object to look in.}
    \item{what}{What to look for: either a character string or a regular expression.}
    \item{\dots}{Additional arguments passed to methods, and eventually passed to \code{grepl}.}
}
\details{Find something you're looking for in a specified object, or anywhere in the active workspace.}
\value{An object of class \dQuote{lookfor} or \dQuote{lookin}.}
\author{Thomas J. Leeper}
%\references{}
%\seealso{}
%\examples{}
