rm(list = ls())
library("MASS")
library("car")
library("tidyverse")
BodyFat <- read_csv("https://raw.githubusercontent.com/JumpyJumpy/stat628-module2/master/data/BodyFat.csv",
                    show_col_types = FALSE)
summary(BodyFat)
BodyFat$HEIGHT <- BodyFat$HEIGHT / 0.3937

## delete bad data points, drop density, BMI
BodyFat_cleaned <- subset(BodyFat[-c(42, 172, 182),], select = -c(1, 3, 7))
corr <- cor(BodyFat_cleaned[,-1])

## initial model
lm_model1 <- lm(BODYFAT~., data = BodyFat_cleaned)
summary(lm_model1)
vif(lm_model1) ## weight is dropped due to high vif
head(BodyFat_cleaned)
## NO.39 is not an outlier
par(mfrow = c(2,2))
plot(lm_model1)

## stepwise
lm_model2 <- lm(BODYFAT ~ . - WEIGHT, data = BodyFat_cleaned)
lm_model2 <- stepAIC(lm_model2, direction = "both", trace = FALSE)
summary(lm_model2)
vif(lm_model2) ## HIP is dropped due to high vif


## best subset selection
library("leaps")
best_subset <- regsubsets(BODYFAT ~. - WEIGHT - HIP, data = BodyFat_cleaned)
summary(best_subset)
summary(best_subset)$bic
summary(best_subset)$adjr2 # (3) & (4) are candidates of optimal model since it has lowest BIC and a relatively high R^2


final <- lm(BODYFAT ~ ABDOMEN + WRIST + HEIGHT, data = BodyFat_cleaned)
summary(final)
vif(final)
plot(final)



#BodyFat_cleaned <- BodyFat_cleaned[-39,]
final <- lm(BODYFAT ~ ABDOMEN + HEIGHT + WRIST, data = BodyFat_cleaned)
summary(final)
vif(final)
plot(final)



## AGE: ON    R^2 = 
## AGE: OFF   R^2 = 0.7094
