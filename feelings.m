function [tpos,tneg,fpos,fneg,conf] = feelings(ytest, predicted)
   
    tpos = zeros(3,1);
    fpos = zeros(3,1);
    fneg = zeros(3,1);
    tneg = zeros(3,1);
    conf = zeros(3,3);

    for i = 1:size(ytest,1),
        conf(ytest(i)+2,predicted(i)+2) = conf(ytest(i)+2,predicted(i)+2) + 1;
    end
    
    for i=1:3,
        tpos(i) = conf(i,i);
        fpos(i) = sum(conf(:,i))-conf(i,i);
        fneg(i) = sum(conf(i,:))-conf(i,i);
        tneg(i) = size(ytest,1)-tpos(i)-fpos(i)-fneg(i);
    end
    
 return