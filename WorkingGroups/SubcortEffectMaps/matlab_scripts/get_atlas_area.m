function [area] = get_atlas_area(ROI_id)
          
    atlas_name = sprintf('C:\\Users\\GutmanLabGPU\\Documents\\MATLAB\\Shape\\atlas\\area_%d.raw',ROI_id);

    fid = fopen(atlas_name,'r');
    area = fread(fid,'single');
    fclose(fid);

end
