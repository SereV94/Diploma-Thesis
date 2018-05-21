%% Initial preprocessing of feature array Section

clear;
load('feature_arr');
load('..\Preprocessed_EEG\label.mat');
new_l = repmat(label,1,45); % create outputs for all observations

%% remove constant (or almost constant features) 

not_const = removeconstantrows(ftr_arr',0.002);

%% z-normalization of each feature

obs = zscore(not_const');
fs = size(obs,2);
labels = new_l';
save('normalized_obs','obs');
save('labels_v2','labels');
    
%% ReliefF Section
fprintf('Entering RelieF calculation Section\n');
for nbr = 5:5:30,
     [ranked_relieff,~] = relieff(obs,labels,nbr,'method','classification'); 
     save(['reliefF_features_',num2str(nbr)],'ranked_relieff');
end
 
%% Cohen's f^2 Section
fprintf('Entering Cohen f^2 calculation Section\n');
ranked_cohen = cohen_f_squared(obs, labels);
save('cohen_features','ranked_cohen');

%% mRMR Section
fprintf('Entering mRMR calculation Section\n');
% only 823 features to be used and maybe to put both mrmr_q 
  
[ranked_q_mrmr,ranked_d_mrmr] = mrmr_calculation(obs, labels, 823);
save(['mrmr_features_',num2str(823)],'ranked_d_mrmr','ranked_q_mrmr');

%% FCBF Section 
fprintf('Entering fcbf calculation Section\n');
count = 1;
for delta=0.005:0.005:0.03,
    ranked_fcbf = FCBF(obs,labels,delta);
    save(['fcbf_features_',num2str(count)],'ranked_fcbf');
    count = count + 1;
end

%% infFS Section
fprintf('Entering infFS calculation Section\n');
count = 1;
for a = 0.1:0.1:1,
    for init = 1:9,
        if init<7,
            load(['reliefF_features_',num2str(5*init)]);
            [ranked_infFS, ~] = infFS( obs(:,ranked_relieff(1:1646)), labels, a, 0, 1 );
        elseif init==7,
            load('mrmr_features_823');
            [ranked_infFS, ~] = infFS( obs(:,ranked_d_mrmr), labels, a, 0, 1 );
        elseif init==8,
            load('mrmr_features823');
            [ranked_infFS, ~] = infFS( obs(:,ranked_q_mrmr), labels, a, 0, 1 );
        else
            load('cohen_features');
            [ranked_infFS, ~] = infFS( obs(:,ranked_cohen(1:1646)), labels, a, 0, 1 );
        end
        save(['infFS_features_',num2str(count),'_',num2str(init)],'ranked_infFS');
    end
    count = count + 1;
end
