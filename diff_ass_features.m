function fe12 = diff_ass_features (fe1)

    b = load('elect_order.mat');
    lr = b.('asm_ind'); % left-right indexes
    fp = b.('dcau_ind'); % front-post indexes
    fe12 = zeros(15,(size(lr,1)+size(fp,1))*7);

    for k =1:15,

        %% differential assymetry characteristics --statistics and fractal dimension used--
        st = reshape(fe1(k,:),[7,62])';

        stat = zeros(size(lr,1)+size(fp,1),7); % 27 l-r electrodes + 23 f-p electrodes according to dataset

        %% l-r calculation
        for i = 1:size(lr,1),
            stat(i,1) = st(lr(i,1),1)-st(lr(i,2),1);
            stat(i,2) = st(lr(i,1),2)-st(lr(i,2),2);
            stat(i,3) = st(lr(i,1),3)-st(lr(i,2),3);
            stat(i,4) = st(lr(i,1),4)-st(lr(i,2),4);
            stat(i,5) = st(lr(i,1),5)-st(lr(i,2),5);
            stat(i,6) = st(lr(i,1),6)-st(lr(i,2),6);
            stat(i,7) = st(lr(i,1),7)-st(lr(i,2),7);
        end

        %% f-p calculation
        for i = 1:size(fp,1),
            stat(size(lr,1)+i,1) = st(fp(i,1),1)-st(fp(i,2),1);
            stat(size(lr,1)+i,2) = st(fp(i,1),2)-st(fp(i,2),2);
            stat(size(lr,1)+i,3) = st(fp(i,1),3)-st(fp(i,2),3);
            stat(size(lr,1)+i,4) = st(fp(i,1),4)-st(fp(i,2),4);
            stat(size(lr,1)+i,5) = st(fp(i,1),5)-st(fp(i,2),5);
            stat(size(lr,1)+i,6) = st(fp(i,1),6)-st(fp(i,2),6);
            stat(size(lr,1)+i,7) = st(fp(i,1),7)-st(fp(i,2),7);
        end

        fe12(k,:) = reshape(stat',[1,(size(lr,1)+size(fp,1))*7]);
    end
 return