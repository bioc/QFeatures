% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/readQFeaturesFromDIANN.R
\name{readQFeaturesFromDIANN}
\alias{readQFeaturesFromDIANN}
\title{Read DIA-NN output as a QFeatures objects}
\usage{
readQFeaturesFromDIANN(
  assayData,
  colData = NULL,
  quantCols = "Ms1.Area",
  runCol = "File.Name",
  multiplexing = c("none", "mTRAQ"),
  extractedData = NULL,
  ecol = NULL,
  verbose = TRUE,
  ...
)
}
\arguments{
\item{assayData}{A \code{data.frame} or any object that can be coerced
to a data.frame that contains the data from the \code{Report.tsv}
file generated by DIA-NN.}

\item{colData}{A \code{data.frame} or any object that can be coerced to
a \code{data.frame} containing sample/column annotations. See
\code{\link[=readQFeatures]{readQFeatures()}} for details}

\item{quantCols}{A \code{character(1)} indicating which column in
\code{assayData} contains the quantitative information. Default is
\code{"Ms1.Area"}. See \code{\link[=readQFeatures]{readQFeatures()}} for details}

\item{runCol}{\code{character(1)} naming the run/batch \code{assayData}
variable. By default, \code{"File.Name"}. See \code{\link[=readQFeatures]{readQFeatures()}} for
details.}

\item{multiplexing}{A \code{character(1)} indicating the type of
multiplexing used in the experiment. One of \code{"none"} (default,
for label-free experiments) or \code{"mTRAQ"} (for plexDIA
experiments).}

\item{extractedData}{A \code{data.frame} or any object that can be
coerced to a \code{data.frame} that contains the data from the
\verb{*_ms1_extracted.tsv} file generated by DIA-NN. This argument
is optional and is currently only applicable for mTRAQ
multiplexed experiments where DIA-NN was run using the
\code{plexdia} module.}

\item{ecol}{Same as \code{quantCols} for the single-set case. See
\code{\link[=readQFeatures]{readQFeatures()}} for details}

\item{verbose}{A \code{logical(1)} indicating whether the progress of
the data reading and formatting should be printed to the
console. Default is \code{TRUE}.}

\item{...}{Further arguments passed to \code{\link[=readQFeatures]{readQFeatures()}}.}
}
\value{
An instance of class \code{QFeatures}. The quantiative data of
each acquisition run is stored in a separate set as a
\code{SummarizedExperiment} object.
}
\description{
This function takes the output tables from DIA-NN and converts
them into a multi-set \code{QFeatures} object. It is a wrapper around
\code{\link[=readQFeatures]{readQFeatures()}} with default parameters set to for DIA-NN
label-free and plexDIA report files.
}
\examples{

x <- read.delim(MsDataHub::benchmarkingDIA.tsv())
x[["File.Name"]] <- x[["Run"]]

#################################
## Label-free multi-set case

## using default arguments
readQFeaturesFromDIANN(x)

## with a colData (and default arguments)
cd <- data.frame(sampleInfo = LETTERS[1:24],
                 quantCols = "Ms1.Area",
                 runCol = unique(x[["File.Name"]]))
readQFeaturesFromDIANN(x, colData = cd)

#################################
## mTRAQ multi-set case

## TODO, once data is on ExperimentHub
## x <- read.delim("Report-Derks2022-plexDIA.tsv")
## readQFeaturesFromDIANN(x, multiplexing = "mTRAQ")
}
\seealso{
\itemize{
\item The \code{QFeatures} (see \code{\link[=QFeatures]{QFeatures()}}) class to read about how to
manipulate the resulting \code{QFeatures} object.
\item The \code{\link[=readQFeatures]{readQFeatures()}} function which this one depends on.
}
}
\author{
Laurent Gatto, Christophe Vanderaa
}