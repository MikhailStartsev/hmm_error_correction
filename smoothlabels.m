function [cell_alg_test_HMM] = smoothlabels(cell_alg_train, cell_true_train, cell_alg_test)

% This function trains an HMM using train data and applies the Viterbi algorithm on test data
%
% INPUT:
% cell_alg_train, cell_true_train, cell_alg_test: train and test data as returned by base_functions/splitdata()
%
% OUTPUT:
% cell_alg_test_HMM: HMM-smoothed eye movement labels from @cell_alg_test


disp(['begin smoothing...'])

[TRANS,EMIS,SYMBOLS] = trainhmm(cell_alg_train, cell_true_train);

% test hmm by reconstructing expected seq from test data
[cell_alg_test_HMM] = testhmm(cell_alg_test, TRANS, EMIS, SYMBOLS);


disp(['done'])

end

