clear;
subjects = dir('..\Preprocessed_EEG\*.mat');
subjects(10) = [];
in_path = cell(1,45);
for i = 1:45,
    in_path(i) = cellstr(strcat('..\Preprocessed_EEG\',subjects(i).name));
end
save('subjects_paths','in_path');
