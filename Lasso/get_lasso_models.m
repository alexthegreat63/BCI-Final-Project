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
window_size = 100; %ms
step_size = 50; %ms
sub_sample_rate = 50;

[X1, Y1] = get_features(sub1_ecog, sub1_glove, window_size, step_size, sample_rate, num_channels_sub1, sub_sample_rate);
[X2, Y2] = get_features(sub2_ecog, sub2_glove, window_size, step_size, sample_rate, num_channels_sub2, sub_sample_rate);
[X3, Y3] = get_features(sub3_ecog, sub3_glove, window_size, step_size, sample_rate, num_channels_sub3, sub_sample_rate);
  
%% Cross Validate and Train Models

lambda_range = 0:0.001:0.1;
num_folds = 10;
X = {X1, X2, X3};
Y = {Y1, Y2, Y3};
models = cell(3,5);

for sub = 1:3
    for finger = 1:5
        tic
        [mdl, mdl_info, lambda, best_acc, best_acc_idx] = train_lasso_model(X{sub}, Y{sub}(:,finger), lambda_range, num_folds);
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
save('team_awesome_model_lasso', 'models')
