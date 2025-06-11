function jsDivergence = JensenShannonDivergence(P, Q)
bins = 0.5:1:7.5;

P= histcounts(P, bins);
Q= histcounts(Q, bins);

% 确保P和Q是概率分布，即它们的元素和为1
P = P / sum(P(:));
Q = Q / sum(Q(:));

% 计算M

M = 0.5 * (P + Q);

% 计算KL散度
klP_M = KLDivergence(P, M);
klQ_M = KLDivergence(Q, M);

% 计算JS散度
jsDivergence = 0.5 * (klP_M + klQ_M);
end

function klDiv = KLDivergence(P, Q)
    % 这里使用非零元素的索引来避免0*log(0)这种情况
    nonZeroIndices = P > 0;

    % 计算KL散度
    klDiv = sum(P(nonZeroIndices) .* log(P(nonZeroIndices) ./ Q(nonZeroIndices)));
end