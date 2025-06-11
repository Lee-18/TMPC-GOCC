clc,clear all
i=1;
for NumOcc=[5,10,15,7] % 5, 10, 15, 7
    %
    for NumDay=1:5
        JSD_tar_test(i,NumDay)=TargetModelTesting(NumOcc,NumDay);
        JSD_tarTL_test(i,NumDay)=TargetTLModelTesting(NumOcc,NumDay);
    end
    %
%     figure
%     plot(JSD_tar_test(i,:),'o'); hold on
%     plot(JSD_tarTL_test(i,:),'*');
%     grid on
%     legend('no TL','TL')
%     xlabel('target data collection period [day]')
%     ylabel('JSD_{test}')
%     title([num2str(NumOcc) 'occ'])
%     xticks(1:5);
%     ylim([0,log(2)])
    i=i+1;
end
%%
NumOcc=[5,10,15,7];
for k=1:4
    figure
    plot(JSD_tar_test(k,:),'o','MarkerSize', 12,'LineWidth', 2); hold on
    plot(JSD_tarTL_test(k,:),'*','MarkerSize', 12,'LineWidth', 2);
    grid on
    legend('no TL','TL')
    xlabel('target data collection period [day]')
    ylabel('JSD_{test}')
    title([num2str(NumOcc(k)) 'occ'])
    xticks(1:5);
    ylim([0,log(2)])
end
%%
save('res.mat','JSD_tar_test','JSD_tarTL_test')