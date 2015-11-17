import pandas
from sknn.mlp import Regressor, Layer
import numpy

Data = r'./Data/BustStop/bustStop_13.csv'
#split the original extraData into Dif_file which contains y(real difference)
#and Previous which contains the arrival_time of previous_bus_stop(used for MAPE)
Dif = r'./Data/ExtraData/extraData_13.csv'
Mape = r'./Data/MAPE/MAPE_13.csv'
X = pandas.read_csv(Data);
X_test = X
X = X
X = X.values
X_test = X_test.values
Y = pandas.read_csv(Dif);
#print Y
Y_test = Y.ix[:,:1]
Y_test = Y_test.values
#print "123",Y_test[1]
previousarrvial = Y.ix[:,1:]
Y = Y.ix[:,:1]
Y = Y.values

previousarrvial = previousarrvial.values
#print previousarrvial 
print previousarrvial[2]
tempM = pandas.read_csv(Mape)
MAPE = tempM.values
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
	n_iter = 300)
nn.fit(X,Y)

result = nn.predict(X_test);

sum_up = 0
n = 0
size = len(X_test)
for i in range(size):
	if (previousarrvial[i]!=0):
		print "Y=",Y_test[i],"Re=",result[i]
		diff = Y_test[i]-result[i]
		diff = abs(diff)
		n = n+1
		if diff>MAPE[i]:
			print "Y=",Y_test[i],"Re=",result[i]
		sum_up = sum_up + diff/MAPE[i]
MAPE = sum_up/n
print sum_up
print n
print (1-MAPE)
#

