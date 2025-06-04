function mmdValue = ObjFcn_sampled(sampleIndices, samplesA, samplesB, sigma)
    sampledC = samplesA(sampleIndices,:);
    % 计算样本集C和B之间的MMD
    mmdValue = calculateMMD(samplesB, sampledC, sigma);
end