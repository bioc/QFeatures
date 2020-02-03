data(hlpsms)
x <- hlpsms[1:5000, ]
f <- tempfile()
write.csv(x, file = f, row.names = FALSE)


test_that("readFeatures", {
    ft1 <- readFeatures(x, ecol = 1:10, name = "psms")
    ft2 <- readFeatures(f, ecol = 1:10, name = "psms")
    expect_equal(ft1, ft2)
    ft1 <- readFeatures(x, ecol = 1:10, name = NULL)
    ft2 <- readFeatures(f, ecol = 1:10, name = NULL)
    expect_equal(ft1, ft2)    
    ft1 <- readFeatures(x, ecol = 1:10, name = "psms", fname = "Sequence")
    ft2 <- readFeatures(f, ecol = 1:10, name = "psms", fname = "Sequence")
    expect_equal(ft1, ft2)    
    ft2 <- readFeatures(x, ecol = 1:10, name = "psms", fname = 11)
    ft3 <- readFeatures(f, ecol = 1:10, name = "psms", fname = 11)
    expect_equal(ft1, ft2)
    expect_equal(ft1, ft3)    
    ecol <- c("X126", "X127C", "X127N", "X128C", "X128N", "X129C",
              "X129N", "X130C", "X130N", "X131")
    ft1 <- readFeatures(x, ecol = ecol, name = "psms")
    ft2 <- readFeatures(f, ecol = ecol, name = "psms")
    expect_equal(ft1, ft2)
    ecol <- LETTERS[1:10]
    expect_error(readFeatures(x, ecol = ecol, name = "psms"))
    expect_error(readFeatures(f, ecol = ecol, name = "psms"))
    expect_error(readFeatures(x, ecol = 1:10, name = "psms", fname = "not_present"))
    expect_error(readFeatures(f, ecol = 1:10, name = "psms", fname = "not_present"))
})