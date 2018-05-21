function [res,tpos,tneg,fpos,fneg,conf,acc,err,recall,precision,avg_acc,avg_err,macro_f1,macro_recall,...
    macro_precision,micro_f1,micro_recall,micro_precision] = rfor_classify (Xtrain, Ytrain, Xtest, Ytest, trees)

   mdl = TreeBagger(trees,Xtrain,Ytrain);
   out = predict(mdl,Xtest);
   temp = cellfun(@str2num,out);
   [tpos,tneg,fpos,fneg,conf] = feelings(Ytest, temp); % newly added
   [acc,err,recall,precision,avg_acc,avg_err,macro_f1,macro_recall,macro_precision,micro_f1,micro_recall,micro_precision]...
       = metrics_calculation(tpos,tneg,fpos,fneg);
   res = sum(~(Ytest==temp));
 return