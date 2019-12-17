load('carsmall')
cars = table(MPG,Weight,Model_Year);
cars.Model_Year = categorical(cars.Model_Year);
categories(cars.Model_Year)
% now cars has Model_Year categorical(nominal) variable
% encode categorical variable
D = dummyvar(cars.Model_Year);
D = array2table(D);
D.Properties
% add new variable to cars
cars = [cars ,D];
cars.Model_Year =[];
% convert table to matrix as input to train function is R-by-Q matrix and   
% U-by-Q matrix
inputs = table2array(cars(:,2:5))'; % R-by-Q
targets = cars.MPG'; % U-by-Q matrix
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
