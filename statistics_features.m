function fe1 = statistics_features (a)

    b = fieldnames(a);
    fe1 = zeros(15,62*7);
    
    for k =1:15,
        tr1 = a.(char(b(k)));
        stat = zeros(62,7);
        %% power calculation per electrode
        stat(:,1) = sum(tr1.^2,2)/size(tr1,2);

        %% mean value calculation per electrode
        stat(:,2) = mean(tr1,2);

        for i = 1:62,
            %% std calculation
            stat(i,3) = (sum((tr1(i,:)-stat(i,2)).^2)/size(tr1,2)).^(0.5);

            %% 1st diff calculation
            stat(i,4) = sum(abs(diff(tr1(i,:))))/(size(tr1,2)-1);

            %% normalized 1st diff
            stat(i,5) = stat(i,4)/stat(i,3);

            %% 2nd diff calculation
            stat(i,6) = sum(abs(tr1(i,3:size(tr1,2))-tr1(i,1:size(tr1,2)-2)))/(size(tr1,2)-2);

            %% normalized 2nd diff
            stat(i,7) = stat(i,6)/stat(i,3);
        end
        fe1(k,:) = reshape(stat',[1,62*7]);
    end
 return
