function [res,tpos,tneg,fpos,fneg,conf,acc,err,recall,precision,avg_acc,avg_err,macro_f1,macro_recall,...
    macro_precision,micro_f1,micro_recall,micro_precision] = knn_classify (Xtrain, Ytrain, Xtest, Ytest, nbr)

   mdl = fitcknn(Xtrain,Ytrain,'NumNeighbors',nbr,'BreakTies','random','Distance','correlation'); % change in distance
   out = predict(mdl,Xtest);
   [tpos,tneg,fpos,fneg,conf] = feelings(Ytest, out); % newly added
   [acc,err,recall,precision,avg_acc,avg_err,macro_f1,macro_recall,macro_precision,micro_f1,micro_recall,micro_precision]...
       = metrics_calculation(tpos,tneg,fpos,fneg);
   res = sum(~(Ytest==out));
 return