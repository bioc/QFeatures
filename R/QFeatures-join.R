.merge_2_by_cols <- function(x, y) {
    ## Only keep shared variables
    vars <- intersect(names(x), names(y))
    x <- x[, vars, drop = FALSE]
    y <- y[, vars, drop = FALSE]
    ## Only keep variables that have the same values for matching
    ## columns/rows.
    k <- intersect(rownames(x), rownames(y))
    .x <- x[k, , drop = FALSE]
    .y <- y[k, , drop = FALSE]
    for (j in names(.x))
        if (!isTRUE(identical(.x[[j]], .y[[j]])))
            x[, j] <- y[, j] <- NULL
    ## Create these to recover rownames
    x$._rownames <- rownames(x)
    y$._rownames <- rownames(y)
    ## Perform full join
    res <- merge(x, y,
                 by = intersect(names(x), names(y)),
                 all.x = TRUE, all.y = TRUE,
                 sort = FALSE)
    ## Set row names and remove temporary column
    rownames(res) <- res[["._rownames"]]
    res[["._rownames"]] <- NULL
    res
}


.merge_assays_by_rows <- function(l) {
    cn <- unlist(lapply(l, colnames))
    rn <- unique(unlist(lapply(l, rownames)))
    
    ## Check for duplicate column (sample) names
    if (any(duplicated(cn))) 
        stop("Merging assays with columns in common is not allowed.")
    
    res <- matrix(NA, ncol = length(cn), nrow = length(rn), 
                  dimnames = list(rn, cn))
    for (i in seq_along(l)) {
        x <- l[[i]]
        res[rownames(x), colnames(x)] <- as.matrix(x) 
        ## as.matrix in case x is an HDF5Array, note x (and res) are
        ## realized in memory. 
    }
    res
}


.merge_by_cols <- function(x, y, ...) {
    Reduce(.merge_2_by_cols, list(x, y, ...))
}


mergeSElist <- function(x) {
    x_classes <- unique(vapply(x, class, character(1)))
    if (length(x_classes) != 1)
        stop("Can't join assays from different classes.", call. = FALSE)
    joined_mcols <- Reduce(.merge_2_by_cols, lapply(x, rowData))
    joined_assay <- .merge_assays_by_rows(lapply(x, assay))
    joined_coldata <- Reduce(.merge_2_by_cols, lapply(x, colData))
    res <- SummarizedExperiment(joined_assay[rownames(joined_mcols), ],
                                joined_mcols,
                                colData = joined_coldata)
    ## If the input objects weren't SummarizedExperiments, then try to
    ## convert the merged assay into that class. If the conversion
    ## fails, keep the SummarizedExperiment, otherwise use the
    ## converted object (see issue #78).
    if (x_classes != "SummarizedExperiment")
        res <- tryCatch(as(res, x_classes),
                        error = function(e) res)
    res
}


##' @title Join assays in a QFeatures object
##'
##' @description
##'
##' This function applies a full-join type of operation on 2 or more
##' assays in a `QFeatures` instance.
##'
##' @param x An instance of class [QFeatures].
##'
##' @param i The indices or names of al least two assays to be joined.
##'
##' @param name A `character(1)` naming the new assay. Default is
##'     `joinedAssay`. Note that the function will fail if there's
##'     already an assay with `name`.
##'
##' @return A `QFeatures` object with an additional assay.
##'
##' @details
##'
##' The rows to be joined are chosen based on the rownames of the
##' respective assays. It is the user's responsability to make sure
##' these are meaningful, such as for example refering to unique
##' peptide sequences or proteins.
##'
##' The join operation acts along the rows and expects the samples
##' (columns) of the assays to be disjoint, i.e. the assays mustn't
##' share any samples. Rows that aren't present in an assay are set to
##' `NA` when merged.
##'
##' The `rowData` slots are also joined. However, only columns that
##' are shared and that have the same values for matching columns/rows
##' are retained. For example of a feature variable `A` in sample `S1`
##' contains value `a1` and variable `A` in sample `S2` in a different
##' assay contains `a2`, then the feature variable `A` is dropped in
##' the merged assay.
##'
##' The joined assay is linked to its parent assays through an `AssayLink`
##' object. The link between the child assay and the parent assays is based on
##' the assay row names, just like the procedure for joining the parent assays.
##'
##' @author Laurent Gatto
##'
##' @export
##'
##' @examples
##'
##' ## -----------------------------------------------
##' ## An example QFeatures with 3 assays to be joined
##' ## -----------------------------------------------
##' data(feat2)
##' feat2
##'
##' feat2 <- joinAssays(feat2, 1:3)
##'
##' ## Individual assays to be joined, each with 4 samples and a
##' ## variable number of rows.
##' assay(feat2[[1]])
##' assay(feat2[[2]])
##' assay(feat2[[3]])
##'
##' ## The joined assay contains 14 rows (corresponding to the union
##' ## of those in the initial assays) and 12 samples
##' assay(feat2[["joinedAssay"]])
##'
##' ## The individual rowData to be joined.
##' rowData(feat2[[1]])
##' rowData(feat2[[2]])
##' rowData(feat2[[3]])
##'
##' ## Only the 'Prot' variable is retained because it is shared among
##' ## all assays and the values and coherent across samples (the
##' ## value of 'Prot' for row 'j' is always 'Pj'). The variable 'y' is
##' ## missing in 'assay1' and while variable 'x' is present is all
##' ## assays, the values for the shared rows are different.
##' rowData(feat2[["joinedAssay"]])
joinAssays <- function(x,
                       i,
                       name = "joinedAssay") {
    stopifnot("Object must be of class 'QFeatures'" = inherits(x, "QFeatures"),
              "Need at least 2 assays to join" = length(i) >= 2)
    if (name %in% names(x))
        stop("Assay with name '", name, "' already exists.")
    ## Join assays and add to x
    joined_se <- mergeSElist(experiments(x)[i])
    x <- addAssay(x, joined_se, name = name)
    ## Add the multi-parent AssayLinks
    addAssayLink(x, from = i, to = name)
}
