clc,clear all
for g=1:5
    res{g}=load([fileparts(pwd) '\TL\Group' num2str(g) '\TL_eff\ModelTesting\res.mat']);
end
%%
MarkSize=9;
NumOcc=[5,10,15,7];
for k=1:4
figure('Position', [100, 100, 800, 400]);
plot([100,100],'o','MarkerSize', 12,'LineWidth', 1,'Color',[0,0,0]);hold on
plot([100,100],'square','MarkerSize', 12,'LineWidth', 1,'Color',[0,0,0]);hold on
plot([100,100],'diamond','MarkerSize', 12,'LineWidth', 1,'Color',[0,0,0]);hold on
plot([100,100],'+','MarkerSize', 12,'LineWidth', 1,'Color',[0,0,0]);hold on
plot([100,100],'x','MarkerSize', 12,'LineWidth', 1,'Color',[0,0,0]);hold on
plot([100,100],[101,101],'LineWidth', 5,'Color',[0,0.447,0.741]);
plot([100,100],[101,101],'LineWidth', 5,'Color',[0.85,0.325,0.098]);

plot([1:5]-0.2,res{1,1}.JSD_tar_test(k,:),'o','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0,0.447,0.741]); 
plot([1:5]-0.1,res{1,2}.JSD_tar_test(k,:),'square','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0,0.447,0.741]);
plot([1:5],res{1,3}.JSD_tar_test(k,:),'diamond','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0,0.447,0.741]);
plot([1:5]+0.1,res{1,4}.JSD_tar_test(k,:),'+','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0,0.447,0.741]);
plot([1:5]+0.2,res{1,5}.JSD_tar_test(k,:),'x','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0,0.447,0.741]);
plot([1:5]-0.2,res{1,1}.JSD_tar_test(k,:),'Color',[0,0.447,0.741]); 
plot([1:5]-0.1,res{1,2}.JSD_tar_test(k,:),'Color',[0,0.447,0.741]);
plot([1:5],res{1,3}.JSD_tar_test(k,:),'Color',[0,0.447,0.741]);
plot([1:5]+0.1,res{1,4}.JSD_tar_test(k,:),'Color',[0,0.447,0.741]);
plot([1:5]+0.2,res{1,5}.JSD_tar_test(k,:),'Color',[0,0.447,0.741]);

plot([1:5]-0.2,res{1,1}.JSD_tarTL_test(k,:),'o','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0.85,0.325,0.098]);
plot([1:5]-0.1,res{1,2}.JSD_tarTL_test(k,:),'square','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0.85,0.325,0.098]);
plot([1:5],res{1,3}.JSD_tarTL_test(k,:),'diamond','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0.85,0.325,0.098]);
plot([1:5]+0.1,res{1,4}.JSD_tarTL_test(k,:),'+','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0.85,0.325,0.098]);
plot([1:5]+0.2,res{1,5}.JSD_tarTL_test(k,:),'x','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0.85,0.325,0.098]);
plot([1:5]-0.2,res{1,1}.JSD_tarTL_test(k,:),'Color',[0.85,0.325,0.098]);
plot([1:5]-0.1,res{1,2}.JSD_tarTL_test(k,:),'Color',[0.85,0.325,0.098]);
plot([1:5],res{1,3}.JSD_tarTL_test(k,:),'Color',[0.85,0.325,0.098]);
plot([1:5]+0.1,res{1,4}.JSD_tarTL_test(k,:),'Color',[0.85,0.325,0.098]);
plot([1:5]+0.2,res{1,5}.JSD_tarTL_test(k,:),'Color',[0.85,0.325,0.098]);

xticks(1:5);
ylim([0,log(2)])
grid on
xlabel('target data collection period [day]')
ylabel('JSD_{test}')
% legend('G1','G2','G3','G4','G5','noTL','TL')
title([num2str(NumOcc(k)) 'occ'])
end
%%
clc,clear all
for g=1:5
    res{g}=load([fileparts(pwd) '\TL\Group' num2str(g) '\TL_shift\ModelTesting\res.mat']);
end
%%
MarkSize=9;
NumOcc=[5,10,15,7];
for k=1:4
figure('Position', [100, 100, 800, 400]);
plot([100,100],'o','MarkerSize', 12,'LineWidth', 1,'Color',[0,0,0]);hold on
plot([100,100],'square','MarkerSize', 12,'LineWidth', 1,'Color',[0,0,0]);hold on
plot([100,100],'diamond','MarkerSize', 12,'LineWidth', 1,'Color',[0,0,0]);hold on
plot([100,100],'+','MarkerSize', 12,'LineWidth', 1,'Color',[0,0,0]);hold on
plot([100,100],'x','MarkerSize', 12,'LineWidth', 1,'Color',[0,0,0]);hold on
plot([100,100],[101,101],'LineWidth', 5,'Color',[0,0.447,0.741]);
plot([100,100],[101,101],'LineWidth', 5,'Color',[0.85,0.325,0.098]);

plot([1:5]-0.2,res{1,1}.JSD_tar_test(k,:),'o','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0,0.447,0.741]); 
plot([1:5]-0.1,res{1,2}.JSD_tar_test(k,:),'square','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0,0.447,0.741]);
plot([1:5],res{1,3}.JSD_tar_test(k,:),'diamond','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0,0.447,0.741]);
plot([1:5]+0.1,res{1,4}.JSD_tar_test(k,:),'+','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0,0.447,0.741]);
plot([1:5]+0.2,res{1,5}.JSD_tar_test(k,:),'x','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0,0.447,0.741]);

plot([1:5]-0.2,res{1,1}.JSD_tarTL_test(k,:),'o','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0.85,0.325,0.098]);
plot([1:5]-0.1,res{1,2}.JSD_tarTL_test(k,:),'square','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0.85,0.325,0.098]);
plot([1:5],res{1,3}.JSD_tarTL_test(k,:),'diamond','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0.85,0.325,0.098]);
plot([1:5]+0.1,res{1,4}.JSD_tarTL_test(k,:),'+','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0.85,0.325,0.098]);
plot([1:5]+0.2,res{1,5}.JSD_tarTL_test(k,:),'x','MarkerSize', MarkSize,'LineWidth', 1,'Color',[0.85,0.325,0.098]);
xticks(1:5);
ylim([0,log(2)])
grid on
xlabel('target data collection period [day]')
ylabel('JSD_{test}')
% legend('G1','G2','G3','G4','G5','noTL','TL')
title([num2str(NumOcc(k)) 'occ'])
end
