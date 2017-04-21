function ll = LLFn(x)
% function computing line length
% INPUT: signal x
% OUTPUT: line length
ll = sum(abs(x(2:end)-x(1:end-1)));
