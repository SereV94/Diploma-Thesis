function [ranked_q,ranked_d]  = mrmr_calculation(obs, labels, K)
   
    edges = [-26:4:-5 -5:1:-3 -2:0.2:-1.2 -1:0.05:1 1.2:0.2:2 3:1:5 6:4:26];
    y = discretize(obs, edges); % data discretized at 20 states
    y = y - 34;
    mrmr_labels = zeros(size(labels,1),1);
    for i=1:size(labels,1),
        mrmr_labels(i) = labels(i)+2;
    end
    addpath('C:\Users\Vasilis\Documents\SEED\MyExtracted\mi');
    [ranked_q] = mrmr_miq_d(y, mrmr_labels, K); % labels need to be categorical 
    [ranked_d] = mrmr_mid_d(y, mrmr_labels, K); 
    
 return