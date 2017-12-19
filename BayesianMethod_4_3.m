Lab1_TrainingData = importdata('./Lab1_TrainingData.mat'); 
Lab2_TrainingData = importdata('./Lab2_TrainingData.mat'); 
Lab3_TrainingData = importdata('./Lab3_TrainingData.mat'); 

X = Lab1_TrainingData(:,1:1000);
covX1 = cov(X);
X = Lab2_TrainingData(:,1:1000);
covX2 = cov(X);
X = Lab3_TrainingData(:,1:1000);
covX3 = cov(X);
sum = size(Lab1_TrainingData,1)+size(Lab2_TrainingData,1)+size(Lab3_TrainingData,1);
P1 = size(Lab1_TrainingData,1)/sum;
P2 = size(Lab2_TrainingData,1)/sum;
P3 = size(Lab3_TrainingData,1)/sum;
covX = P1*covX1+P2*covX2+P3*covX3;
[V, D] = eig(covX);
eigVector = diag(D);
[B, I] = sort(eigVector, 'descend');
W = V(:, I(1:5,1));

trainingData = importdata('trainingData.mat');
X = trainingData(:,1:1000);
Y = X*W;
fftX = fft(X, size(X,2),2);
[sortedfftX, I] = sort(abs(fftX(:,1:501)), 2, 'descend');
Y = [Y, I(:,1),trainingData(:,1001)]; 

testingData = importdata('testingData.mat');
fftTestX = fft(testX, size(testX,2),2);
[sortedfftTestX, I] = sort(abs(fftTestX(:,1:501)), 2, 'descend');
testX = testingData(:,1:1000);
testY = testX*W;
testY = [testY, I(:,1)];

id = Y(:,7)==1;
Lab1_Y = Y(id,:);
Lab1_Y = Lab1_Y(:,1:6);
id = Y(:,7)==2;
Lab2_Y = Y(id,:);
Lab2_Y = Lab2_Y(:,1:6);
id = Y(:,7)==3;
Lab3_Y = Y(id,:);
Lab3_Y = Lab3_Y(:,1:6);

Lab1_mean = mean(Lab1_Y,1);
Lab1_var = var(Lab1_Y);
Lab2_mean = mean(Lab2_Y,1);
Lab2_var = var(Lab2_Y);
Lab3_mean = mean(Lab3_Y,1);
Lab3_var = var(Lab3_Y);



result = zeros(size(testY,1),3);
for i = (1:size(testY,1))
    x = testY(i,:);
    result(i,1) = Gaussian(Lab1_mean, Lab1_var, x)*P1;
    result(i,2) = Gaussian(Lab2_mean, Lab2_var, x)*P2;
    result(i,3) = Gaussian(Lab3_mean, Lab3_var, x)*P3;
end

[sortedResult, I] = sort(result, 2, 'descend');
correct = I(:,1) - testingData(:, 1001);
tmp1 = find(correct==0);
accuracy = length(tmp1)/length(correct);
fprintf("The accuracy is %f\n", accuracy);
function p = Gaussian(mean, var, x)
    p = 1;
    for i = 1:length(x)
        p = p*(1/(sqrt(2*pi*var(1,i)))*exp(-(x(1,i)-mean(1,i))^2/(2*var(1,i))));
    end
end