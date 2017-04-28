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
num_channels = 62;

%% Extract Features
window_size = 100; %ms
step_size = 50; %ms
sub_sample_rate = 50;

[X, Y] = get_features(sub1_ecog, sub1_glove, window_size, step_size, sample_rate, num_channels, sub_sample_rate);
Y = Y(:,1);

%% Cross Validation
num_folds = 10;
cv_idx = mod(randperm(size(X,1)), num_folds) + 1;
acc_hist = [];

for i = 1:num_folds
    X_train = X(cv_idx ~= i, :);
    Y_train = Y(cv_idx ~= i);
    X_test = X(cv_idx == i, :);
    Y_test = Y(cv_idx == i);
    
    [mdl_best, info] = lasso(X_train, Y_train, 'Lambda', 0:0.001:0.04);
    Y_pred = X_test * mdl_best + repmat(info.Intercept, size(X_test,1), 1);
    acc = corr(Y_pred, Y_test);
    
    acc_hist(:,i) = acc;
end

acc = mean(acc_hist, 2);
[best_acc, best_acc_idx] = max(acc);

%% Test Error after interpolation
X_train = X(1000:end,:);
Y_train = Y(1000:end);
X_test = X(1:999,:);
Y_test = Y(1:999);
[mdl_best, info_best] = lasso(X_train, Y_train, 'Lambda', info.Lambda(best_acc_idx));
Y_pred = X_test * mdl_best + repmat(info_best.Intercept, size(X_test,1), 1);
acc = corr(Y_pred, Y_test)

interpolated = spline(1:999, Y_pred, linspace(1,999,49950-100));
interpolated_padded = [zeros(1,100), interpolated];
acc_interp = corr(interpolated_padded', sub1_glove(1:49950,1))

%%
plot(Y_pred ,'r')
hold on
plot(Y_test, 'b')

%%
figure
plot(interpolated_padded, 'r')
hold on
plot(sub1_glove(1:49950,1))