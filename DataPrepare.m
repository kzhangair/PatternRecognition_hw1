numOfFile =19;
trainingSet = [];
k = 0;
for i = (1:numOfFile)
    myFileName = sprintf('./brain_wave_data/data/sleep_data_row3_%d.mat' , i);
    myData = importdata(myFileName);
    for j = 1:(length(myData)/1000)
        k = k+1;
        trainingSet(k, :) = myData(1, 1000*(j-1)+1:1000*j);
    end
end

trainingLabelSet = [];
k = 1;
for i = (1:numOfFile)
    myFileName = sprintf('./brain_wave_data/label/HypnogramAASM_subject%d.txt' , i);
    importData = importdata(myFileName);
    myData = importData.data;
    trainingLabelSet(k:k+length(myData)-1, :) = myData(1:length(myData), :);
    k = k+length(myData);
end

testingSet = [];
k = 0;
myData = importdata('./brain_wave_data/data/sleep_data_row3_20.mat');
for j = 1:(length(myData)/1000)
    k = k+1;
    testingSet(k, :) = myData(1, 1000*(j-1)+1:1000*j);
end

testingLabelSet = [];
k = 1;
importData = importdata('./brain_wave_data/label/HypnogramAASM_subject20.txt');
myData = importData.data;
testingLabelSet(k:k+length(myData)-1, :) = myData(1:length(myData), :);


trainingData = [trainingSet, trainingLabelSet]; %containing 5 classification training data + label, 114752*1001
testingData = [testingSet, testingLabelSet];    %6870*1001
id = trainingData(:,1001)<1 | trainingData(:,1001)>3;                     
trainingData(id,:)=[];                              %only 1 2 3 label remain; 77220*1001
%%%%%%%%%%%%%%%%%%label = 1
id = trainingData(:,1001)==1;
Lab1_TrainingData = trainingData(id, :);            %21936*1001
%%%%%%%%%%%%%%%%%label = 2
id = trainingData(:,1001)==2;
Lab2_TrainingData = trainingData(id, :);            %46770*1001
%%%%%%%%%%%%%%%%label = 3
id = trainingData(:,1001)==3;
Lab3_TrainingData = trainingData(id, :);            %8514*1001

id = testingData(:,1001)<1 | testingData(:,1001)>3;       %only 1 2 3 label remain; 4764*1001
testingData(id,:)=[];
save('trainingData.mat', 'trainingData', '-mat');
save('Lab1_TrainingData.mat', 'Lab1_TrainingData', '-mat');
save('Lab2_TrainingData.mat', 'Lab2_TrainingData', '-mat');
save('Lab3_TrainingData.mat', 'Lab3_TrainingData', '-mat');
save('testingData.mat', 'testingData', '-mat');

