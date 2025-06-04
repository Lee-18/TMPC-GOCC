function mmd = calculateMMD(X, Y, sigma)
% input: X: the data in feature domian 1
%        Y: the data in feature domian 2
%        sigma: the parameter of the Gaussian kernel
% output: mmd:  the Maximum Mean Discrepancy between X and Y

gaussianKernel = @(x,y) exp(-pdist2(x,y).^2/(2*sigma^2));

X = (X - min([X;Y])) ./ (max([X;Y]) -  min([X;Y]));
Y = (Y - min([X;Y])) ./ (max([X;Y]) -  min([X;Y]));

m = size(X,1);
n = size(Y,1);
XX = pdist2(X, X, gaussianKernel);
YY = pdist2(Y, Y, gaussianKernel);
XY = pdist2(X, Y, gaussianKernel);
mmd = sum(sum(XX))/(m^2) + sum(sum(YY))/(n^2) - 2*sum(sum(XY))/(m*n);
end