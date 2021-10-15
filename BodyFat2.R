rm(list = ls())
library("MASS")
library("car")
library("tidyverse")
BodyFat <- read_csv("https://raw.githubusercontent.com/JumpyJumpy/stat628-module2/master/data/BodyFat.csv",
                    show_col_types = FALSE)
summary(BodyFat)
BodyFat$HEIGHT <- BodyFat$HEIGHT / 0.3937

## delete bad data points, drop density, BMI
BodyFat_cleaned <- subset(BodyFat[-c(42,172,182),], select = -c(1,3,7))
#write_csv(BodyFat_cleaned, "./data/BodyFat_cleaned.csv")
corr <- cor(BodyFat_cleaned)



## full model
lm_model1 <- lm(BODYFAT~., data = BodyFat_cleaned)
summary(lm_model1)
vif(lm_model1)
head(BodyFat_cleaned)
## NO.39 is not an outlier
par(mfrow = c(2,2))
plot(lm_model1)

## stepwise
lm_model2 <- lm(BODYFAT ~ . - WEIGHT, data = BodyFat_cleaned)
lm_model2 <- stepAIC(lm_model2, direction = "both", trace = FALSE)
summary(lm_model2)
vif(lm_model2)

lm_model3 <- lm(BODYFAT ~ . - WEIGHT - HIP , data = BodyFat_cleaned)
lm_model3 <- stepAIC(lm_model3, direction = "both", trace = FALSE)
summary(lm_model3)
vif(lm_model3)

lm_model4 <- lm(BODYFAT ~ AGE + HEIGHT + ABDOMEN + FOREARM + WRIST, data = BodyFat_cleaned)
#lm_model4 <- stepAIC(lm_model4, direction = "both", trace = FALSE)
summary(lm_model4)
vif(lm_model4)

lm_model5 <- lm(BODYFAT ~ AGE + ABDOMEN + WRIST, data = BodyFat_cleaned)
#lm_model5 <- stepAIC(lm_model5, direction = "both", trace = FALSE)
summary(lm_model5)
vif(lm_model5)
final <- lm_model5