import pandas as pd
import numpy as np
from matplotlib import pyplot as plt

from sklearn.linear_model import LinearRegression
from sklearn.feature_selection import RFE
from sklearn.metrics import r2_score

bodyfat = pd.read_csv("./data/BodyFat.csv")
pd.set_option("display.max_columns", None)

bodyfat.info()
bodyfat.describe()

bodyfat["HEIGHT"] = bodyfat["HEIGHT"] / 0.3937

bodyfat.drop(columns = bodyfat.columns[[0, 2, 6]], inplace = True)
bodyfat.drop(index = [41, 171, 181, 39], inplace = True)

bodyfat_raw_lm = LinearRegression().fit(X = bodyfat.drop(columns = ["BODYFAT"]), y = bodyfat["BODYFAT"])
print(bodyfat_raw_lm.coef_)


bodyfat_rfe = RFE(LinearRegression(), verbose = True).fit(X = bodyfat.drop(columns = ["BODYFAT"]), y = bodyfat["BODYFAT"])
selected_features = bodyfat.drop(columns = ["BODYFAT"]).columns[bodyfat_rfe.get_support()]
bodyfat_selected = LinearRegression().fit(X = bodyfat[selected_features], y = bodyfat["BODYFAT"])

r2_score(y_true = bodyfat["BODYFAT"], y_pred = bodyfat_selected.predict(X = bodyfat[selected_features]))
