function [cell_alg_train, cell_true_train, cell_alg_test] = load_train_and_test_data(path_alg, path_true, name_attr_alg, name_attr_true)

% This function loads the ARFF data inside the specified folders into training and test sets
% and stores eye movement labels in cells for further processing. 
% All the folders in `@path_alg/train/` or `@path_true/train` will be taken for training, 
% all in `@path_alg/test/` - for testing.
%
% NB: Your data should be structured in a specific way to be handled by this function:
%   - the @path_alg folder should contain both train/ and test/ subfolders
%   - the @path_true folder should contain a train/ subfolder
%   - all of the train/ and test/ folders should n turn contain folders, each corresponding to one 
%     stimulus; each of these stimulus subfolders would contain the recordings for 
%     different subjects with this stimulus; 
%     IF YOU DO NOT USE SUCH A STRUCTURE ALREADY, you can just create one subfolder 
%     in all the train/ and test/ directories with an arbitrary name, which would contain 
%     all of your gaze files; it is only important that the file names in the two train/ 
%     folders match one another
%
% INPUT:
% path_alg, path_true: paths to folders containing .arff files with algorithm and true eye movement labels, respectively
% name_attr_alg, name_attr_true: the column (=attribute) names to be used in the respective .arff files 
%                                (default values of 'EYE_MOVEMENT_TYPE' and 'handlabeller_final', respectively)
% OUTPUT:
% cell_alg_train, cell_true_train, cell_alg_test: matlab objects containing the respective loaded gaze data


if nargin < 3
    name_attr_alg = 'EYE_MOVEMENT_TYPE';
end

if nargin < 4
    name_attr_true = 'handlabeller_final';
end

% find subfolders
subfolders_alg_train = dir([path_alg '/train']);
dir_flags = [subfolders_alg_train.isdir];
subfolders_alg_train = subfolders_alg_train(dir_flags);
subfolders_alg_train = subfolders_alg_train(~ismember({subfolders_alg_train.name}, {'.', '..'}));

subfolders_alg_test = dir([path_alg '/test']);
dir_flags = [subfolders_alg_test.isdir];
subfolders_alg_test = subfolders_alg_test(dir_flags);
subfolders_alg_test = subfolders_alg_test(~ismember({subfolders_alg_test.name}, {'.', '..'}));


subfolders_true_train = dir([path_true, '/train']);
dir_flags = [subfolders_true_train.isdir];
subfolders_true_train = subfolders_true_train(dir_flags);
subfolders_true_train = subfolders_true_train(~ismember({subfolders_true_train.name}, {'.', '..'}));

% check if names and sizes match
if size(subfolders_alg_train, 1) ~= size(subfolders_true_train, 1)
    error ('numbers of subfolders from path_alg/train and path_true/train do not match')
end

size_trainset = size(subfolders_alg_train, 1);
size_testset = size(subfolders_alg_test, 1);
for sample = 1:size_trainset
    if subfolders_alg_train(sample).name ~= subfolders_true_train(sample).name
        error ('names of subfolders from path_alg/train and path_true/train do not match')
    end
end

trainset = subfolders_alg_train;
testset = subfolders_alg_test;

% train data --------------------------------------------------------------
tic
disp([' '])
disp(['loading training data...'])
cell_alg_train = cell(size_trainset, 1);
cell_true_train = cell(size_trainset, 1);
EM_place_alg = [];
EM_place_true = [];

% alg dataset
for folderlength = 1:size_trainset
    filenames_alg_train = dir(strcat(path_alg, '/train/', subfolders_alg_train(folderlength).name));
    filenames_alg_train = filenames_alg_train(~[filenames_alg_train.isdir]);
    
    % find eye movement label place in arff-data
    if isempty(EM_place_alg)
       wo = loadARFF(strcat(path_alg, '/train/', subfolders_alg_train(1).name, '/', filenames_alg_train(1).name));
       num_attr = numAttributes(wo);
       
       for place = 0:num_attr-1
           if wo.attribute(place).name == name_attr_alg
               EM_place_alg = place;
           end
       end
    end
    
    if isempty(EM_place_alg)
        error('Aborting \nCould not find attribute with name: %s', name_attr_alg)
    end
    
    % load alg_train data
    for filelength = 1:size(filenames_alg_train, 1)
        cell_alg_train{folderlength}{filelength, 1} = get_EMlabel(strcat(path_alg, '/train/', subfolders_alg_train(folderlength).name, '/', filenames_alg_train(filelength).name), EM_place_alg);
    end
end

% true dataset
for folderlength = 1:size_trainset
    filenames_true_train = dir(strcat(path_true, '/train/', subfolders_true_train(folderlength).name));
    filenames_true_train = filenames_true_train(~[filenames_true_train.isdir]);
    
    % find eye movement label place in arff-data
    if isempty(EM_place_true)
       wo = loadARFF(strcat(path_true, '/train/', subfolders_true_train(1).name, '/', filenames_true_train(1).name));
       num_attr = numAttributes(wo); 
       
       for place = 0:num_attr-1
           if wo.attribute(place).name == name_attr_true
               EM_place_true = place;
           end
       end           
    end
    
    if isempty(EM_place_true)
        error('Aborting \nCould not find attribute with name: %s', name_attr_true)
    end
    
    % load true_train data
    for filelength = 1:size(filenames_true_train, 1)
        cell_true_train{folderlength}{filelength, 1} = get_EMlabel(strcat(path_true, '/train/', subfolders_true_train(folderlength).name, '/', filenames_true_train(filelength).name), EM_place_true);
    end
end
disp(['done loading training data'])
toc

% test data ---------------------------------------------------------------
tic
disp([' '])
disp(['loading testing data...'])
cell_alg_test = cell(size_testset, 1);
cell_true_test = cell(size_testset , 1);

% load alg_test data
for folderlength = 1:size_testset
    filenames_alg_test = dir(strcat(path_alg, '/test/', subfolders_alg_test(folderlength).name));
    filenames_alg_test = filenames_alg_test(~[filenames_alg_test.isdir]);
    
    for filelength = 1:size(filenames_alg_test, 1)
        cell_alg_test{folderlength}{filelength, 1} = get_EMlabel(strcat(path_alg, '/test/', subfolders_alg_test(folderlength).name, '/', filenames_alg_test(filelength).name), EM_place_alg);
    end
end
disp(['done loading testing data'])

toc
disp([' '])
end
