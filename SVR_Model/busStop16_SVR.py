#This is predict model SVR for
##118 Street & Jasper Avenue,Stop#:1688
#Author @Lu Yin
import pandas
from sklearn.svm import SVR
import numpy
from sklearn.cross_validation import KFold
from sklearn import cross_validation

def calMAPE(X_test,previousarrvial,Y_test):
	sum_up = 0
	n = 0
	size = len(X_test)
	for i in range(size):
		if previousarrvial[i] != 0:
			diff = result[i] - Y_test[i]
			diff = abs(diff)
			n = n+1
			sum_up = sum_up + (diff/abs((X_test[i,:1]*17363+53240) + Y_test[i] - previousarrvial[i]))
	MAPE = sum_up/n
	#print(MAPE)
	return MAPE
	
Data = r'/Users/yinlu/Desktop/bustStop/bustStop_16.csv'
#split the original extraData into Dif_file which contains y(real difference)
#and Previous which contains the arrival_time of previous_bus_stop(used for MAPE)
Dif = r'/Users/yinlu/Desktop/ExtraData/extraData_16.csv'

X = pandas.read_csv(Data,names = ['a','b','c','d','e','f','g','h','i']);
X = X.values
Y = pandas.read_csv(Dif,names=['diff','previousarrvial']);
Y = Y.values

kf = KFold(len(X), n_folds=5)

for cost in [1,10,20,50,100,200]:
	print('Cost value')
	print(cost)

	for train, test in kf:
		mapeTotal = 0
		X_train, X_test, y_train, y_test = X[train], X[test], Y[train,0], Y[test,0]
		previousarrvial = Y[test,1]
		nn = SVR(C=cost, epsilon = 0.1)
		nn.fit(X_train,y_train)
		result = nn.predict(X_test);

		thisMape = calMAPE(X_test,previousarrvial,y_test)
		mapeTotal = mapeTotal + thisMape

	mapeCV = mapeTotal/5;
	print("#####")
	print(mapeCV)
##[ 0.0066474]


	



