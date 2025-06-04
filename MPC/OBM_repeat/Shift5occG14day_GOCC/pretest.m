a=load('OBM_Data1.mat');
b=load('OBM_Data2.mat');
c=load('OBM_Data3.mat');

occ1=sum(a.OBM_Data(:,1:15),2);
occ2=sum(b.OBM_Data(:,1:15),2);
occ3=sum(c.OBM_Data(:,1:15),2);

comf1=sum(a.OBM_Data(:,16:30),2);
comf2=sum(b.OBM_Data(:,16:30),2);
comf3=sum(c.OBM_Data(:,16:30),2);

figure
plot(occ1); hold on
plot(occ2); hold on
plot(occ3); hold on

figure
plot(comf1); hold on
plot(comf2); hold on
plot(comf3); hold on