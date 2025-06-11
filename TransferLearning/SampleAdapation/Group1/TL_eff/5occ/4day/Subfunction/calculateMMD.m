function mmd_value = calculateMMD(X, Y, sigma)
% input: X: the data in feature domian 1
%        Y: the data in feature domian 2
%        sigma: the parameter of the Gaussian kernel
% output: mmd:  the Maximum Mean Discrepancy between X and Y

% 计算核矩阵
    K_XX = gaussian_kernel(X, X, sigma);
    K_YY = gaussian_kernel(Y, Y, sigma);
    K_XY = gaussian_kernel(X, Y, sigma);

    m = size(X, 1);
    n = size(Y, 1);

    % 计算 MMD^2
    mmd2 = sum(K_XX(:)) / (m * m) + sum(K_YY(:)) / (n * n) - 2 * sum(K_XY(:)) / (m * n);

    % 取平方根
    mmd_value = sqrt(mmd2);
    
    function K = gaussian_kernel(A, B, sigma)
    % A 和 B 是输入数据矩阵
    % sigma 是高斯核的标准差参数
    
    % 计算距离矩阵
    dists = pdist2(A, B, 'euclidean');
    
    % 计算高斯核矩阵
    K = exp(-dists.^2 / (2 * sigma^2));
end
end