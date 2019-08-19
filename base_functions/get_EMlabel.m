function EM_label = get_EMlabel(arfffile, place)

% get_EMlabel loads the eye movement labels of the specified arff-file as numeric values
%
% INPUT:
% arfffile: the arff file to be loaded, e.g. 'filename.arff'
% place: zero-based place of eye movement labels in attribute order 


wo = loadARFF(arfffile); % we = weka object

EM_label = zeros(size(wo), 1);

for a=1:size(wo)
    EM_label(a) = wo.get(a-1).value(place);
end       
        
end
