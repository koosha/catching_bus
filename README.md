# catching_bus
Predicting Probability of Catching the Bus

These are models used for predicting real bus arrival time for ETS.

The input variables:
	Schedule time, Rush hour(binary), same bus at previous stop delay, previous bus at same stop delay, weather(3 bit binary), Weekdays(3 bit binary).
	
	
ANN_Model_NoUserRequest: build the ANN model without consider the user request time.
ANN_Model_WithUserRequest: build the ANN model with user request, the dataset contains the time user request for the prediction within 0, 5, 10,20 and 30 minutes before the schedule time.

SVR models describes the SVR model user for predict real bus arrival time for ETS.