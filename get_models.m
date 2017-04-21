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
num_channels_sub1 = 62;
num_channels_sub2 = 48;
num_channels_sub3 = 64;

%% Extract features
window_size = 100; %ms
step_size = 50; %ms
num_windows_sub1 = floor((size(sub1_ecog,1) - window_size) / step_size + 1);
X1 = zeros(num_windows_sub1, num_channels_sub1 * 6);
num_windows_sub2 = floor((size(sub2_ecog,1) - window_size) / step_size + 1);
X2 = zeros(num_windows_sub2, num_channels_sub2 * 6);
num_windows_sub3 = floor((size(sub3_ecog,1) - window_size) / step_size + 1);
X3 = zeros(num_windows_sub3, num_channels_sub3 * 6);

for i = 1:num_channels_sub1
    windows = make_windows(sub1_ecog(:,i), sample_rate, window_size, step_size) * 1e-3;
    X1(:,(i-1)*6 + 1) = mean(windows)';
    X1(:,(i-1)*6 + 2) = bandpower(windows, sample_rate, [5   15])';
    X1(:,(i-1)*6 + 3) = bandpower(windows, sample_rate, [20  25])';
    X1(:,(i-1)*6 + 4) = bandpower(windows, sample_rate, [75  115])';
    X1(:,(i-1)*6 + 5) = bandpower(windows, sample_rate, [125 160])';
    X1(:,(i-1)*6 + 6) = bandpower(windows, sample_rate, [160 175])';
end
X1 = horzcat(X1, ones(size(X1,1),1));

for i = 1:num_channels_sub2
    windows = make_windows(sub2_ecog(:,i), sample_rate, window_size, step_size) * 1e-3;
    X2(:,(i-1)*6 + 1) = mean(windows)';
    X2(:,(i-1)*6 + 2) = bandpower(windows, sample_rate, [5   15])';
    X2(:,(i-1)*6 + 3) = bandpower(windows, sample_rate, [20  25])';
    X2(:,(i-1)*6 + 4) = bandpower(windows, sample_rate, [75  115])';
    X2(:,(i-1)*6 + 5) = bandpower(windows, sample_rate, [125 160])';
    X2(:,(i-1)*6 + 6) = bandpower(windows, sample_rate, [160 175])';
end
X2 = horzcat(X2, ones(size(X2,1),1));

for i = 1:num_channels_sub3
    windows = make_windows(sub3_ecog(:,i), sample_rate, window_size, step_size) * 1e-3;
    X3(:,(i-1)*6 + 1) = mean(windows)';
    X3(:,(i-1)*6 + 2) = bandpower(windows, sample_rate, [5   15])';
    X3(:,(i-1)*6 + 3) = bandpower(windows, sample_rate, [20  25])';
    X3(:,(i-1)*6 + 4) = bandpower(windows, sample_rate, [75  115])';
    X3(:,(i-1)*6 + 5) = bandpower(windows, sample_rate, [125 160])';
    X3(:,(i-1)*6 + 6) = bandpower(windows, sample_rate, [160 175])';
end
X3 = horzcat(X3, ones(size(X3,1),1));

Y1 = [decimate(sub1_glove(:,1), 50), ...
      decimate(sub1_glove(:,2), 50), ...
      decimate(sub1_glove(:,3), 50), ...
      decimate(sub1_glove(:,4), 50), ...
      decimate(sub1_glove(:,5), 50)];
Y1 = Y1(2:end,:);

Y2 = [decimate(sub2_glove(:,1), 50), ...
      decimate(sub2_glove(:,2), 50), ...
      decimate(sub2_glove(:,3), 50), ...
      decimate(sub2_glove(:,4), 50), ...
      decimate(sub2_glove(:,5), 50)];
Y2 = Y2(2:end,:);
  
Y3 = [decimate(sub3_glove(:,1), 50), ...
      decimate(sub3_glove(:,2), 50), ...
      decimate(sub3_glove(:,3), 50), ...
      decimate(sub3_glove(:,4), 50), ...
      decimate(sub3_glove(:,5), 50)];
Y3 = Y3(2:end,:);
  
%% Cross Validate and Train Models

lambda_range = 0:0.001:0.1;
num_folds = 10;
X = {X1, X2, X3};
Y = {Y1, Y2, Y3};
models = cell(3,5);

for sub = 1:3
    for finger = 1:5
        tic
        [mdl, mdl_info, lambda, best_acc, best_acc_idx] = train_model(X{sub}, Y{sub}(:,finger), lambda_range, num_folds);
        model.weights = mdl;
        model.info = mdl_info;
        model.lambda = lambda;
        model.lambda_range = lambda_range;
        model.best_acc = best_acc;
        model.best_acc_idx = best_acc_idx;
        models{sub, finger} = model;
        toc
    end
end

%% Save Models
save('team_awesome_model', 'models')
