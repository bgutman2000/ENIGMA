function write_attribute_with_mesh(att,base_str,ROI_ids,min_v, max_v)

%ROI_ids = [53,17,51,12,50,11]; %Right, Left: Hippo, Putamen, Caudate

for i=1:size(att,1)
      
        atlas_name = sprintf('D:\\Users\\Boris\\Documents\\MATLAB\\Shape\\atlas\\atlas_%d.m',ROI_ids);
        
        S = sprintf('%s_%d.raw',base_str,i);
        fid = fopen(S,'w');
        fwrite(fid,att(i,:),'single');
        fclose(fid);
    
      
        Pmap_name = sprintf('D:\\Users\\Boris\\Documents\\MATLAB\\Shape\\PPMI\\%s_%d_mask%d.m',base_str,ROI_ids,i);
        Pmap_name_obj = sprintf('D:\\Users\\Boris\\Documents\\MATLAB\\Shape\\PPMI\\%s_%d_mask%d.obj',base_str,ROI_ids,i);
                
        com_str = sprintf('D:\\Users\\Boris\\Documents\\MATLAB\\Shape\\CCBBM -color_attribute %s %s %s %d %d',atlas_name,S,Pmap_name,min_v,max_v);
        com_str2 = sprintf('D:\\Users\\Boris\\Documents\\MATLAB\\Shape\\CCBBM -mesh2obj %s %s ',Pmap_name,Pmap_name_obj);
        
        system(com_str);    
        system(com_str2);  
    
end

%system('D:\Users\Boris\Documents\MATLAB\Shape\CCBBM -color_attribute out.m Rawstats_1.output-1.raw col.m');