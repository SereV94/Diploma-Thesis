function fe9 = dwt_bior_features (a)

    bb = fieldnames(a);
    fe9 = zeros(15,62*3);
    
    for k =1:15,
        tr1 = a.(char(bb(k)));

        stat = zeros(62,3);

        %% dwt-bior3.3 calculation for each electrode    
        for i=1:62,
            [c,l] = wavedec(tr1(i,:),5,'bior3.3');

            %[d2,d3,d4,d5] = detcoef(c,l,[2,3,4,5]);
            %a5 = appcoef(c,l,'bior3.3',5);

            a5 = wrcoef('a',c,l,'bior3.3',5);
            d5 = wrcoef('d',c,l,'bior3.3',5);
            d4 = wrcoef('d',c,l,'bior3.3',4);

            stat(i,1) = bandpower(a5); % delta band ~= a5 app coef
            stat(i,2) = bandpower(d5); % theta band ~= d5 det coef
            stat(i,3) = bandpower(d4); % alpha band ~= d4 det coef
        end

        fe9(k,:) = reshape(stat',[1,62*3]);
    end
 return