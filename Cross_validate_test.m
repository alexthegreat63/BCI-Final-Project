clc
clear
close all

%% Load data
load('../data.mat');
sample_rate = 1000;
dur = 310000 / sample_rate;
dur_test = 147500 / sample_rate;
t_train = linspace(0, dur, 310000);
t_test = linspace(0, dur_test, 147500);
num_channels = 62;

%% Extract Features
window_size = 100; %ms
step_size = 50; %ms
num_windows = floor((size(sub1_ecog,1) - window_size) / step_size + 1);
X = zeros(num_windows, num_channels * 6);

for i = 1:num_channels
    windows = make_windows(sub1_ecog(:,i), sample_rate, window_size, step_size) * 1e-3;
    X(:,(i-1)*6 + 1) = mean(windows)';
%     X(:,(i-1)*6 + 2) = mean(abs(spectrogram(sub1_ecog(:,i)*1e-3, window_size, step_size, [5:15], sample_rate)))';
%     X(:,(i-1)*6 + 3) = mean(abs(spectrogram(sub1_ecog(:,i)*1e-3, window_size, step_size, [20:25], sample_rate)))';
%     X(:,(i-1)*6 + 4) = mean(abs(spectrogram(sub1_ecog(:,i)*1e-3, window_size, step_size, [75:115], sample_rate)))';
%     X(:,(i-1)*6 + 5) = mean(abs(spectrogram(sub1_ecog(:,i)*1e-3, window_size, step_size, [125:160], sample_rate)))';
%     X(:,(i-1)*6 + 6) = mean(abs(spectrogram(sub1_ecog(:,i)*1e-3, window_size, step_size, [160:175], sample_rate)))';
    X(:,(i-1)*6 + 2) = bandpower(windows, sample_rate, [5   15])';
    X(:,(i-1)*6 + 3) = bandpower(windows, sample_rate, [20  25])';
    X(:,(i-1)*6 + 4) = bandpower(windows, sample_rate, [75  115])';
    X(:,(i-1)*6 + 5) = bandpower(windows, sample_rate, [125 160])';
    X(:,(i-1)*6 + 6) = bandpower(windows, sample_rate, [160 175])';
end

X = horzcat(X, ones(size(X,1),1));
Y = decimate(sub1_glove(:,1), 50);

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
Y_train = Y(1000:end-1);
X_test = X(1:999,:);
Y_test = Y(1:999);
[mdl_best, info_best] = lasso(X_train, Y_train, 'Lambda', info.Lambda(best_acc_idx));
Y_pred = X_test * mdl_best + repmat(info_best.Intercept, size(X_test,1), 1);
acc = corr(Y_pred, Y_test);

interpolated = spline(1:999, Y_pred, linspace(1,999,49950));
corr(interpolated', sub1_glove(1:49950,1))

%%
plot(Y_pred(:,best_acc_idx))
hold on
plot(Y_test)