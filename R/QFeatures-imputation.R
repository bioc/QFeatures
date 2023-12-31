##' @title Quantitative proteomics data imputation
##'
##' @description
##'
##' The `impute` method performs data imputation on `QFeatures` and
##' `SummarizedExperiment` instance using a variety of methods.
##'
##' Users should proceed with care when imputing data and take
##' precautions to assure that the imputation produce valid results,
##' in particular with naive imputations such as replacing missing
##' values with 0.
##'
##' See [MsCoreUtils::impute_matrix()] for details on
##' the different imputation methods available and strategies.
##'
##' @rdname impute
##'
##' @aliases impute impute,SummarizedExperiment-method impute,QFeatures-method
##'
##' @importFrom MsCoreUtils impute_matrix
##'
##' @examples
##' MsCoreUtils::imputeMethods()
##'
##' data(se_na2)
##' ## table of missing values along the rows (proteins)
##' table(rowData(se_na2)$nNA)
##' ## table of missing values along the columns (samples)
##' colData(se_na2)$nNA
##'
##' ## non-random missing values
##' notna <- which(!rowData(se_na2)$randna)
##' length(notna)
##' notna
##'
##' impute(se_na2, method = "min")
##'
##' if (require("imputeLCMD")) {
##'   impute(se_na2, method = "QRILC")
##'   impute(se_na2, method = "MinDet")
##' }
##'
##' if (require("norm"))
##'   impute(se_na2, method = "MLE")
##'
##' impute(se_na2, method = "mixed",
##'        randna = rowData(se_na2)$randna,
##'        mar = "knn", mnar = "QRILC")
##'
##' ## neighbour averaging
##' x <- se_na2[1:4, 1:6]
##' assay(x)[1, 1] <- NA ## min value
##' assay(x)[2, 3] <- NA ## average
##' assay(x)[3, 1:2] <- NA ## min value and average
##' ## 4th row: no imputation
##' assay(x)
##'
##' assay(impute(x, "nbavg"))
"impute"


##' @param object A `SummarizedExperiment` or `QFeatures` object with
##'     missing values to be imputed.
##' @param method `character(1)` defining the imputation method. See
##'     `imputeMethods()` for available ones. See
##'     [MsCoreUtils::impute_matrix()] for details.
##' @param ... Additional parameters passed to the inner imputation
##'     function. See [MsCoreUtils::impute_matrix()] for details.
##'
##' @export
##' @rdname impute
setMethod("impute", "SummarizedExperiment",
          function(object, method, ...) {
              res <- impute_matrix(assay(object), method, ...)
              assay(object) <- res
              object
          })


##' @param i A `logical(1)` or a `character(1)` that defines which 
##'     element of the `QFeatures` instance to impute. It cannot be
##'      missing and must be of length one.
##' @param name A `character(1)` naming the new assay name. Default
##'     is `imputedAssay`.
##'
##' @export
##' @rdname impute
setMethod("impute", "QFeatures",
          function(object, method, ..., i, name = "imputedAssay") {
              .applyTransformation(object, i, name, impute,
                                   method = method, ...)
              
          })
