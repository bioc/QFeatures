invariant_col <- function(x)
    length(unique(x)) == 1

invariant_cols <- function(x) {
    res <- rep(NA, length(x))
    for (i in seq_along(x))
        res[i] <- invariant_col(x[[i]])
    res
}


##' A long dataframe can be *reduced* by mergeing certain rows into a single one.
##' These new variables are constructed as a `SimpleList` containing all the
##' original values. Invariant columns, i.e columns that have the same value
##' along all the rows that need to be merged, can be shrunk into a new
##' variables containing that invariant value (rather than in list columns). The
##' grouping of rows, i.e. the rows that need to be shrunk together as one, is
##' defined by a vector.
##'
##' The opposite operation is *expand*. But note that for a `DataFrame` to be
##' expanded back, it must not to be simplified.
##'
##' @title Reduces and expands a `DataFrame`
##' @param x The `DataFrame` to be reduced or expanded.
##' @param k A ‘vector’ of length `nrow(x)` defining the grouping based on which
##'     the `DataFrame` will be shrunk.
##' @param count `logical(1)` specifying of an additional column (called by
##'     default `.n`) with the tally of rows shrunk into on new row should be
##'     added. Note that if already existing, `.n` will be silently overwritten.
##' @param simplify `logical(1)` defining if invariant columns should be
##'     converted to simple lists.
##' @return An expanded (reduced) `DataFrame`.
##' @author Laurent Gatto
##' @import S4Vectors
##' @import IRanges
##' @export reduce_DataFrame
##' @examples
##' library("IRanges")
##'
##' k <- sample(10000, 1e5, replace = TRUE)
##' df <- DataFrame(k = k,
##'                 x = round(rnorm(length(k)), 2),
##'                 y = seq_len(length(k)),
##'                 z = sample(LETTERS, length(k), replace = TRUE),
##'                 ir = IRanges(seq_along(k), width = 10),
##'                 r = Rle(sample(5, length(k), replace = TRUE)),
##'                 invar = k + 1)
##' df
##'
##' ## Shinks the DataFrame
##' df2 <- reduce_DataFrame(df, df$k)
##' df2
##'
##' ## With a tally of the number of members in each group
##' reduce_DataFrame(df, df$k, count = TRUE)
##'
##' ## Much faster, but more crowded result
##' df3 <- reduce_DataFrame(df, df$k, simplify = FALSE)
##' df3
reduce_DataFrame <- function(x, k, count = FALSE, simplify = TRUE) {
    res <- split(x, k)
    lens <- lengths(res)
    if (simplify) {
        ## which ones are invariable
        invars <- sapply(res, invariant_cols)
        invars <- which(rowSums(invars) == length(res))
    }
    res <- DataFrame(res)
    if (simplify) {
        ## replace invariant cols
        for (i in invars)
            res[[i]] <- IntegerList(as.list(sapply(res[[i]], "[[", 1)))
    }
    if (count)
        res[[".n"]] <- lens
    res
}


##' @export
##' @rdname reduce_DataFrame
expand_DataFrame <- function(x, k = NULL) {
    if (is.null(k))
        return(expand(x, recursive = FALSE))
    else
        return(DataFrame(lapply(x, unsplit, k)))
}