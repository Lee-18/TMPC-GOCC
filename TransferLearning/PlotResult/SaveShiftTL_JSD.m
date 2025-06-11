clc,clear all
for g=1:5
    res{g}=load([fileparts(pwd) '\TL\Group' num2str(g) '\TL_shift\ModelTesting\res.mat']);
end
%%
JSD_all={};
NumOcc=[5,10,15,7];
for k=1:4
JSD_all{k}=[res{1,1}.JSD_tarTL_test(k,:);...
res{1,2}.JSD_tarTL_test(k,:);...
res{1,3}.JSD_tarTL_test(k,:);...
res{1,4}.JSD_tarTL_test(k,:);...
res{1,5}.JSD_tarTL_test(k,:)];
end
%%
JSD_Shift_TL_5occ=JSD_all{1,1};
JSD_Shift_TL_10occ=JSD_all{1,2};
JSD_Shift_TL_15occ=JSD_all{1,3};
JSD_Shift_TL_7occ=JSD_all{1,4};
%%
JSD_Shift_TL_5occ_vec=JSD_Shift_TL_5occ(:);
JSD_Shift_TL_10occ_vec=JSD_Shift_TL_10occ(:);
JSD_Shift_TL_15occ_vec=JSD_Shift_TL_15occ(:);
JSD_Shift_TL_7occ_vec=JSD_Shift_TL_7occ(:);

JSD_allTL_vec=[JSD_Shift_TL_5occ_vec;JSD_Shift_TL_10occ_vec;JSD_Shift_TL_15occ_vec;JSD_Shift_TL_7occ_vec];

save('JSD_allTL_vec.mat','JSD_allTL_vec')


%%
clc,clear all
for g=1:5
    res{g}=load([fileparts(pwd) '\TL\Group' num2str(g) '\TL_shift\ModelTesting\res.mat']);
end
%%
JSD_all={};
NumOcc=[5,10,15,7];
for k=1:4
JSD_all{k}=[res{1,1}.JSD_tar_test(k,:);...
res{1,2}.JSD_tar_test(k,:);...
res{1,3}.JSD_tar_test(k,:);...
res{1,4}.JSD_tar_test(k,:);...
res{1,5}.JSD_tar_test(k,:)];
end
%%
JSD_Shift_5occ=JSD_all{1,1};
JSD_Shift_10occ=JSD_all{1,2};
JSD_Shift_15occ=JSD_all{1,3};
JSD_Shift_7occ=JSD_all{1,4};
%%
JSD_Shift_5occ_vec=JSD_Shift_5occ(:);
JSD_Shift_10occ_vec=JSD_Shift_10occ(:);
JSD_Shift_15occ_vec=JSD_Shift_15occ(:);
JSD_Shift_7occ_vec=JSD_Shift_7occ(:);

JSD_all_vec=[JSD_Shift_5occ_vec;JSD_Shift_10occ_vec;JSD_Shift_15occ_vec;JSD_Shift_7occ_vec];

save('JSD_all_vec.mat','JSD_all_vec')



