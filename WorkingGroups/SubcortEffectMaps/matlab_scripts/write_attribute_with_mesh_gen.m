function write_attribute_with_mesh_gen(att,base_str,ROI_ids,min_v, max_v, cutoff, att_name, dir_orig)

%ROI_ids = [53,17,51,12,50,11]; %Right, Left: Hippo, Putamen, Caudate

for i=1:size(att,1)
      
        atlas_name = sprintf('C:\\Users\\bgutm\\Documents\\MATLAB\\Test_for_grad_students\\atlas\\atlas_%d.m',ROI_ids);
        
        S = sprintf('%s_%d.raw',base_str,i);
        fid = fopen(S,'w');
        fwrite(fid,att(i,:),'single');
        fclose(fid);
        
        dir =  sprintf('%s\\maps',dir_orig);
       % dir = 'D:\From_ThinkPad_W520\MATLAB\Schizo_Meta_SOBP\maps2';
       
        mkdir_str1 = sprintf('mkdir %s',dir);
        system(mkdir_str1);
          
        mkdir_str = sprintf('mkdir %s\\%s',dir, att_name);
        system(mkdir_str);
    
      
        Pmap_name = sprintf('%s\\%s\\%s_%d_mask%d.m',dir,att_name,base_str,ROI_ids,i);
        Pmap_name_obj = sprintf('%s\\%s\\%s_%d_mask%d.obj',dir,att_name,base_str,ROI_ids,i);
                
        com_str = sprintf('C:\\Users\\bgutm\\Documents\\MATLAB\\Test_for_grad_students\\MeshLibrary -color_hot_cold %s %s %s %d %d %d %d -full_range',atlas_name,S,Pmap_name,min_v,max_v, (-1.0)*cutoff, cutoff);
        com_str2 = sprintf('C:\\Users\\bgutm\\Documents\\MATLAB\\Test_for_grad_students\\MeshLibrary -mesh2obj %s %s ',Pmap_name,Pmap_name_obj);
        
     %   display(com_str);
     %   display(com_str);
        
        system(com_str);    
        system(com_str2);  
        
        system(sprintf('del %s',S));
    
end

%system('D:\Users\Boris\Documents\MATLAB\Shape\CCBBM -color_attribute out.m Rawstats_1.output-1.raw col.m');