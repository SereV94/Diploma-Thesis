function [res,tpos,tneg,fpos,fneg,conf,acc,err,recall,precision,avg_acc,avg_err,macro_f1,macro_recall,...
    macro_precision,micro_f1,micro_recall,micro_precision] = svm_classify (Xtrain, Ytrain, Xtest, Ytest, cost, gamma)
    
    par = ['-s 0 -t 2 -c ',num2str(cost),' -g ', num2str(gamma)];
    addpath('C:\Users\Vasilis\Documents\libsvm-3.22\matlab\');
    mdl = svmtrain(Ytrain, Xtrain, par); % usage of libsvm functions - maybe Ytrain to be double
    predicted_labels = svmpredict(Ytest, Xtest, mdl); % maybe to put options here
    [tpos,tneg,fpos,fneg,conf] = feelings(Ytest, predicted_labels); % newly added
    [acc,err,recall,precision,avg_acc,avg_err,macro_f1,macro_recall,macro_precision,micro_f1,micro_recall,micro_precision]...
       = metrics_calculation(tpos,tneg,fpos,fneg);
    res = sum(~(Ytest==predicted_labels));
   
 return