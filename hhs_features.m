function fe8 = hhs_features (a)

    b = fieldnames(a);
    fe8 = zeros(15,62*5); % 5 freq bands
    for k =1:15,
        tr1 = a.(char(b(k)));

        stat = zeros(62,5);
        Ts = 1/200;
        s = size(tr1,2);

        %% hhs calculation for each electrode 
        for i=1:62,
            imf = emd(tr1(i,:)); % imf calculation of the signal // array with all imfs of signal // new emd used
            z = zeros(size(imf,1)-1,s);
            amp_sq = zeros(size(imf,1)-1,s);
            freq = zeros(size(imf,1)-1,s-1);
            mf = zeros(size(imf,1)-1,1);
            ma = zeros(size(imf,1)-1,1);
            for kk = 1:size(imf,1)-1, % exclude the last residue
                z(kk,:) = hilbert(imf(kk,:)); % hilbert transform of each signal
                amp_sq(kk,:) = (abs(z(kk,:))).^2; % the squared amplitude of each imf 
                th = angle(z(kk,:));
                freq(kk,:) = diff(th)/(Ts*2*pi); % the meaningful instantaneous frequency of each signal
            end
            mf = mean(abs(freq),2); % mean instantenaous freq for each imf
            ma = mean(amp_sq,2); % mean sqr amp for each imf
            
            %% calculation for each freq band
            [ind,~] = find(round(mf) >= 1 & round(mf) <= 4); % delta
            stat(i,1) = sum(ma(ind,:));
            
            [ind,~] = find(round(mf) > 4 & round(mf) <= 8); % theta
            stat(i,2) = sum(ma(ind,:));
            
            [ind,~] = find(round(mf) > 8 & round(mf) <= 12); % alpha
            stat(i,3) = sum(ma(ind,:));
            
            [ind,~] = find(round(mf) > 12 & round(mf) <= 30); % beta
            stat(i,4) = sum(ma(ind,:));
            
            [ind,~] = find(round(mf) > 30 & round(mf) <= 64); % gamma
            stat(i,5) = sum(ma(ind,:));
        end

        fe8(k,:) = reshape(stat',[1,62*5]);
    end
 return