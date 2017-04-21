function [ E ] = EFn( x )
% Function computing energy of signal
% INPUT: x, signal
% OUTPUT: energy of signal
E = sum(x.^2);
end

