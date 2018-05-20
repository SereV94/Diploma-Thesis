clear;
load('subjects_paths');
ftr_arr = [];
for i = 1:length(in_path),
    
    fprintf('starting for subject %d\n',i);
    path = char(in_path{i});
    fprintf('Name of subject: %s\n',path);
    a = load(path);
    
    %% time domain features calculation
    fe1 = statistics_features(a);
    disp('stat-completed');
    fe2 = hjorth_features(a);
    disp('hjorth-completed');
    fe3 = nsi_features(a);
    disp('nsi-completed');
    fe5 = hoc_features(a);
    disp('hoc-completed');
    disp('time features completed');
    
    %% freq domain features calculation
    fe6 = stft_features(a);
    disp('stft-completed');
    fe7 = hos_features(a);
    disp('hos-completed');
    disp('freq features completed');
    
    %% time-freq domain features calculation
    fe8 = hhs_features(a);
    disp('hhs-completed');
    fe9 = dwt_bior_features(a);
    disp('bior-completed');
    fe10 = dwt_db_features(a);
    disp('db-completed');
    disp('time-freq features completed');
    
    %% electr combinations features calculation
    fe11 = rat_ass_features(fe6);
    disp('rat-completed');
    fe12 = diff_ass_features(fe1);
    disp('diff-completed');
    disp('electr combinations features completed');
    
    temp = [fe1 fe2 fe3 fe5 fe6 fe7 fe8 fe9 fe10 fe11 fe12];
    ftr_arr = [ftr_arr ; temp];  % maybe to change
end
save('feature_arr','ftr_arr');