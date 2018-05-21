function [ErrorRate,tpos,tneg,fpos,fneg,conf,acc,err,recall,precision,avg_acc,avg_err,macro_f1,macro_recall,...
    macro_precision,micro_f1,micro_recall,micro_precision] = dbn_classify_v2 (Xtrain, Ytrain, Xtest, Ytest, fl)
    
    addpath('C:\Users\Vasilis\Documents\DBN_v2\');

	nodes = [fl 3]; 
	bbdbn = randDBN( nodes, 'BBDBN' );
	nrbm = numel(bbdbn.rbm);

	opts.MaxIter = 300;  % 1000 before
	opts.BatchSize = 100;
	opts.Verbose = true;
	opts.StepRatio = 0.1;
	opts.object = 'CrossEntropy';

	opts.LayerNum = nrbm-1; % it was Layer before
	bbdbn = pretrainDBN(bbdbn, Xtrain, opts);
	bbdbn= SetLinearMapping(bbdbn, Xtrain, Ytrain);

	opts.Layer = 0;
    opts.MaxIter = 50; % not existed before
    %opts.StepRatio = 0.6; % not existed before
	bbdbn = trainDBN(bbdbn, Xtrain, Ytrain, opts);
	
	%rmse= CalcRmse(bbdbn, Xtrain, Ytrain);
	[ErrorRate1,~]= CalcErrorRate(bbdbn, Xtrain, Ytrain);
	fprintf( 'For training data:\n' );
	%fprintf( 'rmse: %g\n', rmse );
	fprintf( 'ErrorRate: %g\n', ErrorRate1 );

	%rmse= CalcRmse(bbdbn, Xtest, Ytest);
	[ErrorRate,out]= CalcErrorRate(bbdbn, Xtest, Ytest);
	fprintf( 'For test data:\n' );
	%fprintf( 'rmse: %g\n', rmse );
	fprintf( 'ErrorRate: %g\n', ErrorRate );
    
    % proper change to the out-table in order to fit the feelings.m format
    dbn_out = zeros(size(out,1),1);
    dbn_te = zeros(size(Ytest,1),1);
    for i=1:size(out,1),
        if out(i,1) == 1,
            dbn_out(i) = -1;
        elseif out(i,2) == 1,
            dbn_out(i) = 0;
        else
            dbn_out(i) = 1;
        end
        
        if Ytest(i,1) == 1,
            dbn_te(i) = -1;
        elseif Ytest(i,2) == 1,
            dbn_te(i) = 0;
        else
            dbn_te(i) = 1;
        end
    end
    
    [tpos,tneg,fpos,fneg,conf] = feelings(dbn_te, dbn_out); % newly added
    [acc,err,recall,precision,avg_acc,avg_err,macro_f1,macro_recall,macro_precision,micro_f1,micro_recall,micro_precision]...
       = metrics_calculation(tpos,tneg,fpos,fneg);

return