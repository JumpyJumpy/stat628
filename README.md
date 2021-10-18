# STAT 628 Module 2

## Objective  
The project aims to build a simple and robust model to accuratly predict one's body fat percentage after inputing some necessary data. 


## Data  
The data is in [data](https://github.com/JumpyJumpy/stat628-module2/tree/master/data) folder. `BodyFat.csv` is the raw dataset with no cleanings, and `BodyFat_cleaned.csv` is the dataset with bad data points dropped. 


## Code  
Codes are in [code](https://github.com/JumpyJumpy/stat628-module2/tree/master/code) folder. Codes used for cleaning the data and analysis were writen in R. See [`BodyFat.R`](https://github.com/JumpyJumpy/stat628-module2/blob/master/code/BodyFat.R) for raw codes, or the jupyter notebook version of the codes [`BodyFat.ipynb`](https://github.com/JumpyJumpy/stat628-module2/blob/master/code/BodyFat.ipynb) for codes with output of each step.


Note: R package `tidyverse`, `car`, `ggplot2` and `MASS` are required to run `BodyFat2.R` and make sure that there is a `data` subdirectory containig `BodyFat.csv` in the working directory when running `BodyFat2.R`.
