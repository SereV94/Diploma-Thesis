function fe6 = stft_features (a)

    b = fieldnames(a);
    fe6 = zeros(15,62*(6*4+31*4+1)); % 4 features for 6 bands && 4 features for 31 bins && ratio b/a
    
    for k =1:15,
        tr1 = a.(char(b(k)));

        %% initialization of parameters
        y = round(size(tr1,2)/200); 

        stat = zeros(62,6*4+31*4+1);
        p_delta = zeros(1,y);
        p_theta = zeros(1,y);
        p_low_alpha = zeros(1,y);
        p_alpha = zeros(1,y);
        p_beta = zeros(1,y);
        p_gamma = zeros(1,y);
        p_bins = zeros(1,y);

        %% stft calculation for each electrode    
        for i=1:62,
            [s,f,t,psd] = spectrogram(tr1(i,:),hamming(200),0,256,200);
            
            p_delta(1,:) = bandpower(psd,f,[1,4],'psd');
            stat(i,1) = mean(p_delta);
            stat(i,2) = max(p_delta);
            stat(i,3) = min(p_delta);
            stat(i,4) = var(p_delta);
            
            p_theta(1,:) = bandpower(psd,f,[4,8],'psd');
            stat(i,5) = mean(p_theta);
            stat(i,6) = max(p_theta);
            stat(i,7) = min(p_theta);
            stat(i,8) = var(p_theta);
            
            p_low_alpha(1,:) = bandpower(psd,f,[8,10],'psd');
            stat(i,9) = mean(p_low_alpha);
            stat(i,10) = max(p_low_alpha);
            stat(i,11) = min(p_low_alpha);
            stat(i,12) = var(p_low_alpha);
            
            p_alpha(1,:) = bandpower(psd,f,[8,12],'psd');
            stat(i,13) = mean(p_alpha);
            stat(i,14) = max(p_alpha);
            stat(i,15) = min(p_alpha);
            stat(i,16) = var(p_alpha);
            
            p_beta(1,:) = bandpower(psd,f,[12,30],'psd');
            stat(i,17) = mean(p_beta);
            stat(i,18) = max(p_beta);
            stat(i,19) = min(p_beta);
            stat(i,20) = var(p_beta);
            
            p_gamma(1,:) = bandpower(psd,f,[30,64],'psd');
            stat(i,21) = mean(p_gamma);
            stat(i,22) = max(p_gamma);
            stat(i,23) = min(p_gamma);
            stat(i,24) = var(p_gamma);
            
            stat(i,25) = stat(i,17)/stat(i,13);
            
            ind = 1;
            for j = 1:2:62,
                p_bins(1,:) = bandpower(psd,f,[j,j+2],'psd');
                stat(i,25+ind) = mean(p_bins);
                stat(i,25+ind+1) = max(p_bins);
                stat(i,25+ind+2) = min(p_bins);
                stat(i,25+ind+3) = var(p_bins);
                ind = ind + 4;    
            end
        end

        fe6(k,:) = reshape(stat',[1,62*(6*4+31*4+1)]);
    end
 return