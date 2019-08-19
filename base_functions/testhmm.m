function [cell_seq_recon] = testhmm(cell_test, TRANS, EMIS, SYMBOLS)

% This function applies the hmmviterbi function on the test data.
% This uses transition and emission matrices returned by trainhmm()


length = size(cell_test, 1);
cell_seq_recon = cell(length, 1);

total_num_subject_is = 0;
for folder_i = 1:length
    % reconstruct the most probable hidden states
    for subject_i = 1:size(cell_test{folder_i}, 1)
        total_num_subject_is = total_num_subject_is + size(cell_test{folder_i}{subject_i}, 1);
        if nargin < 4
            cell_seq_recon{folder_i}{subject_i, 1} = hmmviterbi(cell_test{folder_i}{subject_i}, TRANS, EMIS)';
        else
            cell_seq_recon{folder_i}{subject_i, 1} = hmmviterbi(cell_test{folder_i}{subject_i}, TRANS, EMIS, 'Symbols', SYMBOLS)';
        end
    end
end

disp(['tested on ', num2str(total_num_subject_is), ' samples'])

end
