rm(list = ls())
library("MASS")
library("car")
library("leaps")
library("tidyverse")
BodyFat <-
        read_csv(
                "https://raw.githubusercontent.com/JumpyJumpy/stat628-module2/master/data/BodyFat.csv",
                show_col_types = FALSE
        )
summary(BodyFat)
BodyFat$HEIGHT <- BodyFat$HEIGHT / 0.3937

## remove bad data points, drop density, BMI
BodyFat_cleaned <-
        subset(BodyFat[-c(42, 172, 182, 39),], select = -c(1, 3, 7))


## initial model
lm_model1 <- lm(BODYFAT ~ ., data = BodyFat_cleaned)
summary(lm_model1)
corr <- cor(BodyFat_cleaned[, -1]) ## notice strong correlation on weight with other terms
vif(lm_model1) ## weight is dropped due to high vif
head(BodyFat_cleaned)


# ## stepwise
# lm_model2 <- lm(BODYFAT ~ . - WEIGHT, data = BodyFat_cleaned)
# step(lm_model1, )
# lm_model2 <- stepAIC(lm_model2, direction = "both", trace = FALSE)
# summary(lm_model2)
# vif(lm_model2) ## drop chest due to high vif

## best subset selection

best_subset <-
        regsubsets(BODYFAT ~ . - WEIGHT, data = BodyFat_cleaned, nvmax = 100)
summary(best_subset)
summary(best_subset)$bic
summary(best_subset)$adjr2 ## (3) & (4) are candidates of optimal model since it has lowest BIC and a relatively high R^2

#BodyFat_cleaned <- BodyFat_cleaned[-39,]

final_3 <-
        lm(BODYFAT ~ ABDOMEN + WRIST + HEIGHT, data = BodyFat_cleaned)
summary(final_3)
vif(final_3)
par(mfrow = c(2, 2))
plot(final_3, ask = F)
# ## potential outliers 36, 40, 201, 212


final_4 <-
        lm(BODYFAT ~ ABDOMEN + HEIGHT + WRIST + AGE, data = BodyFat_cleaned)
summary(final_4)
vif(final_4)
par(mfrow = c(2, 2))
plot(final_4, ask = F)
## potential outliers 36, 40, 212


## plot leverage points and influential points
final <- list(final_3, final_4)

for (i in 1:2) {
    lmmodel <- final[[i]]
    pii <- hatvalues(lmmodel)
    hat_max_index <- which.max(pii)
    cooki <- cooks.distance(lmmodel)
    par(mfrow = c(2, 1))
    n <- dim(BodyFat_cleaned)[1]
    plot(
            1:n,
            pii,
            type = "p",
            pch = 19,
            cex = 1.2,
            cex.lab = 1.5,
            cex.main = 1.5,
            xlab = "Index (Each Observation)",
            ylab = "Pii",
            main = "Leverage Values (Pii)"
    )
    plot(
            1:n,
            cooki,
            type = "p",
            pch = 19,
            cex = 1.2,
            cex.lab = 1.5,
            cex.main = 1.5,
            xlab = "Index (Each Observation)",
            ylab = "Cook's Distance",
            main = "Influence Values (Cook's Distance)"
    )
}
