function fe7 = hos_features (a)

    b = fieldnames(a);
    fe7 = zeros(15,62*60); % 5 freq bands -> 15 combinations * 4 features each
    for k =1:15,
        tr1 = a.(char(b(k)));

        stat = zeros(62,60);

        %% hos calculation for each electrode -- bispectrum && bicoherence
        for i=1:62,
            [bis,wx1] = bispecd(tr1(i,:),256,5,200,0);
            [bic,wx2] = bicoher(tr1(i,:),256,200,200,0);
            bands = [1 4 8 12 30 64];
            ind = 1;
            for ii = 1:5,
                [ind1,~] = find(round(wx1)>=bands(ii) & round(wx1)<=bands(ii+1));
                [ind3,~] = find(round(wx2)>=bands(ii) & round(wx2)<=bands(ii+1));
                for jj = ii:5,
                    [ind2,~] = find(round(wx1)>=bands(jj) & round(wx1)<=bands(jj+1));
                    [ind4,~] = find(round(wx2)>=bands(jj) & round(wx2)<=bands(jj+1));
                    stat(i,ind) = sum(sum(abs(bis(ind1,ind2)))); % bispectrum
                    stat(i,ind+1) = sum(sum((abs(bis(ind1,ind2))).^2));
                    stat(i,ind+2) = sum(sum(abs(bic(ind3,ind4)))); % bicoherence
                    stat(i,ind+3) = sum(sum((abs(bic(ind3,ind4))).^2));
                    ind = ind + 4;
                end
            end

        end
        fe7(k,:) = reshape(stat',[1,62*60]);
    end
 return