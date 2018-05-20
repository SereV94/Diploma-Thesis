function fe2 = hjorth_features (a)

    b = fieldnames(a);
    fe2 = zeros(15,62*2);
    
    for k =1:15,
        tr1 = a.(char(b(k)));
        stat = zeros(62,2);
        for i = 1:62,
            %% mobility calculation
            stat(i,1) = (var(diff(tr1(i,:))/0.005)/var(tr1(i,:))).^0.5; % Ts =0.005 -> dt

            %% complexity calculation 
            temp = (var(diff((diff(tr1(i,:))/0.005))/0.005)/var(diff(tr1(i,:))/0.005)).^0.5;
            stat(i,2) = temp/stat(i,1);
        end
        fe2(k,:) = reshape(stat',[1,62*2]);
    end
 return