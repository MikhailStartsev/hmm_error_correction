function [] = store_EMlabel(cell_alg_test_HMM, savepath_alg, path_alg, name_attr_alg)

% This function replaces the eye movement labels in original .arff files with
% corrected labels and stores them to the specified @savepath
%
% INPUT:
% cell_alg_test_HMM: smoothed eye movement labels
% savepath_alg: path to folder, where the .arff files should be stored
% path_alg: the path to the original (i.e. before correction) algorithm label files (to get the file structure right)
% name_attr_alg: which column to use in the .arff files (defaults to EYE_MOVEMENT_TYPE); should match the column
%                that contains the original algorithm labels in @path_alg

% define attribute name of eye movement labels from arff-files
if nargin < 4
    name_attr_alg = 'EYE_MOVEMENT_TYPE';
end


% find subfolders
subfolders_alg = dir(path_alg);
dir_flags = [subfolders_alg.isdir];
subfolders_alg = subfolders_alg(dir_flags);
subfolders_alg = subfolders_alg(~ismember({subfolders_alg.name}, {'.', '..'}));

size_testset = size(subfolders_alg, 1);


disp([' '])
disp(['saving test dataset:'])

EM_place_alg = [];

for folderlength = 1:size_testset
    filenames_alg_test = dir(strcat(path_alg, '/', subfolders_alg(folderlength).name));
    filenames_alg_test = filenames_alg_test(~[filenames_alg_test.isdir]);
    
    % find eye movement label place in the arff data
    if isempty(EM_place_alg)
       wo = loadARFF(strcat(path_alg, '/', subfolders_alg(1).name, '/', filenames_alg_test(1).name));
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
    
    % create the target folder if not exist
    if ~exist(strcat(savepath_alg, '/', subfolders_alg(folderlength).name), 'dir')
        mkdir(strcat(savepath_alg, '/', subfolders_alg(folderlength).name));
    end
    
    disp([' ', subfolders_alg(folderlength).name])
    
    for filelength = 1:size(filenames_alg_test, 1)
        wo = loadARFF(strcat(path_alg, '/', subfolders_alg(folderlength).name, '/', filenames_alg_test(filelength).name));
        number_inc = size(wo);
        for row = 1:number_inc
            wo.get(row-1).setValue(EM_place_alg, cell_alg_test_HMM{folderlength}{filelength}(row));
        end
        
        % save ARFF
        saveARFF(strcat(savepath_alg, '/', subfolders_alg(folderlength).name, '/', filenames_alg_test(filelength).name), wo);
    end
end

disp([' '])
disp(['done'])

end
