function fe5 = hoc_features (a)

    bb = fieldnames(a);
    fe5 = zeros(15,62*10);
    
    for k =1:15,
        tr1 = a.(char(bb(k)));

        %% zero-mean normalization of the signal
        for i=1:62,
            tr1(i,:) = tr1(i,:)-mean(tr1(i,:));
        end

        %% stat matrix with 10 cols for kk=1:10
        stat = zeros(62,10);

        for i = 1:62,
        %% hoc-features implementation according to hadjileontiadis paper
            for kk = 1:10,
                if kk-1==0,
                    temp = tr1(i,:);
                end
                if kk-1>0,
                    temp = diff(tr1(i,:),kk-1);
                end
                temp(temp>=0) = 1;
                temp(temp<0) = 0;
                stat(i,kk) = sum((diff(temp)).^2);
            end
        end

        fe5(k,:) = reshape(stat',[1,62*10]);
    end
 return