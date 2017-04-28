function [ ZX ] = ZXFn( x )
% Function computing zero-crossings of signal (from above)
% INPUT: x, signal
% OUTPUT: number of zero-crossings of signal
m = mean(x);
x1 = x(1:end-1,:);
x2 = x(2:end,:);
ZX = sum(or( (x1-m>0).*(x2-m<0) , ...
    (x1-m<0).*(x2-m>0) ));

end

