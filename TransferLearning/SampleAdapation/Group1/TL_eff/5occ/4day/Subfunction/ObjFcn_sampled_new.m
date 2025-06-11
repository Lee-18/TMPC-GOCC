function mmdValue = ObjFcn_sampled_new(sampleIndices, samplesA, samplesB, sigma)

sampledC = [];
for i = 1:length(sampleIndices)
    sampledC = [sampledC; repmat(samplesA(i,:), sampleIndices(i),1)];
end

% 计算样本集C和B之间的MMD
if isempty(sampledC)
    mmdValue=9999;
else
    mmdValue = calculateMMD(samplesB, sampledC, sigma);
end
end