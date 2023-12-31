% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reduce.R
\name{unfoldDataFrame}
\alias{unfoldDataFrame}
\title{Unfold a data frame}
\usage{
unfoldDataFrame(x, k, split = ";")
}
\arguments{
\item{x}{A \code{DataFrame} or \code{data.frame} to be unfolded.}

\item{k}{\code{character(1)} referring to a character variable in \code{x},
that will be used to unfold \code{x}.}

\item{split}{\code{character(1)} passed to \code{\link[=strsplit]{strsplit()}} to split
\code{x[[k]]}.}
}
\value{
A new object unfolded object of class \code{class(x)} with
numbers of rows >= \code{nrow(x)} and columns identical to \code{x}.
}
\description{
A data frame is said to be \emph{folded} when some cells contain
multiple elements. These are often encode as a semi-colon
separated character , such as \code{"a;b"}. This function will
transform the data frame to that \code{"a"} and \code{"b"} are split and
recorded across two lines.

The simple example below illustrates a trivial case, where the
table below\tabular{ll}{
   X \tab Y \cr
   1 \tab a;b \cr
   2 \tab c \cr
}


is unfolded based on the Y variable and becomes\tabular{ll}{
   X \tab Y \cr
   1 \tab a \cr
   1 \tab b \cr
   2 \tab c \cr
}


where the value 1 of variable X is now duplicated.

If there is a second variable that follows the same pattern as the
one used to unfold the table, it also gets unfolded.\tabular{lll}{
   X \tab Y \tab Z \cr
   1 \tab a;b \tab x;y \cr
   2 \tab c \tab z \cr
}


becomes\tabular{lll}{
   X \tab Y \tab Z \cr
   1 \tab a \tab x \cr
   1 \tab b \tab y \cr
   2 \tab c \tab z \cr
}


because it is implied that the element in "a;b" are match to "x;y"
by their respective indices. Note in the above example, unfolding
by Y or Z produces the same result.

However, the following table unfolded by Y\tabular{rll}{
   X \tab Y \tab Z \cr
   1 \tab a;b \tab x;y \cr
   2 \tab c \tab x;y \cr
}


produces\tabular{rll}{
   X \tab Y \tab Z \cr
   1 \tab a \tab x;y \cr
   1 \tab b \tab x;y \cr
   2 \tab c \tab x;y \cr
}


because "c" and "x;y" along the second row don't match. In this
case, unfolding by Z would produce a different result. These
examples are also illustrated below.

Note that there is no \code{foldDataFrame()} function. See
\code{\link[=reduceDataFrame]{reduceDataFrame()}} and \code{\link[=expandDataFrame]{expandDataFrame()}} to flexibly encode and
handle vectors of length > 1 within cells.
}
\examples{

(x0 <- DataFrame(X = 1:2, Y = c("a;b", "c")))
unfoldDataFrame(x0, "Y")

(x1 <- DataFrame(X = 1:2, Y = c("a;b", "c"), Z = c("x;y", "z")))
unfoldDataFrame(x1, "Y")
unfoldDataFrame(x1, "Z") ## same

(x2 <- DataFrame(X = 1:2, Y = c("a;b", "c"), Z = c("x;y", "x;y")))
unfoldDataFrame(x2, "Y")
unfoldDataFrame(x2, "Z") ## different
}
\author{
Laurent Gatto
}
