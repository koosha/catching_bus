import pandas
from sknn.mlp import Regressor, Layer
import numpy

Data = r'./Data/BustStop/bustStop_17.csv'
#split the original extraData into Dif_file which contains y(real difference)
#and Previous which contains the arrival_time of previous_bus_stop(used for MAPE)
Dif = r'./Data/ExtraData/extraData_17.csv'
#mu = r'/Users/jackwang/Downloads/mu_15.csv'
#sigma = r'/Users/jackwang/Downloads/sigma_15.csv'
X = pandas.read_csv(Data);
X_test = X.ix[1:299.:]
X = X.ix[300:,:]
X = X.values
X_test = X_test.values
Y = pandas.read_csv(Dif);
Y_test = Y.ix[1:299,:1]
previousarrvial = Y.ix[1:299,1:]
Y = Y.ix[300:,:1]
Y = Y.values
Y_test = Y_test.values
previousarrvial = previousarrvial.values
#print(previousarrvial)
#mu = pandas.read_csv(mu);
#mu = mu.values
#sigma = pandas.read_csv(sigma);
#sigma = sigma.values
#print(sigma)
#print Y
#test = Test.values
#print "row 1=", test[1]
nn = Regressor(
	layers=[
		Layer("Sigmoid", units = 100),
		Layer("Linear")],
	learning_rate = 0.01,
	n_iter = 500)
nn.fit(X,Y)
#print test
#t=test[1:3]
#print t
result = nn.predict(X_test);
#t=test[3:4]
#print t
#result = nn.predict(t)
#print(result)
#--------------Need to implement-----------
#
#
sum_up = 0
n = 0
size = len(X_test)
for i in range(size):
	if previousarrvial[i] != 0:
		diff = result[i] - Y_test[i]
		diff = abs(diff)
		n = n+1
		sum_up = sum_up + (diff/abs((X_test[i,:1]*16594+55978) + Y_test[i] - previousarrvial[i]))
MAPE = sum_up/n
print(MAPE)
#

