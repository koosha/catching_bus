#114 Street & Jasper Avenue,Stop#:1918

import pandas as pd
import math
from sklearn import svm
#import numpy as np
#from sklearn.neural_network import MLPRegressor
from sknn.mlp import Regressor, Layer

## ipython how to get the location of cvs file????
Train = r'./Data/BustStop/bustStop_22.csv'
Target = r'./Data/ExtraData/extraData_22.csv'
divPath = r'./Data/MAPE/MAPE_22.csv'
df = pd.read_csv(Train)
# names=['schedule', 'busDelay','stopDelay','Mon','Tue','Wed','Thu','Fri','Sat','Sun','Sunny','Rainy','Snowy']
diff = pd.read_csv(Target,names=['diff','schedule'])
div = pd.read_csv(divPath)
#if math.isnan(df['diff']): df.diff = 0
#df = df[pd.notnull(df['diff'])]
#print(df);
## small example.
X = df[1:1500].values
y = diff[1:1500]['diff'].values
#print(X)
#print(y)
Xtest = df[1500:1600].values;
yTarget = diff[1500:1600]['diff'].values;

meanDiv = div[1500:1600].values

nn = Regressor(
    layers=[
        Layer("Rectifier", units=100),
        Layer("Linear")],
    learning_rate=0.00001,
    n_iter=50)
nn.fit(X, y)

result =  nn.predict(Xtest);

#print(result);



#calculate accuracy
#m = size_of(Xtest)
mape = 0
for i in range(len(result)):
	#print("#####")
	#print i 
	#print("  ")
	#print(result[i])
	#print("  ")
	#print(yTarget[i])
	diffff = abs(result[i]-yTarget[i])
	#print(diffff)
	
	mean = abs(result[i]-yTarget[i])/meanDiv[i]
	mape  = mape + mean;
print("mape: ")
print(mape)
