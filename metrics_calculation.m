function [acc,err,recall,precision,avg_acc,avg_err,macro_f1,macro_recall,macro_precision,micro_f1,micro_recall,micro_precision] = metrics_calculation(tpos,tneg,fpos,fneg)
    recall = zeros(3,1);
    precision = zeros(3,1);
    acc = zeros(3,1);
    err = zeros(3,1);
    beta = 1;
    
    for i = 1:3,
        acc(i) = (tpos(i)+tneg(i))/(tpos(i)+tneg(i)+fpos(i)+fneg(i));
        err(i) = (fpos(i)+fneg(i))/(tpos(i)+tneg(i)+fpos(i)+fneg(i));
        recall(i) = tpos(i)/(tpos(i)+fneg(i));
        precision(i) = tpos(i)/(tpos(i)+fpos(i));
    end
    
    avg_acc = (sum(tpos) +sum(tneg))/(sum(tpos)+sum(tneg)+sum(fpos)+sum(fneg));
    avg_err = (sum(fpos)+sum(fneg))/(sum(tpos)+sum(tneg)+sum(fpos)+sum(fneg));
    micro_recall = sum(tpos)/(sum(tpos)+sum(fneg));
    micro_precision = sum(tpos)/(sum(tpos)+sum(fpos));
    micro_f1 = (beta^2+1)*micro_precision*micro_recall/(beta^2*micro_precision+micro_recall);
    macro_recall = sum(recall)/3;
    macro_precision = sum(precision)/3;
    macro_f1 = (beta^2+1)*macro_precision*macro_recall/(beta^2*macro_precision+macro_recall);
    
return