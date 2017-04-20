function [windows] = make_windows(data, sample_rate, window_size, step_size)

% INPUT:
% data: column vector of data samples
% sample_rate: Sample rate in Hz
% window_size: Window size in milliseconds
% step_size: Window step in milliseconds
% 
% OUTPUT:
% windows: Matrix with each window represented as a column 

window_samples = (window_size / 1000 * sample_rate);
step_samples = step_size / 1000 * sample_rate;
num_windows = floor((length(data) - window_samples) / step_samples + 1);

if mod((length(data) - window_samples), step_samples) ~= 0
    data = [data; zeros(mod((length(data) - window_samples), step_samples))];
end

windows = data(1:window_samples);
start = step_samples + 1;
stop = window_samples + step_samples;
for i = 1:num_windows-1
    windows = horzcat(windows, data(start:stop));
    start = start + step_samples;
    stop = stop + step_samples;
end

end