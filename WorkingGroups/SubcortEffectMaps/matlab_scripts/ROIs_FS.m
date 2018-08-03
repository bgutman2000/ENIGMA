function [startRAD, finishRAD, startTBM, finishTBM] = ROIs_FS(ROI_vector_lengths)


ROI_ids = [53,17,51,12,50,11,49,10,54,18,52,13,58,26]; %Right, Left: Hippo, Putamen, Caudate, Thalamus, Amygdala, Pallidum, Accumbens
%ROI_vector_lengths = zeros(size(ROI_ids));

startRAD = ones(58,1);
finishRAD = ones(58,1);

startTBM = ones(58,1);
finishTBM = ones(58,1);
cur = 0;

for i=1:length(ROI_ids)
    cur = cur + 2*ROI_vector_lengths(i);
    
    startRAD(ROI_ids(i)) = cur - 2*ROI_vector_lengths(i) + 1;
    finishRAD(ROI_ids(i)) = startRAD(ROI_ids(i)) + ROI_vector_lengths(i) - 1;
    startTBM(ROI_ids(i)) = finishRAD(ROI_ids(i)) + 1;
    finishTBM(ROI_ids(i)) = startTBM(ROI_ids(i)) + ROI_vector_lengths(i) - 1;
end


    
    