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
window_size = 80; %ms
step_size = 40; %ms
sub_sample_rate = 40;

[X, Y] = get_features(sub1_ecog(:,[1:num_channels] ~= 55), sub1_glove, window_size, step_size, sample_rate, num_channels-1, sub_sample_rate);
Y = Y(:,3);

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

%% Test Error
X_train = X(1000:end,:);
Y_train = Y(1000:end);
X_test = X(1:999,:);
Y_test = Y(1:999);
[mdl_best, info_best] = lasso(X_train, Y_train, 'Lambda', info.Lambda(best_acc_idx));
Y_pred_lasso = X_test * mdl_best + repmat(info_best.Intercept, size(X_test,1), 1);
acc = corr([0; Y_pred_lasso(1:end-1)], Y_test)

%% Train Logistic Regression
X_train_lr = X(:,1:end-1);
Y_train_lr = Y > 1.4;
for i = 1:size(Y_train_lr,1)-100
    if Y_train_lr(i) == 1
        idx = find(Y_train_lr(i:i+100), 1, 'last');
        Y_train_lr(i:i+idx-1) = 1;
    end
end

alpha = 1;
% options = statset('maxiter', 500);
% mdl_lr = glmfit(X_train_lr, Y_train_lr, 'binomial', 'Options', options);
mdl_lr = glmfit(X_train_lr, Y_train_lr, 'binomial');
Y_pred_lr = glmval(mdl_lr, X(:,1:end-1), 'logit').^alpha;

Y_pred = Y_pred_lasso .* Y_pred_lr(1:999);
corr(Y_pred, Y_test)

%% Interpolate
interpolated = spline(1:999, Y_pred, linspace(1,999,999*sub_sample_rate-80));
interpolated_padded = [zeros(1,120), interpolated(1:end-40)];
acc_interp = corr(interpolated_padded', sub1_glove(1:999*sub_sample_rate,3))

%%
plot(Y_pred ,'r')
hold on
plot(Y_test, 'b')

%%
figure
plot(interpolated_padded, 'r')
hold on
plot(sub1_glove(1:999*sub_sample_rate,1))