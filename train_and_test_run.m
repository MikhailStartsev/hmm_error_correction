function [] = train_and_test_run(path_alg, alg_name, alg_label_name, path_true, true_label_name, savepath)
% This function trains & tests the label correction HMM on the data from @path_alg (algorithmic labels) and 
% @path_true ("ground truth" labels - only or the training set). 
% 
% The training set files are always found in the @path_alg/train and @path_true/train folders, respectively.
% The respective labels are taken from the @alg_label_name and @true_label_name columns of the .arff files.
% The output is saved either to the @savepath folder, or the default folder created in the "corrected_outputs/" folder.

% @path_alg is the only required argument
% If @path_alg is "properly" named (see below), @alg_name and @alg_label_name do not have ot be provided.
% "Proper" naming means that the name of the folder looks like "Arbitrary description words without dashes - NAME_OF_THE_ARFF_ATTRIBUTE_TO_USE".
%
% Otherwise, @alg_name can be whatever you want the output folder to be named (just the folder name, not a path)!
% @alg_label_name is the column name in the .arff files, where the algorithmic label is stored. The respective attribute can be either numeric or categorical.
%
% @path_true and @true_label_name describe the ground truth data that is available. Only the train/ subfolder is required there (in @path_true).
% @true_label_name has a default value of "handlabeller_final" (like it is for the GazeCom & Hollywood2 data sets) and
% denotes the column of the .arff files in the @path_true that contains the expert labels.
%
% @savepath defaults to "corrected_outputs/@alg_name/test", but you can specify any.


addpath('base_functions', 'weka_library')

% fallback values - run on the example data set
if nargin < 1
    path_alg = 'example_data/algorithm_labels - EYE_MOVEMENT_TYPE/'
if nargin < 5
    true_label_name = 'handlabeller_final'
    if nargin < 4
        path_true = 'example_data/true_labels/' 
    end
end

% algorithm name used to name the output folder
if nargin < 2
    [~, alg_name, extension] = fileparts(strip(path_alg, 'right', '/'));
    alg_name = [alg_name, extension] % in case algorithm name contained . (e.g. "XXX et al.")
end 

% automatically parsing folder names something like "/path/to/Algorightnm of XXX et al. - COLUMN_NAME"
if nargin < 3
    alg_label_name = split(alg_name, ' - ');
    alg_label_name = char(alg_label_name(end)) 
end

if nargin < 6
    savepath = ['corrected_outputs/', alg_name, '/test']
end
system(['mkdir -p "', savepath, '"']);

% load train and test subsets
[cell_alg_train, cell_true_train, cell_alg_test] = load_train_and_test_data(path_alg, path_true, alg_label_name, true_label_name);


% train and test HMM to smooth labels followed by evaluation
[cell_alg_test_HMM] = smoothlabels(cell_alg_train, cell_true_train, cell_alg_test);

% store smoothed labels, only the test set
store_EMlabel(cell_alg_test_HMM, savepath, [path_alg, '/test'], alg_label_name);

end
