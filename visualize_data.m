clc
clear
close all

%% Load data
load('../data.mat')

%% Plot channels
sample_rate = 1000;
dur = 310000 / sample_rate;
dur_test = 147500 / sample_rate;
t_train = linspace(0, dur, 310000);
t_test = linspace(0, dur_test, 147500);

for i = 1:62
    figure
    plot(t_train, sub1_ecog(:,i) * 1e-3, 'b');
    hold on
    plot(t_train, sub1_glove(:,1), 'r');
end