function [res,tpos,tneg,fpos,fneg,conf,acc,err,recall,precision,avg_acc,avg_err,macro_f1,macro_recall,...
    macro_precision,micro_f1,micro_recall,micro_precision] = qda_classify_v2 (Xtrain, Ytrain, Xtest, Ytest)

   mdl = fitcdiscr(Xtrain,Ytrain,'DiscrimType','diagquadratic'); % ~~ 'OptimizeHyperparameters','auto' out not running
   out = predict(mdl,Xtest);
   [tpos,tneg,fpos,fneg,conf] = feelings(Ytest, out); % newly added
   [acc,err,recall,precision,avg_acc,avg_err,macro_f1,macro_recall,macro_precision,micro_f1,micro_recall,micro_precision]...
       = metrics_calculation(tpos,tneg,fpos,fneg);
   res = sum(~(out==Ytest));
   
 return