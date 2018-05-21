function used_features = mostly_used(ranking, nfs)
   
    used_features = cell(11,2);
    used_features{1,1} = 'statistics';
    used_features{2,1} = 'hjorth';
    used_features{3,1} = 'nsi';
    used_features{4,1} = 'hoc';
    used_features{5,1} = 'stft';
    used_features{6,1} = 'hos';
    used_features{7,1} = 'hhs';
    used_features{8,1} = 'dwt_bior';
    used_features{9,1} = 'dwt_db4';
    used_features{10,1} = 'rat_ass';
    used_features{11,1} = 'diff_ass';
    for i = 1:11,
        used_features{i,2} = 0;
    end
    for i = 1:nfs,
        if ranking(i)<435,
            used_features{1,2} = used_features{1,2} + 1;
        elseif ranking(i)<559,
            used_features{2,2} = used_features{2,2} + 1;  
        elseif ranking(i)<621,
            used_features{3,2} = used_features{3,2} + 1; 
        elseif ranking(i)<1241,
            used_features{4,2} = used_features{4,2} + 1; 
        elseif ranking(i)<10479,
            used_features{5,2} = used_features{5,2} + 1; 
        elseif ranking(i)<14199,
            used_features{6,2} = used_features{6,2} + 1; 
        elseif ranking(i)<14509,
            used_features{7,2} = used_features{7,2} + 1; 
        elseif ranking(i)<14695,
            used_features{8,2} = used_features{8,2} + 1; 
        elseif ranking(i)<15811,
            used_features{9,2} = used_features{9,2} + 1; 
        elseif ranking(i)<16111,
            used_features{10,2} = used_features{10,2} + 1; 
        else
            used_features{11,2} = used_features{11,2} + 1; 
        end
            
    end

 return