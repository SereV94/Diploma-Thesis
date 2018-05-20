function fe11 = rat_ass_features (fe6)

    b = load('elect_order.mat');
    lr = b.('asm_ind'); % left-right indexes
    fp = b.('dcau_ind'); % front-post indexes
    fe11 = zeros(15,(size(lr,1)+size(fp,1))*6);

    for k =1:15,

        %% rational assymetry characteristics --stft band power used--
        st = reshape(fe6(k,:),[6*4+31*4+1,62])';
        tp = st(:,1);
        td = st(:,5);
        ta = st(:,13);
        tla = st(:,9);
        tb = st(:,17);
        tg = st(:,21);

        stat = zeros(size(lr,1)+size(fp,1),6); % (27 l-r electrodes + 23 f-p electrodes)* 6 freq bands

        %% l-r calculation
        for i = 1:size(lr,1),
            stat(i,1) = tp(lr(i,1),1)/tp(lr(i,2),1);
            stat(i,2) = td(lr(i,1),1)/td(lr(i,2),1);
            stat(i,3) = tla(lr(i,1),1)/tla(lr(i,2),1);
            stat(i,4) = ta(lr(i,1),1)/ta(lr(i,2),1);
            stat(i,5) = tb(lr(i,1),1)/tb(lr(i,2),1);
            stat(i,6) = tg(lr(i,1),1)/tg(lr(i,2),1);
        end

        %% f-p calculation
        for i = 1:size(fp,1),
            stat(size(lr,1)+i,1) = tp(fp(i,1),1)/tp(fp(i,2),1);
            stat(size(lr,1)+i,2) = td(fp(i,1),1)/td(fp(i,2),1);
            stat(size(lr,1)+i,3) = tla(fp(i,1),1)/tla(fp(i,2),1);
            stat(size(lr,1)+i,4) = ta(fp(i,1),1)/ta(fp(i,2),1);
            stat(size(lr,1)+i,5) = tb(fp(i,1),1)/tb(fp(i,2),1);
            stat(size(lr,1)+i,6) = tg(fp(i,1),1)/tg(fp(i,2),1);
        end

        fe11(k,:) = reshape(stat',[1,(size(lr,1)+size(fp,1))*6]);
    end
return