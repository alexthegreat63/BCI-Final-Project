clc
clear
close all

%% Load data
load('../../data.mat');
load('test_features.mat')
sample_rate = 1000;
dur = 310000 / sample_rate;
dur_test = 147500 / sample_rate;
t_train = linspace(0, dur, 310000);
t_test = linspace(0, dur_test, 147500);
num_channels_sub1 = 62;
num_channels_sub2 = 48;
num_channels_sub3 = 64;

%% Extract features
window_size = 80; %ms
step_size = 40; %ms
sub_sample_rate = 40;

[X1, Y1] = get_features(sub1_ecog(:,[1:num_channels_sub1]~= 55), sub1_glove, window_size, step_size, sample_rate, num_channels_sub1-1, sub_sample_rate);
[X2, Y2] = get_features(sub2_ecog(:,[1:num_channels_sub2]~= 21 & [1:num_channels_sub2]~= 38), sub2_glove, window_size, step_size, sample_rate, num_channels_sub2-2, sub_sample_rate);
[X3, Y3] = get_features(sub3_ecog, sub3_glove, window_size, step_size, sample_rate, num_channels_sub3, sub_sample_rate);

%% Train Logistic Regression
X_all = {X1, X2, X3};
Y_all = {Y1, Y2, Y3};
yhat = cell(3,1);

for sub = 1:3
    X = X_all{sub}(:, 1:end-1);
    for finger = 1:5
        Y = Y_all{sub}(:,finger) > 1.4;
        for i = 1:size(Y,1)-100
            if Y(i) == 1
                idx = find(Y(i:i+100), 1, 'last');
                Y(i:i+idx-1) = 1;
            end
        end

        alpha = 1;
%         options = statset('maxiter', 1000);
        mdl = glmfit(X, Y, 'binomial');
       % yhat_lr{sub}(:,finger) = glmval(mdl, test_ecog{sub}(:,1:end-1), 'logit').^alpha;
          yhat_lr{sub}(:,finger)= glmval(mdl, test_ecog{sub}(:,1:end-1), 'logit').^alpha;
        % adapative filtering 
        
    end
end

%% Save predictions
save('lr_predictions', 'yhat_lr')