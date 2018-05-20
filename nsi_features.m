function fe3 = nsi_features (a)

    b = fieldnames(a);
    fe3 = zeros(15,62);
    
    for k =1:15,
        tr1 = a.(char(b(k)));

        %% normalization of the signal
        for i=1:62,
            tr1(i,:) = (tr1(i,:)-mean(tr1(i,:)))/std(tr1(i,:));
        end

        %% main calculation
        stat = zeros(62,1);
        s = size(tr1,2);

        num = round(s/200); % chunks of the signal - 1s each

        for i = 1:62,
            gen_mean = zeros(1,num);
            s_ind = 1;
            e_ind = 200;
            for j = 1:num,
               if j==num,
                   e_ind = s;
               end
               gen_mean(1,j) = mean(tr1(i,s_ind:e_ind)); % mean of each chunk
               s_ind = s_ind + 200;
               e_ind = e_ind + 200;
            end
            stat(i,1) = std(gen_mean); %std of the means
        end

        fe3(k,:) = reshape(stat',[1,62]);
    end
 return