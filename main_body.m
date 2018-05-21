clear;

%% Loading of the preprocessed data

load('normalized_obs');
load('labels_v2');
fs = size(obs,2);

%% Selection of the classification method

% flag = 0; % -> for rfor
% flag = 1; % -> for svm
flag = 2; % -> for dbn
% flag = 3; % -> for qda
% flag = 4; % -> for knn

%% processing of labels in order to be in suitable format for dbn

if flag == 2,
    
    dbn_labels = zeros(size(labels,1),3);
    for i=1:size(labels,1),
        if labels(i,1) == -1,
            dbn_labels(i,1) = 1;
        elseif labels(i,1) == 0,
            dbn_labels(i,2) = 1;
        else
            dbn_labels(i,3) = 1;
        end
    end
end

c = cvpartition(labels,'Kfold',9); % usage of cvpartition class object instead of crossvalind function
folds = cell(c.NumTestSets,1890); % six are the fs methods with more than one fs matrix plus 18 types of metrics for each fs
if flag == 0 || flag == 4, % rfor || knn -> 3 # of features x 6 diff hyperparameters of each clf method
    acc_v2 = zeros(3,6);
    tpos = cell(3,6);
    tneg = cell(3,6);
    fpos= cell(3,6);
    fneg= cell(3,6);
    conf= cell(3,6);
    acc= cell(3,6);
    err= cell(3,6);
    recall= cell(3,6);
    precision= cell(3,6);
    avg_acc= zeros(3,6);
    avg_err= zeros(3,6);
    macro_f1= zeros(3,6);
    macro_recall= zeros(3,6);
    macro_precision= zeros(3,6);
    micro_f1= zeros(3,6);
    micro_recall= zeros(3,6);
    micro_precision= zeros(3,6);
elseif flag == 3, % qda -> 3 # of features x 1 run of the clf method
    acc_v2 = zeros(3,1);
    tpos = cell(3,1);
    tneg = cell(3,1);
    fpos= cell(3,1);
    fneg= cell(3,1);
    conf= cell(3,1);
    acc= cell(3,1);
    err= cell(3,1);
    recall= cell(3,1);
    precision= cell(3,1);
    avg_acc= zeros(3,1);
    avg_err= zeros(3,1);
    macro_f1= zeros(3,1);
    macro_recall= zeros(3,1);
    macro_precision= zeros(3,1);
    micro_f1= zeros(3,1);
    micro_recall= zeros(3,1);
    micro_precision= zeros(3,1);
elseif flag == 2, % dbn -> 1 # number of features x 16 diff numbers of neurons
    acc_v2 = zeros(1,16);
    tpos = cell(1,16);
    tneg = cell(1,16);
    fpos= cell(1,16);
    fneg= cell(1,16);
    conf= cell(1,16);
    acc= cell(1,16);
    err= cell(1,16);
    recall= cell(1,16);
    precision= cell(1,16);
    avg_acc= zeros(1,16);
    avg_err= zeros(1,16);
    macro_f1= zeros(1,16);
    macro_recall= zeros(1,16);
    macro_precision= zeros(1,16);
    micro_f1= zeros(1,16);
    micro_recall= zeros(1,16);
    micro_precision= zeros(1,16);
end

fprintf('entering the selection process \n');

%% Feature selection Section

choice = 1;

if choice==1,
    
    temp = 1;
    field1 = 'relieff';
    value1 = cell(6,1);
    for neighbors=5:5:30,
        load(['reliefF_features_',num2str(neighbors)]);
        value1{temp} = ranked_relieff;
        clear ranked_relieff;
        temp = temp + 1;
    end
    
    load('cohen_features');
    value2 = ranked_cohen;
    field2 = 'cohen';
    
    load('mrmr_features_823');
    value3 = ranked_q_mrmr;
    field3 = 'mrmr_q';  
    value4 = ranked_d_mrmr;
    field4 = 'mrmr_d';  
    
    count = 1;
    value5 = cell(6,1);
    field5 = 'fcbf';
    for delta=0.005:0.005:0.03,
        load(['fcbf_features_',num2str(count)]);
        value5{count} = ranked_fcbf;
        count = count + 1;
        clear ranked_fcbf;
    end
    
    temp = 1;
    count = 1;
    value6 = cell(90,1);
    for a = 0.1:0.1:1,
        for init = 1:9,
            load(['infFS_features_',num2str(count),'_',num2str(init)]);
            value6{temp} = ranked_infFS;
            clear ranked_infFS;
            temp = temp + 1;
        end
        count = count + 1;
    end
    field6 = 'inf';  %value6 = ranked_infFS;
    
    field_names = {'relieff','cohen','mrmr_q','mrmr_d','fcbf','inf'};

    sel_struct = struct(field1,{value1},field2,value2,field3,value3,field4,value4,field5,{value5},field6,{value6});
