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
num_windows = floor((size(sub1_ecog_test,1) - window_size) / step_size + 1);

num_channels_sub1 = 62;
test_ecog{1} = zeros(num_windows, num_channels_sub1 * 6);
for i = 1:num_channels_sub1
    windows = make_windows(sub1_ecog_test(:,i), sample_rate, window_size, step_size) * 1e-3;
    test_ecog{1}(:,(i-1)*6 + 1) = mean(windows)';
    test_ecog{1}(:,(i-1)*6 + 2) = bandpower(windows, sample_rate, [5   15])';
    test_ecog{1}(:,(i-1)*6 + 3) = bandpower(windows, sample_rate, [20  25])';
    test_ecog{1}(:,(i-1)*6 + 4) = bandpower(windows, sample_rate, [75  115])';
    test_ecog{1}(:,(i-1)*6 + 5) = bandpower(windows, sample_rate, [125 160])';
    test_ecog{1}(:,(i-1)*6 + 6) = bandpower(windows, sample_rate, [160 175])';
end
test_ecog{1} = horzcat(test_ecog{1}, ones(size(test_ecog{1},1),1));

num_channels_sub2 = 48;
test_ecog{2} = zeros(num_windows, num_channels_sub2 * 6);
for i = 1:num_channels_sub2
    windows = make_windows(sub2_ecog_test(:,i), sample_rate, window_size, step_size) * 1e-3;
    test_ecog{2}(:,(i-1)*6 + 1) = mean(windows)';
    test_ecog{2}(:,(i-1)*6 + 2) = bandpower(windows, sample_rate, [5   15])';
    test_ecog{2}(:,(i-1)*6 + 3) = bandpower(windows, sample_rate, [20  25])';
    test_ecog{2}(:,(i-1)*6 + 4) = bandpower(windows, sample_rate, [75  115])';
    test_ecog{2}(:,(i-1)*6 + 5) = bandpower(windows, sample_rate, [125 160])';
    test_ecog{2}(:,(i-1)*6 + 6) = bandpower(windows, sample_rate, [160 175])';
end
test_ecog{2} = horzcat(test_ecog{2}, ones(size(test_ecog{2},1),1));

num_channels_sub3 = 64;
test_ecog{3} = zeros(num_windows, num_channels_sub3 * 6);
for i = 1:num_channels_sub3
    windows = make_windows(sub3_ecog_test(:,i), sample_rate, window_size, step_size) * 1e-3;
    test_ecog{3}(:,(i-1)*6 + 1) = mean(windows)';
    test_ecog{3}(:,(i-1)*6 + 2) = bandpower(windows, sample_rate, [5   15])';
    test_ecog{3}(:,(i-1)*6 + 3) = bandpower(windows, sample_rate, [20  25])';
    test_ecog{3}(:,(i-1)*6 + 4) = bandpower(windows, sample_rate, [75  115])';
    test_ecog{3}(:,(i-1)*6 + 5) = bandpower(windows, sample_rate, [125 160])';
    test_ecog{3}(:,(i-1)*6 + 6) = bandpower(windows, sample_rate, [160 175])';
end
test_ecog{3} = horzcat(test_ecog{3}, ones(size(test_ecog{3},1),1));

%% Save test features
save('test_features', 'test_ecog')