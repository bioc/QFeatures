% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/QFeatures-functions.R
\name{countUniqueFeatures}
\alias{countUniqueFeatures}
\title{Count Unique Features}
\usage{
countUniqueFeatures(object, i, groupBy = NULL, colDataName = "count")
}
\arguments{
\item{object}{An object of class \code{QFeatures}.}

\item{i}{A \code{numeric()} or \code{character()} vector indicating from
which assays the \code{rowData} should be taken.}

\item{groupBy}{A \code{character(1)} indicating the variable name in
the \code{rowData} that contains the grouping variable, for
instance to count the unique number of peptides or proteins
expressed in each samples (column). If \code{groupBy} is missing,
the number of non zero elements per sample will be stored.}

\item{colDataName}{A \code{character(1)} giving the name of the new
variable in the \code{colData} where the number of unique features
will be stored. The name cannot already exist in the
\code{colData}.}
}
\value{
An object of class \code{QFeatures}.
}
\description{
This function counts the number of unique features per sample. A
grouping structure can be provided to count higher level features
from assays, for example counting the number of unique proteins
from PSM data.
}
\examples{
data("ft_na")
## Count number of (non-missing) PSMs
ft_na <- countUniqueFeatures(ft_na, 
                             i = "na", 
                             colDataName = "counts")
ft_na$counts
## Count number of unique rowData feature
ft_na <- countUniqueFeatures(ft_na, 
                             i = "na", 
                             groupBy = "Y",
                             colDataName = "Y_counts")
ft_na$Y_counts

}
