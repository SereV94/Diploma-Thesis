clear;
[num,text,raw] = xlsread('../ChannelOrder.xlsx');
left_el = {'FP1';'F7';'F3';'FT7';'FC3';'T7';'P7';'C3';'TP7';'CP3';'P3';'O1';'AF3';'F5';'F7';'FC5';'FC1';'C5';'C1';'CP5';'CP1';'P5';'P1';'PO7';'PO5';'PO3';'CB1'};
right_el = {'FP2';'F8';'F4';'FT8';'FC4';'T8';'P8';'C4';'TP8';'CP4';'P4';'O2';'AF4';'F6';'F8';'FC6';'FC2';'C6';'C2';'CP6';'CP2';'P6';'P2';'PO8';'PO6';'PO4';'CB2'};
asm_ind = zeros(27,2);
for i = 1:27,
    asm_ind(i,1) = find(strcmp(text,left_el{i}));
    asm_ind(i,2) = find(strcmp(text,right_el{i}));
end
front_el = {'FT7';'FC5';'FC3';'FC1';'FCZ';'FC2';'FC4';'FC6';'FT8';'F7';'F5';'F3';'F1';'FZ';'F2';'F4';'F6';'F8';'FP1';'FP2';'FPZ';'AF3';'AF4'};
post_el = {'TP7';'CP5';'CP3';'CP1';'CPZ';'CP2';'CP4';'CP6';'TP8';'P7';'P5';'P3';'P1';'PZ';'P2';'P4';'P6';'P8';'O1';'O2';'OZ';'CB1';'CB2'};
dcau_ind = zeros(23,2);
for i = 1:23,
    dcau_ind(i,1) = find(strcmp(text,front_el{i}));
    dcau_ind(i,2) = find(strcmp(text,post_el{i}));
end

save('C:\Users\Vasilis\Documents\SEED\MyExtracted\elect_order.mat');