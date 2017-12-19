Lab1_TrainingData = importdata('./Lab1_TrainingData.mat'); 
Lab2_TrainingData = importdata('./Lab2_TrainingData.mat'); 
Lab3_TrainingData = importdata('./Lab3_TrainingData.mat'); 

X = Lab1_TrainingData(:,1:1000);
covX = cov(X);
[V, D] = eig(covX);
eigVector = diag(D);
[B, I] = sort(eigVector, 'descend');
W1 = V(:, I(1:5,1));
Y = X*W1;
fftX = fft(X, size(X,2),2);
[sortedfftX, I] = sort(abs(fftX(:,1:501)), 2, 'descend');
Lab1_Y = [Y, I(:,1)]; 

X = Lab2_TrainingData(:,1:1000);
covX = cov(X);
[V, D] = eig(covX);
eigVector = diag(D);
[B, I] = sort(eigVector, 'descend');
W2 = V(:, I(1:5,1));
Y = X*W2;
fftX = fft(X, size(X,2),2);
[sortedfftX, I] = sort(abs(fftX(:,1:501)), 2, 'descend');
Lab2_Y = [Y, I(:,1)]; 

X = Lab3_TrainingData(:,1:1000);
covX = cov(X);
[V, D] = eig(covX);
eigVector = diag(D);
[B, I] = sort(eigVector, 'descend');
W3 = V(:, I(1:5,1));
Y = X*W3;
fftX = fft(X, size(X,2),2);
[sortedfftX, I] = sort(abs(fftX(:,1:501)), 2, 'descend');
Lab3_Y = [Y, I(:,1)]; 

testingData = importdata('testingData.mat');
fftTestX = fft(testX, size(testX,2),2);
[sortedfftTestX, I] = sort(abs(fftTestX(:,1:501)), 2, 'descend');
testX = testingData(:,1:1000);
testY1 = testX*W1;
testY1 = [testY1, I(:,1)];
testY2 = testX*W2;
testY2 = [testY2, I(:,1)];
testY3 = testX*W3;
testY3 = [testY3, I(:,1)];

Lab1_mean = mean(Lab1_Y,1);
Lab1_var = var(Lab1_Y);
Lab2_mean = mean(Lab2_Y,1);
Lab2_var = var(Lab2_Y);
Lab3_mean = mean(Lab3_Y,1);
Lab3_var = var(Lab3_Y);

sum = size(Lab1_Y,1)+size(Lab2_Y,1)+size(Lab2_Y,1);

result = zeros(size(testY1,1),3);
for i = (1:size(testY,1))
    x1 = testY1(i,:);
    x2 = testY2(i,:);
    x3 = testY3(i,:);
    result(i,1) = Gaussian(Lab1_mean, Lab1_var, x1)*size(Lab1_Y,1)/sum;
    result(i,2) = Gaussian(Lab2_mean, Lab2_var, x2)*size(Lab2_Y,1)/sum;
    result(i,3) = Gaussian(Lab3_mean, Lab3_var, x3)*size(Lab3_Y,1)/sum;
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