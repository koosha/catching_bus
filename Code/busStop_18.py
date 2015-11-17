#This is model predict for
##120 Street & Jasper Avenue,Stop#:1646
#Author @Lu Yin
import pandas as pd
import math
from sklearn import svm
#import numpy as np
#from sklearn.neural_network import MLPRegressor
from sknn.mlp import Regressor, Layer

## ipython how to get the location of cvs file????
Train = r'./Data/BustStop/bustStop_18.csv'
Target = r'./Data/ExtraData/extraData_18.csv'
divPath = r'./Data/MAPE/MAPE_18.csv'
df = pd.read_csv(Train)
# names=['schedule', 'busDelay','stopDelay','Mon','Tue','Wed','Thu','Fri','Sat','Sun','Sunny','Rainy','Snowy']
diff = pd.read_csv(Target,names=['diff','schedule'])
div = pd.read_csv(divPath)
#if math.isnan(df['diff']): df.diff = 0
#df = df[pd.notnull(df['diff'])]
#print(df);
## small example.
X = df[1:1800].values
y = diff[1:1800]['diff'].values
#print(X)
#print(y)
Xtest = df[1800:1898].values;
yTarget = diff[1800:1898]['diff'].values;

meanDiv = div[1800:1898].values

nn = Regressor(
    layers=[
        Layer("Rectifier", units=100),
        Layer("Linear")],
    learning_rate=0.00001,
    n_iter=100)
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
	mape  = mape + mean

print("mape: ")
print(mape)

#output result mape: [ 71.05718458]