else
    % TO DO -> the selection from the instances in each fold
end

fprintf('now entering the classification process \n');

%% Classification Section

for i = 1:c.NumTestSets,
    fprintf('starting for fold %d\n',i);
    trIdx = training(c,i);
    teIdx = test(c,i);
    obs_tr = obs(trIdx,:); % training observations of each fold
    obs_te = obs(teIdx,:); % testing observations of each fold
    if flag == 2,
        dbn_y_tr = dbn_labels(trIdx,:); % training outputs of each fold for dbn
        dbn_y_te = dbn_labels(teIdx,:); % expected outputs of each fold for dbn
        fprintf('for dbn sizes of output are %d and %d \n',size(dbn_y_tr,1),size(dbn_y_tr,2)); % just checking
    end
    y_tr = labels(trIdx,:); % training outputs of each fold
    y_te = labels(teIdx,:); % expected outputs of each fold
    
    count_sel = 0;
    for sel=1:6,        
        if sel >=2 && sel<=4,
            t_ranked = sel_struct.(field_names{sel}); % selection of the fs array to use for the ranking
            count_fs = 1; 
        else
            cell_ranked = sel_struct.(field_names{sel}); % for these indeces the outcome is cell array
            count_fs = length(cell_ranked);
        end
        
        % proper usage of the cell dimensions for the fs methods
        for cell_idx = 1:count_fs,
            count_sel = count_sel + 1;
            if sel < 2 || sel > 4,
                t_ranked = cell_ranked{cell_idx,1};
            end
            %% random Forest
            if flag == 0, 
                nfs_arr = [0.05 0.1 0.2];
                % check the case when # of features less than 823
                if nfs_arr(1)*fs>=length(t_ranked),
                    feat_max = 1;
                elseif nfs_arr(2)*fs>=length(t_ranked),
                    feat_max = 2;
                else
                    feat_max = size(nfs_arr,2);
                end
                for j = 1:feat_max,
                    % if that is the case then treat it properly
                    if feat_max == 1,
                        nfs  = length(t_ranked);
                    else
                        nfs = nfs_arr(j)*fs;
                    end
                    fprintf('using %d features\n',nfs);
                    %% mse calculation of classification of each fold
                    for trees = 50:50:300,
                        [res,tpos{j,trees/50},tneg{j,trees/50},fpos{j,trees/50},fneg{j,trees/50},conf{j,trees/50},acc{j,trees/50},...
                        err{j,trees/50},recall{j,trees/50},precision{j,trees/50},avg_acc(j,trees/50),avg_err(j,trees/50),...
                        macro_f1(j,trees/50),macro_recall(j,trees/50),macro_precision(j,trees/50),micro_f1(j,trees/50),...
                        micro_recall(j,trees/50),micro_precision(j,trees/50)] = rfor_classify(obs_tr(:,t_ranked(1:nfs)),y_tr,...
                        obs_te(:,t_ranked(1:nfs)),y_te,trees); 
                        acc_v2(j,trees/50) = res/c.TestSize(i);
                    end
                end
            end
            %% SVM
            if flag == 1, 
                nfs_arr = [0.05 0.1 0.2];
                % check the case when # of features less than 823
                if nfs_arr(1)*fs>=length(t_ranked),
                    feat_max = 1;
                elseif nfs_arr(2)*fs>=length(t_ranked),
                    feat_max = 2;
                else
                    feat_max = size(nfs_arr,2);
                end
                cost = 1:10;
                gamma = -15:-7;
                acc_v2 = zeros(size(cost,2),size(gamma,2),3);
                tpos = cell(size(cost,2),size(gamma,2),3);
                tneg = cell(size(cost,2),size(gamma,2),3);
                fpos= cell(size(cost,2),size(gamma,2),3);
                fneg= cell(size(cost,2),size(gamma,2),3);
                conf= cell(size(cost,2),size(gamma,2),3);
                acc= cell(size(cost,2),size(gamma,2),3);
                err= cell(size(cost,2),size(gamma,2),3);
                recall= cell(size(cost,2),size(gamma,2),3);
                precision= cell(size(cost,2),size(gamma,2),3);
                avg_acc= zeros(size(cost,2),size(gamma,2),3);
                avg_err= zeros(size(cost,2),size(gamma,2),3);
                macro_f1= zeros(size(cost,2),size(gamma,2),3);
                macro_recall= zeros(size(cost,2),size(gamma,2),3);
                macro_precision= zeros(size(cost,2),size(gamma,2),3);
                micro_f1= zeros(size(cost,2),size(gamma,2),3);
                micro_recall= zeros(size(cost,2),size(gamma,2),3);
                micro_precision= zeros(size(cost,2),size(gamma,2),3);
                for k = 1:feat_max,
                    % if that is the case then treat it properly
                    if feat_max == 1,
                        nfs  = length(t_ranked);
                    else
                        nfs = nfs_arr(k)*fs;
                    end
                    fprintf('using %d features\n',nfs);
                    for j = 1:size(cost,2);
                        fprintf('with %d cost\n',2^cost(j));
                        for m = 1:size(gamma,2),
                            fprintf('and with %d gamma value\n',2^gamma(m));
                            [res,tpos{j,m,k},tneg{j,m,k},fpos{j,m,k},fneg{j,m,k},conf{j,m,k},acc{j,m,k},err{j,m,k},recall{j,m,k},precision{j,m,k},...
                            avg_acc(j,m,k),avg_err(j,m,k),macro_f1(j,m,k),macro_recall(j,m,k),macro_precision(j,m,k),micro_f1(j,m,k),...
                            micro_recall(j,m,k),micro_precision(j,m,k)] = svm_classify(obs_tr(:,t_ranked(1:nfs)),...
                            y_tr,obs_te(:,t_ranked(1:nfs)),y_te,2^cost(j),2^gamma(m));
                            acc_v2(j,m,k) = res/c.TestSize(i);
                        end
                    end
                end
            end
            %% DBN
            if flag == 2, 
                j = 1;
                %fprintf('using %d features for dbn\n',0.05*fs);
                if length(t_ranked) >= 800,
                    for fl = 50:50:800,
                        %for sl = 50:50:400,
                        fprintf('using %d neurons in the hidden layer \n',fl);
                        [ErrorRate,tpos{j},tneg{j},fpos{j},fneg{j},conf{j},acc{j},err{j},recall{j},precision{j},avg_acc(j),avg_err(j),macro_f1(j),macro_recall(j),...
                        macro_precision(j),micro_f1(j),micro_recall(j),micro_precision(j)] = dbn_classify_v2(obs_tr(:,t_ranked(1:fl)),...
                        dbn_y_tr,obs_te(:,t_ranked(1:fl)),dbn_y_te,fl);
                        acc_v2(j) = ErrorRate;
                        j = j + 1;
                        %end
                    end
                else
                    fl = length(t_ranked);
                    %for sl = 50:50:400,
                    fprintf('using %d neurons in the hidden layer \n',fl);
                    [ErrorRate,tpos{j},tneg{j},fpos{j},fneg{j},conf{j},acc{j},err{j},recall{j},precision{j},avg_acc(j),avg_err(j),macro_f1(j),macro_recall(j),...
                    macro_precision(j),micro_f1(j),micro_recall(j),micro_precision(j)] = dbn_classify_v2(obs_tr(:,t_ranked(1:fl)),...
                    dbn_y_tr,obs_te(:,t_ranked(1:fl)),dbn_y_te,fl);
                    acc_v2(j) = ErrorRate;
                    j = j + 1;
                    %end
                end
            end
            %% QDA
            if flag == 3, 
                nfs_arr = [0.05 0.1 0.2];
                % check the case when # of features less than 823
                if nfs_arr(1)*fs>=length(t_ranked),
                    feat_max = 1;
                elseif nfs_arr(2)*fs>=length(t_ranked),
                    feat_max = 2;
                else
                    feat_max = size(nfs_arr,2);
                end
                for j = 1:feat_max,
                    % if that is the case then treat it properly
                    if feat_max == 1,
                        nfs  = length(t_ranked);
                    else
                        nfs = nfs_arr(j)*fs;
                    end
                    fprintf('using %d features\n',nfs);
                    %% mse calculation of classification of each fold
                    [res,tpos{j},tneg{j},fpos{j},fneg{j},conf{j},acc{j},err{j},recall{j},precision{j},avg_acc(j),avg_err(j),...
                    macro_f1(j),macro_recall(j),macro_precision(j),micro_f1(j),micro_recall(j),micro_precision(j)] = ...
                    qda_classify_v2(obs_tr(:,t_ranked(1:nfs)),y_tr,obs_te(:,t_ranked(1:nfs)),y_te);
                    acc_v2(j) = res/c.TestSize(i);
                end
            end
            %% kNN
            if flag == 4, 
                nfs_arr = [0.05 0.1 0.2];
                % check the case when # of features less than 823
                if nfs_arr(1)*fs>=length(t_ranked),
                    feat_max = 1;
                elseif nfs_arr(2)*fs>=length(t_ranked),
                    feat_max = 2;
                else
                    feat_max = size(nfs_arr,2);
                end
                for j = 1:feat_max,
                    % if that is the case then treat it properly
                    if feat_max == 1,
                        nfs  = length(t_ranked);
                    else
                        nfs = nfs_arr(j)*fs;
                    end
                    fprintf('using %d features\n',nfs);
                    for nbr = 5:5:30,
                        %% mse calculation of classification of each fold
                        [res,tpos{j,nbr/5},tneg{j,nbr/5},fpos{j,nbr/5},fneg{j,nbr/5},conf{j,nbr/5},acc{j,nbr/5},...
                        err{j,nbr/5},recall{j,nbr/5},precision{j,nbr/5},avg_acc(j,nbr/5),avg_err(j,nbr/5),...
                        macro_f1(j,nbr/5),macro_recall(j,nbr/5),macro_precision(j,nbr/5),micro_f1(j,nbr/5),...
                        micro_recall(j,nbr/5),micro_precision(j,nbr/5)] = knn_classify(obs_tr(:,t_ranked(1:nfs)),y_tr,...
                        obs_te(:,t_ranked(1:nfs)),y_te,nbr); 
                        acc_v2(j,nbr/5) = res/c.TestSize(i);
                    end
                end
            end
            %% Results Section
            folds{i,18*(count_sel-1)+1} = acc_v2;
            folds{i,18*(count_sel-1)+2} = tpos;
            folds{i,18*(count_sel-1)+3} = tneg;
            folds{i,18*(count_sel-1)+4} = fpos;
            folds{i,18*(count_sel-1)+5} = fneg;
            folds{i,18*(count_sel-1)+6} = conf;
            folds{i,18*(count_sel-1)+7} = acc;
            folds{i,18*(count_sel-1)+8} = err;
            folds{i,18*(count_sel-1)+9} = recall;
            folds{i,18*(count_sel-1)+10} = precision;
            folds{i,18*(count_sel-1)+11} = avg_acc;
            folds{i,18*(count_sel-1)+12} = avg_err;
            folds{i,18*(count_sel-1)+13} = macro_f1;
            folds{i,18*(count_sel-1)+14} = macro_recall;
            folds{i,18*(count_sel-1)+15} = macro_precision;
            folds{i,18*(count_sel-1)+16} = micro_f1;
            folds{i,18*(count_sel-1)+17} = micro_recall;
            folds{i,18*(count_sel-1)+18} = micro_precision;
        end 
    end
end

%% Saving the results Section
newName1 = input('Give a new name to the results table: ','s');
S.(newName1) = folds;
if flag == 0,
    save('results_rfor','-struct','S',newName1);
elseif flag == 1,
    save('results_svm','-struct','S',newName1);
elseif flag == 2,
    save('results_dbn','-struct','S',newName1);
elseif flag == 3,
    save('results_qda','-struct','S',newName1);
else
    save('results_knn','-struct','S',newName1);
end
