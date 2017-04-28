clc
clear
close all

%% Load data
load('../data.mat')

%% Extract Features
test_ecog = cell(3,1);
window_size = 100; %ms
step_size = 50; %ms
sample_rate = 1000;
sub_sample_rate = 0;
num_channels_sub1 = 62;
num_channels_sub2 = 48;
num_channels_sub3 = 64;

test_ecog{1} = get_features( sub1_ecog_test, [], window_size, step_size, sample_rate, num_channels_sub1, sub_sample_rate);
test_ecog{2} = get_features( sub2_ecog_test, [], window_size, step_size, sample_rate, num_channels_sub2, sub_sample_rate);
test_ecog{3} = get_features( sub3_ecog_test, [], window_size, step_size, sample_rate, num_channels_sub3, sub_sample_rate);

%% Save test features
save('test_features', 'test_ecog')