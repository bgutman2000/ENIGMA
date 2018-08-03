function [coords] = get_atlas_coords(ROI_id)
      
    atlas_name = sprintf('C:\\Users\\bgutm\\Documents\\MATLAB\\Test_for_grad_students\\atlas\\atlas_%d.m',ROI_id);

    S1 = sprintf('X_%d.raw',ROI_id);
    S2 = sprintf('Y_%d.raw',ROI_id);
    S3 = sprintf('Z_%d.raw',ROI_id);

    com_str = sprintf('C:\\Users\\bgutm\\Documents\\MATLAB\\Test_for_grad_students\\MeshLibrary -store_att_xyz %s %s %s %s',atlas_name, S1, S2, S3);
    system(com_str); 

    fid = fopen(S1,'r');
    coords(:,1) = fread(fid,'single');
    fclose(fid);

    fid = fopen(S2,'r');
    coords(:,2) = fread(fid,'single');
    fclose(fid);

    fid = fopen(S3,'r');
    coords(:,3) = fread(fid,'single');
    fclose(fid);

    system(sprintf('del %s',S1));
    system(sprintf('del %s',S2));
    system(sprintf('del %s',S3));
    
end
