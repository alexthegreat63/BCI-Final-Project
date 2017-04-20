function [ v ] = MovingWinFeats(x, fs, winLen, winDisp, featFn)
% Returns a vector of the values of the feature on the signal x in all the possible windows
% INPUTS:
% x: signal
% fs: Hz, sampling frequency of signal
% winLen: s, window length
% winDisp: s, window displacement
% featFn: feature function
% OUTPUT: a vector of the values of the feature on the signal x in all the possible windows

numWins = floor( (length(x)-winLen*fs)/(winDisp*fs)+1 ); % number of windows
v = zeros(1,numWins); % initialize resultant vector
for i = 1:numWins
    start = floor(1+(i-1)*winDisp*fs);
    sig = x(start:start+floor(winLen*fs)-1);
    v(i) = featFn( sig );
end

end

