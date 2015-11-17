import pandas as pd;
from sknn.mlp import Regressor, Layer;
import numpy as np;
X_file = r'./Data/BustStop/bustStop_21.csv';
Y_file = r'./Data/ExtraData/extraData_21.csv';
Previous = r'./Data/MAPE/MAPE_21.csv';
X = pd.read_csv(X_file);
Y = pd.read_csv(Y_file);
MAPE=pd.read_csv(Previous);
shape=X.shape;
X_train = X.values[0:1200,:];
X_test=X.values[1201:shape[0],:]
Y_train = Y.values[0:1200,0];
Y_test=Y.values[1201:shape[0],0];
nn = Regressor(
	layers=[
		Layer("Rectifier", units = 100),
		Layer("Linear")],
	learning_rate = 0.00002,
	n_iter = 10)
nn.fit(X_train,Y_train)
result = nn.predict(X_test);
diff=result.T-Y_test;
#print(result);
print(diff);
travel=MAPE.values[1201:shape[0],0];
print(travel);
mape=diff/travel*100;
mean=np.mean(mape);
print(mean);


