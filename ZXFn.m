function [ ZX ] = ZXFn( x )
% Function computing zero-crossings of signal (from above)
% INPUT: x, signal
% OUTPUT: number of zero-crossings of signal
ZX = sum(or( (x(1:end-1)-mean(x)>0).*(x(2:end)-mean(x)<0) , ...
    (x(1:end-1)-mean(x)<0).*(x(2:end)-mean(x)>0) ));

end

