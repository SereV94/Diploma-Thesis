function ranked = cohen_f_squared(obs, labels)
   
    stds = std(obs); % std of every feature
    means = mean(obs); % mean of every feature
    
    %% means of every feature for every class
    m1 = mean(obs(labels==-1,:));
    m2 = mean(obs(labels==0,:));
    m3 = mean(obs(labels==1,:));
    
    %% calculation of cohen's f^2
    sm = ((m1 - means).^2 + (m2 - means).^2 + (m3 - means).^2)./3;
    f_sqr = sm./(stds.^2);
    [~,ranked] = sort(f_sqr,'descend');
    
 return