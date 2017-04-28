clc
clear
close all

%% Load data
load('../../data.mat');
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
X = X1(:, 1:end-1);
Y = Y1(:,1) > 1.4;
for i = 1:size(Y,1)-100
    if Y(i) == 1
        idx = find(Y(i:i+100), 1, 'last');
        Y(i:i+idx-1) = 1;
    end
end

mdl = glmfit(X, Y, 'binomial');
Y_pred = glmval(mdl, X, 'logit');

%% Plots
plot(Y, 'b')
hold on
plot(Y_pred, 'r')