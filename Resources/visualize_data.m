clc
clear
close all

%% Load data
load('./data.mat')

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

%% Spectrogram
% https://www.mathworks.com/matlabcentral/answers/265969-how-to-understand-spectrogram-function
% for i = 1:62
%     figure
%     plot(t_train, sub1_ecog(:,i) * 1e-3, 'b');
%     hold on
%     plot(t_train, sub1_glove(:,1), 'r');
% end

%% Fourier Transform

fs = 1000; % sampling frequency
y = fft(sub1_ecog(:,2));         
m = abs(y);                
p = angle(y);
f = (0:length(y)-1)*fs/length(y);
% Plot
figure; subplot(2,1,1); plot(f,m);  title('Magnitude'); xlabel('freq (Hz)');
subplot(2,1,2); plot(f,rad2deg(p)); title('Phase'); xlabel('freq (Hz)');
