function NumWins = getNumWins(xLen, fs, winLen, winDisp)
% function computing number of possible windows
% INPUTS:
% xLen: number of samples in signal
% fs: Hz, sampling frequency of signal
% winLen: s, window length
% winDisp: s, window displacement
% OUTPUT: NumWins, number of full windows in signal
NumWins = floor( (xLen-winLen*fs)/(winDisp*fs)+1 );
end

