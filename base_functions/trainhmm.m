function [TRANS_EST, EMIS_EST, SYMBOLS] = trainhmm(cell_alg, cell_true, PSEUDOE)

% This function trains HMM emission and transition matrices 
%
% INPUT:
% 
% PSEUDOE: (optional) pseudo emission matrix

% concatenate all labels from all files into one sequence (to train an HMM with matlab functions)

cell_all_alg_labels = cell(0);
cell_all_true_labels = cell(0);

for video = 1:size(cell_alg, 1)
    for observer = 1:size(cell_alg{video}, 1)
        cell_all_alg_labels = [cell_all_alg_labels; cell_alg{video}{observer}];
        cell_all_true_labels = [cell_all_true_labels; cell_true{video}{observer}];
    end
end

cell_alg = cell_all_alg_labels;
cell_true = cell_all_true_labels;

length = size(cell_alg, 1);
  
mat_alg = [];
mat_true = [];

for sample = 1:length
    mat_alg = vertcat(mat_alg, cell_alg{sample});
    mat_true = vertcat(mat_true, cell_true{sample});
end 

% by default, HMM labels start from 1; some algorithms yield 0 labels, however
min_symbol = min(mat_alg);
max_symbol = max(mat_alg);
SYMBOLS = min_symbol:max_symbol;

% since lumping all data in one sequence creates "fake" transitions, let's count them to delete these later on
last_label_from_previous_seq = 0;
first_label_from_current_seq = 0;
extra_transitions_counter = zeros(numel(SYMBOLS));
for sample = 2:length
    last_label_from_previous_seq = cell_true{sample-1}(end);
    first_label_from_current_seq = cell_true{sample}(1);
    extra_transitions_counter(last_label_from_previous_seq, first_label_from_current_seq) = extra_transitions_counter(last_label_from_previous_seq, first_label_from_current_seq) + 1; 
end

% below are the estimated HMM-matrices with error
if nargin == 3
    [TRANS_EST, EMIS_EST] = hmmestimate(mat_alg, mat_true, 'Pseudoemissions', PSEUDOE, 'Symbols', SYMBOLS);
else
    [TRANS_EST, EMIS_EST] = hmmestimate(mat_alg, mat_true, 'Symbols', SYMBOLS);
end

disp(['trained on ', num2str(numel(mat_alg)), ' samples'])

% delete the erroneously accumlated error in the transition matrix (due to putting all the separate sequence into one)
overall_counts = accumarray(mat_true(1:end-1), 1);

TRANS_EST_updated = zeros(size(TRANS_EST));
for row = 1:size(TRANS_EST, 1)
    TRANS_EST_updated(row, :) = (TRANS_EST(row, :) * overall_counts(row)) - extra_transitions_counter(row, :);
    overall_counts(row) = overall_counts(row) - sum(extra_transitions_counter(row, :));
    TRANS_EST(row, :) = TRANS_EST_updated(row, :) / overall_counts(row);
end 

end


            
