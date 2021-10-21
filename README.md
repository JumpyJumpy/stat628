# STAT 628 Module 2  
## Objective  
The project aims to build a simple and robust model to accurately predict one's body fat percentage after providing some necessary data. Check `project_summary.pdf` to see how the project proceeded specifically.
## Data    
The data is in [data](https://github.com/JumpyJumpy/stat628-module2/tree/master/data) folder.  
- `BodyFat.csv` is the raw dataset with no cleanings.
- `BodyFat_cleaned.csv` is the dataset with bad data points dropped.  
## Code  
Codes are in [code](https://github.com/JumpyJumpy/stat628-module2/tree/master/code) folder. Codes used for cleaning the data and analysis were written in R.   
- See [`BodyFat.R`](https://github.com/JumpyJumpy/stat628-module2/blob/master/code/BodyFat.R) for raw codes, or the jupyter notebook version of the codes [`BodyFat.ipynb`](https://github.com/JumpyJumpy/stat628-module2/blob/master/code/BodyFat.ipynb) for codes with output of each step.  
- [`BodyFat_app.R`] will generate a local web-based body fat percentage calculator based on `Shiny`. One can also access the online version at https://wangcongming95.shinyapps.io/test/. 

Note: R package `tidyverse`, `car`, `ggplot2` and `MASS` are required to run `BodyFat2.R` and make sure that there is a `data` subdirectory containing `BodyFat.csv` (i.e. `"./data/BodyFat.csv"`) in the working directory when running `BodyFat2.R`.

## How to use
Shiny Application: You can run `BodyFat_app.R`, or on https://wangcongming95.shinyapps.io/test/.
## Questions
If you have any questions, please contact:  
- Haoyue Shi hshi87@wisc.edu  
- Yijin Guan yguan37@wisc.edu  
- Zihan Zhao zzhao387@wisc.edu   
- Shubo Lin slin268@wisc.edu  
