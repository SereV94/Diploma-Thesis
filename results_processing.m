clear;

%% Find the most frequently used features -- Section 

fprintf('entering mfuf section\n');

fprintf('reliefF section\n');
for neighbors=5:5:30,
    load(['reliefF_features_',num2str(neighbors)]);
    r_used_features_823 = mostly_used(ranked_relieff,823);
    r_used_features_1646 = mostly_used(ranked_relieff,1646);
    r_used_features_3292 = mostly_used(ranked_relieff,3292);
    save(['reliefF_mostly_used_',num2str(neighbors)],'r_used_features_823','r_used_features_1646','r_used_features_3292');
    clear ranked_relieff;
end

fprintf('cohen section\n');
load('cohen_features');
c_used_features_823 = mostly_used(ranked_cohen,823);
c_used_features_1646 = mostly_used(ranked_cohen,1646);
c_used_features_3292 = mostly_used(ranked_cohen,3292);
save('cohen_mostly_used','c_used_features_823','c_used_features_1646','c_used_features_3292');

fprintf('mrmr section\n');
load('mrmr_features_823');
mrmr_q_used_features_823 = mostly_used(ranked_q_mrmr,823);
mrmr_d_used_features_823 = mostly_used(ranked_d_mrmr,823);
save('mrmr_mostly_used','mrmr_q_used_features_823','mrmr_d_used_features_823');

fprintf('fcbf section\n');
count = 1;
for delta=0.005:0.005:0.03,
    load(['fcbf_features_',num2str(count)]);
    fcbf_used_features = mostly_used(ranked_fcbf,length(ranked_fcbf));
    save(['fcbf_mostly_used_',num2str(count)],'fcbf_used_features');
    clear ranked_fcbf;
    count = count + 1;
end

fprintf('infFS section\n');
temp = 1;
count = 1;
for a = 0.1:0.1:1,
    for init = 1:9,
        load(['infFS_features_',num2str(count),'_',num2str(init)]);
        infFS_used_features_823 = mostly_used(ranked_infFS,823);
        if init<7 || init>8,
            infFS_used_features_1646 = mostly_used(ranked_infFS,1646);
        end
        if init<7 || init>8,
            save(['infFS_mostly_used_',num2str(count),'_',num2str(temp)],'infFS_used_features_823','infFS_used_features_1646');
        else
            save(['infFS_mostly_used_',num2str(count),'_',num2str(temp)],'infFS_used_features_823');
        end
        clear ranked_infFS;
        temp = temp + 1;
    end
    count = count + 1;
end

%% Find best avg results -- Section

fprintf('entering fbar section\n');

%% Random forest Section

fprintf('rfor section\n');
load('results_rfor_last');

inds = cell(9,105); % 105 fs-parametric cases and 9 metrics to be checked
best_res = zeros(9,105);
m_rfor = cell(9,105);
for j = 1:18:1890,
    C = cell(9);
    for i=1:9,
        C{1,i} = folds{i,j}; 
        C{2,i} = folds{i,j+10}; 
        C{3,i} = folds{i,j+11}; 
        C{4,i} = folds{i,j+12}; 
        C{5,i} = folds{i,j+13}; 
        C{6,i} = folds{i,j+14}; 
        C{7,i} = folds{i,j+15}; 
        C{8,i} = folds{i,j+16}; 
        C{9,i} = folds{i,j+17}; 
    end
    for k = 1:9,
        D = cat(3, C{k,:});
        m_rfor{k,ceil(j/18)} = mean(D,3);
        if k==1 || k==3,
            [~,xs] = min(m_rfor{k,ceil(j/18)});
            [best_res(k,ceil(j/18)),y] = min(min(m_rfor{k,ceil(j/18)}));
            inds{k,ceil(j/18)} = [xs(y) y];
        else
            [~,xs] = max(m_rfor{k,ceil(j/18)});
            [best_res(k,ceil(j/18)),y] = max(max(m_rfor{k,ceil(j/18)}));
            inds{k,ceil(j/18)} = [xs(y) y];
        end
    end
end

save('final_results_rfor', 'inds', 'best_res', 'm_rfor');
clear results_rfor_last;

%% kNN Section

fprintf('knn section\n');
load('results_knn_last');

inds = cell(9,105); % 105 fs-parametric cases and 9 metrics to be checked
best_res = zeros(9,105);
m_knn = cell(9,105);
for j = 1:18:1890,
    C = cell(9);
    for i=1:9,
        C{1,i} = folds{i,j}; 
        C{2,i} = folds{i,j+10}; 
        C{3,i} = folds{i,j+11}; 
        C{4,i} = folds{i,j+12}; 
        C{5,i} = folds{i,j+13}; 
        C{6,i} = folds{i,j+14}; 
        C{7,i} = folds{i,j+15}; 
        C{8,i} = folds{i,j+16}; 
        C{9,i} = folds{i,j+17}; 
    end
    for k = 1:9,
        D = cat(3, C{k,:});
        m_knn{k,ceil(j/18)} = mean(D,3);
        if k==1 || k==3,
            [~,xs] = min(m_knn{k,ceil(j/18)});
            [best_res(k,ceil(j/18)),y] = min(min(m_knn{k,ceil(j/18)}));
            inds{k,ceil(j/18)} = [xs(y) y];
        else
            [~,xs] = max(m_knn{k,ceil(j/18)});
            [best_res(k,ceil(j/18)),y] = max(max(m_knn{k,ceil(j/18)}));
            inds{k,ceil(j/18)} = [xs(y) y];
        end
    end
