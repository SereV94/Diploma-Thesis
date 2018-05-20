function fe10 = dwt_db_features (a)

    bb = fieldnames(a);
    fe10 = zeros(15,62*18);
    
    for k =1:15,
        tr1 = a.(char(bb(k)));

        stat = zeros(62,18);

        %% dwt-db4 calculation for each electrode    
        for i=1:62,
            [c,l] = wavedec(tr1(i,:),5,'db4');
            [det1,det2,det3,det4] = detcoef(c,l,[1,2,3,4]);

            d2 = wrcoef('d',c,l,'bior3.3',2);
            d3 = wrcoef('d',c,l,'bior3.3',3);
            d4 = wrcoef('d',c,l,'bior3.3',4);

            %% band calculations
            stat(i,1) = bandpower(d2); % gamma band ~= d2 det coef
            stat(i,2) = bandpower(d3); % beta band ~= d3 det coef
            stat(i,3) = bandpower(d4); % alpha band ~= d4 det coef

            %% entropy calculations -- Shannon's entropy is used

            stat(i,4) = wentropy(d2,'shannon'); 
            stat(i,5) = wentropy(d3,'shannon'); 
            stat(i,6) = wentropy(d4,'shannon'); 

            %% rms calculations 

            stat(i,16) = ((sum(det1.^2)+sum(det2.^2))/(size(det1,2)+size(det2,2))).^(1/2);
            stat(i,17) = ((sum(det1.^2)+sum(det2.^2)+sum(det3.^2))/(size(det1,2)+size(det2,2)+size(det3,2))).^(1/2);
            stat(i,18) = ((sum(det1.^2)+sum(det2.^2)+sum(det3.^2)+sum(det4.^2))/(size(det1,2)+size(det2,2)+size(det3,2)+size(det4,2))).^(1/2);

            %% ree calculations 
            e_tot = stat(i,1) + stat(i,2) + stat(i,3);
            stat(i,7) = stat(i,1)/e_tot; % ree for gamma band 
            stat(i,8) = stat(i,2)/e_tot; % ree for beta band
            stat(i,9) = stat(i,3)/e_tot; % ree for alpha band

            stat(i,10) = log(stat(i,7)); % log(ree) for gamma band 
            stat(i,11) = log(stat(i,8)); % log(ree) for beta band
            stat(i,12) = log(stat(i,9)); % log(ree) for alpha band

            stat(i,13) = abs(stat(i,10)); % abs(log(ree)) for gamma band 
            stat(i,14) = abs(stat(i,11)); % abs(log(ree)) for beta band
            stat(i,15) = abs(stat(i,12)); % abs(log(ree)) for alpha band
        end

        fe10(k,:) = reshape(stat',[1,62*18]);
    end
  return