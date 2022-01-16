import pandas as pd
import numpy as np
from matplotlib import pyplot as plt

from sklearn.linear_model import LinearRegression
from sklearn.feature_selection import RFE
from sklearn.metrics import r2_score
from sklearn.linear_model import LassoLarsIC

bodyfat = pd.read_csv("./data/BodyFat.csv")
pd.set_option("display.max_columns", None)

bodyfat.info()
bodyfat.describe()

bodyfat["HEIGHT"] = bodyfat["HEIGHT"] / 0.3937

bodyfat.drop(columns = bodyfat.columns[[0, 2, 6]], inplace = True)
bodyfat.drop(index = [41, 171, 181, 39], inplace = True)

bodyfat_raw_lm = LinearRegression().fit(X = bodyfat.drop(columns = ["BODYFAT"]), y = bodyfat["BODYFAT"])
print(bodyfat_raw_lm.coef_)

bodyfat_rfe = RFE(LinearRegression()).fit(X = bodyfat.drop(columns = ["BODYFAT"]),
                                          y = bodyfat["BODYFAT"])
selected_features = bodyfat.drop(columns = ["BODYFAT"]).columns[bodyfat_rfe.get_support()]
bodyfat_selected = LinearRegression().fit(X = bodyfat[selected_features], y = bodyfat["BODYFAT"])

r2_score(y_true = bodyfat["BODYFAT"], y_pred = bodyfat_selected.predict(X = bodyfat[selected_features]))

bodyfat_lasso = LassoLarsIC(criterion = "bic", verbose = True).fit(X = bodyfat.drop(columns = ["BODYFAT"]),
                                                                   y = bodyfat["BODYFAT"])
bodyfat_lasso.coef_
selected_features_lasso_bic = bodyfat.drop(columns = ["BODYFAT"]).columns[bodyfat_lasso.coef_ != 0]
bodyfat_lasso.score(X = bodyfat.drop(columns = ["BODYFAT"]), y = bodyfat["BODYFAT"])
lass_coef = {selected_features_lasso_bic[i]: bodyfat_lasso.coef_[i] for i in range(len(bodyfat_lasso.coef_)) if
             bodyfat_lasso.coef_[i] != 0}

bodyfat_final = LinearRegression().fit(X = bodyfat[selected_features_lasso_bic], y = bodyfat["BODYFAT"])
bodyfat_final.coef_
bodyfat_final.score(X = bodyfat[selected_features_lasso_bic], y = bodyfat["BODYFAT"])
