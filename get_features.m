function [ X, Y ] = get_features( sub_ecog, sub_glove, window_size, step_size, sample_rate, num_channels, sub_sample_rate )

num_windows = floor((size(sub_ecog,1) - window_size) / step_size + 1);
num_feats = 7;
X = zeros(num_windows, num_channels * num_feats);

for i = 1:num_channels
    windows = make_windows(sub_ecog(:,i), sample_rate, window_size, step_size) * 1e-3;
    X(:,(i-1)*num_feats + 1) = mean(windows)';
    X(:,(i-1)*num_feats + 2) = std(windows)'.^2;
    X(:,(i-1)*num_feats + 3) = bandpower(windows, sample_rate, [5   15])';
    X(:,(i-1)*num_feats + 4) = bandpower(windows, sample_rate, [20  25])';
    X(:,(i-1)*num_feats + 5) = bandpower(windows, sample_rate, [75  115])';
    X(:,(i-1)*num_feats + 6) = bandpower(windows, sample_rate, [125 160])';
    X(:,(i-1)*num_feats + 7) = bandpower(windows, sample_rate, [160 175])';
end

X = horzcat(X, ones(size(X,1),1));
if size(sub_glove, 1) == 0
    Y = [];
else
    Y = [decimate(sub_glove(:,1), sub_sample_rate), ...
        decimate(sub_glove(:,2), sub_sample_rate), ...
        decimate(sub_glove(:,3), sub_sample_rate), ...
        decimate(sub_glove(:,4), sub_sample_rate), ...
        decimate(sub_glove(:,5), sub_sample_rate)];
    Y = Y(1:end-1,:);
end

end
