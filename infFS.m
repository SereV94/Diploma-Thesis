function [RANKED, WEIGHT] = infFS( X_train, Y_train, alpha, supervision, verbose )
% [RANKED, WEIGHT ] = infFS( X_train, Y_train, verbose ) computes ranks and weights
% of features for input data matrix X_train and labels Y_train using Inf-FS algorithm.
%
% Version 4.0, August 2016.
%
% INPUT:
%
% X_train is a T by n matrix, where T is the number of samples and n the number
% of features.
% Y_train is column vector with class labels (e.g., -1, 1)
% Verbose, boolean variable [0, 1]
%
% OUTPUT:
%
% RANKED are indices of columns in X_train ordered by attribute importance,
% meaning RANKED(1) is the index of the most important/relevant feature.
% WEIGHT are attribute weights with large positive weights assigned
% to important attributes.
%
%  Note, If you use our code or method, please cite our paper:
%  BibTex
%  ------------------------------------------------------------------------
% @InProceedings{RoffoICCV15,
% author={G. Roffo and S. Melzi and M. Cristani},
% booktitle={2015 IEEE International Conference on Computer Vision (ICCV)},
% title={Infinite Feature Selection},
% year={2015},
% pages={4202-4210},
% keywords={feature extraction;image classification;image filtering;matrix algebra;object recognition;Inf-FS;classification setting;feature learning strategy;filter-based feature selection;infinite feature selection;matrices;object recognition;Benchmark testing;Convergence;Feature extraction;Joining processes;Object recognition;Redundancy;Standards},
% doi={10.1109/ICCV.2015.478},
% month={Dec}}
%  ------------------------------------------------------------------------
fprintf('\n+ Feature selection method: inf-FS 2016\n');

if (nargin<3)
    verbose = 0;
end


%% The Inf-FS method

%% 1) Standard Deviation over the samples
if (verbose)
    fprintf('1) Priors/weights estimation \n');
end
if supervision
    s_n = X_train(Y_train==-1,:);
    s_p = X_train(Y_train==1,:);
    mu_s_n = mean(s_n);
    mu_s_p = mean(s_p);
    priors_corr = ([mu_s_p - mu_s_n].^2);
    st   = std(s_p).^2;
    st   = st+std(s_n).^2;
    st(find(st==0))=10000;  % remove ones where nothing occurs
    corr_ij = priors_corr ./ st;
    corr_ij = [corr_ij'*corr_ij];
    corr_ij = corr_ij - min(min( corr_ij ));
    corr_ij = corr_ij./max(max( corr_ij )); % values in [0,1]
else
    [ corr_ij, ~ ] = corr( X_train, 'type','Spearman' );
    corr_ij(isnan(corr_ij)) = 0; % remove NaN
    corr_ij(isinf(corr_ij)) = 0; % remove inf
end
% Standard Deviation Est.
STD = std(X_train,[],1);
STDMatrix = bsxfun( @max, STD, STD' );
STDMatrix = STDMatrix - min(min( STDMatrix ));
sigma_ij = STDMatrix./max(max( STDMatrix ));
sigma_ij(isnan(sigma_ij)) = 0; % remove NaN
sigma_ij(isinf(sigma_ij)) = 0; % remove inf

%% 2) Building the graph G = <V,E>
if (verbose)
    fprintf('2) Building the graph G = <V,E> \n');
end
A =  ( alpha*corr_ij + (1-alpha)*sigma_ij );


%% 3) Letting paths tend to infinite: Inf-FS Core
if (verbose)
    fprintf('3) Letting paths tend to infinite \n');
end
I = eye( size( A ,1 )); % Identity Matrix

r = (0.9/max(eig( A ))); % Set a meaningful value for r

y = I - ( r * A );

S = inv( y ) - I; % see Gelfand's formula - convergence of the geometric series of matrices

%% 4) Estimating energy scores
if (verbose)
    fprintf('4) Estimating energy scores \n');
end
WEIGHT = sum( S , 2 ); % energy scores s(i)

%% 5) Ranking features according to s
if (verbose)
    fprintf('5) Features ranking  \n');
end
[~ , RANKED ]= sort( WEIGHT , 'descend' );

RANKED = RANKED';
WEIGHT = WEIGHT';


end

%  =========================================================================
%   More details:
%   Reference   : Infinite Feature Selection
%   Author      : Giorgio Roffo and Simone Melzi and Marco Cristani
%   Link        : http://www.cv-foundation.org/openaccess/content_iccv_2015/html/Roffo_Infinite_Feature_Selection_ICCV_2015_paper.html
%   ResearchGate: https://www.researchgate.net/publication/282576688_Infinite_Feature_Selection
%  =========================================================================