end

save('final_results_knn', 'inds', 'best_res', 'm_knn');
clear results_knn_last;

%% QDA Section

fprintf('qda section\n');
load('results_qda_last');

inds = cell(9,105); % 105 fs-parametric cases
best_res = zeros(9,105);
m_qda = cell(9,105);
for j = 1:18:1890,
    C = cell(9);
    for i=1:9,
        C{1,i} = folds{i,j}; 
        C{2,i} = folds{i,j+10}; 
        C{3,i} = folds{i,j+11}; 
        C{4,i} = folds{i,j+12}; 
        C{5,i} = folds{i,j+13}; 
        C{6,i} = folds{i,j+14}; 
        C{7,i} = folds{i,j+15}; 
        C{8,i} = folds{i,j+16}; 
        C{9,i} = folds{i,j+17}; 
    end
    for k = 1:9,
        D = cat(3, C{k,:});
        m_qda{k,ceil(j/18)} = mean(D,3);
        if k==1 || k==3,
            [~,xs] = min(m_qda{k,ceil(j/18)});
            [best_res(k,ceil(j/18)),y] = min(min(m_qda{k,ceil(j/18)}));
            inds{k,ceil(j/18)} = [xs(y) y];
        else
            [~,xs] = max(m_qda{k,ceil(j/18)});
            [best_res(k,ceil(j/18)),y] = max(max(m_qda{k,ceil(j/18)}));
            inds{k,ceil(j/18)} = [xs(y) y];
        end
    end
end

save('final_results_qda', 'inds', 'best_res', 'm_qda');
clear results_qda_last;

%% DBN Section

fprintf('dbn section\n');
load('results_dbn');

inds = cell(9,105); % 105 fs-parametric cases
best_res = zeros(9,105);
m_dbn = cell(9,105);
for j = 1:18:1890,
    C = cell(9);
    for i=1:9,
        C{1,i} = folds{i,j}; 
        C{2,i} = folds{i,j+10}; 
        C{3,i} = folds{i,j+11}; 
        C{4,i} = folds{i,j+12}; 
        C{5,i} = folds{i,j+13}; 
        C{6,i} = folds{i,j+14}; 
        C{7,i} = folds{i,j+15}; 
        C{8,i} = folds{i,j+16}; 
        C{9,i} = folds{i,j+17}; 
    end
    for k = 1:9,
        D = cat(3, C{k,:});
        m_dbn{k,ceil(j/18)} = mean(D,3);
        if k==1 || k==3,
            [~,xs] = min(m_dbn{k,ceil(j/18)});
            [best_res(k,ceil(j/18)),y] = min(min(m_dbn{k,ceil(j/18)}));
            inds{k,ceil(j/18)} = [xs(y) y];
        else
            [~,xs] = max(m_dbn{k,ceil(j/18)});
            [best_res(k,ceil(j/18)),y] = max(max(m_dbn{k,ceil(j/18)}));
            inds{k,ceil(j/18)} = [xs(y) y];
        end
    end
end

save('final_results_dbn', 'inds', 'best_res', 'm_dbn');
clear results_dbn;

%% SVM Section

fprintf('svm section\n');
load('results_svm_last');

inds = cell(9,105,3); % 105 fs-parametric cases plus dim-3 for # of features used 
best_res = zeros(9,105,3);
m_svm = cell(9,105,3);
for j = 1:18:1890,
    C = cell(9);
    for i=1:9,
        C{1,i} = folds{i,j}; 
        C{2,i} = folds{i,j+10}; 
        C{3,i} = folds{i,j+11}; 
        C{4,i} = folds{i,j+12}; 
        C{5,i} = folds{i,j+13}; 
        C{6,i} = folds{i,j+14}; 
        C{7,i} = folds{i,j+15}; 
        C{8,i} = folds{i,j+16}; 
        C{9,i} = folds{i,j+17}; 
    end
    for k = 1:9,
        c_temp = cell(1,9);
        for m = 1:size(folds{1,j},3),
            for ttt = 1:9,
                c_temp{1,ttt} = C{k,ttt}(:,:,m);
            end
            D = cat(3,c_temp{1,:});
            m_svm{k,ceil(j/18),m} = mean(D,3);
            if k==1 || k==3,
                [~,xs] = min(m_svm{k,ceil(j/18),m});
                [best_res(k,ceil(j/18),m),y] = min(min(m_svm{k,ceil(j/18),m}));
                inds{k,ceil(j/18),m} = [xs(y) y];
            else
                [~,xs] = max(m_svm{k,ceil(j/18),m});
                [best_res(k,ceil(j/18),m),y] = max(max(m_svm{k,ceil(j/18),m}));
                inds{k,ceil(j/18),m} = [xs(y) y];
            end
        end
    end
end

save('final_results_svm', 'inds', 'best_res', 'm_svm');
clear results_svm_last; 