library("testthat")
library("arulesCBA")
data("iris")

context("arulesCBA Interface")

classifier <- CBA(Species ~ ., iris, supp = 0.05, conf=0.9, lhs.support=FALSE)
results <- predict(classifier, iris)
iris.disc <- discretizeDF.supervised(Species~.,iris)
rcar_classifier <- RCAR(Species ~ ., iris.disc)

expect_equal(length(classifier$rules), 8L)
expect_equal(length(rcar_classifier$rules), 5L)
expect_equal(classifier$default, "Species=setosa")
expect_equal(results[1], factor("setosa",
  levels = c("setosa", "versicolor", "virginica")))



context("predict")

results <- predict(classifier, head(iris, n = 5))
rcar_results <- predict(rcar_classifier, head(iris.disc, n = 5))
expect_equal(length(results), 5L)
expect_equal(length(rcar_results), 5L)

classifier$method <- "majority"
results <- predict(classifier, head(iris, n = 5))
expect_equal(length(results), 5L)

classifier$method <- "weighted"
results <- predict(classifier, head(iris, n = 5))
expect_equal(length(results), 5L)
