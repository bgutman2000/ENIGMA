function write_P_with_mesh_all(P,base_str,vector_lengths,q)

ROI_ids = [53,17,51,12,50,11,49,10,54,18,52,13,58,26]; %Right, Left: Hippo, Putamen, Caudate, Thalamus, Amygdala, Pallidum, Accumbens

for i=1:size(P,1)
    
    
    
    cur_pos = 1;
    
    for j=1:2*length(ROI_ids)
        
        J = floor((j-1)/2)+1;
        atlas_name = sprintf('D:\\Users\\Boris\\Documents\\MATLAB\\Shape\\atlas\\atlas_%d.m',ROI_ids(J));
        
        S = sprintf('%s_%d.raw',base_str,i);
        fid = fopen(S,'w');
        fwrite(fid,P(i,cur_pos:cur_pos+vector_lengths(J)-1),'single');
        fclose(fid);
        
        cur_pos = cur_pos  +  vector_lengths(J);
        
        if(rem(j,2))
            Pmap_name = sprintf('D:\\Users\\Boris\\Documents\\MATLAB\\Shape\\SAGA\\maps1\\%s_rad_%d_mask%d.m',base_str,ROI_ids(J),i);
        else
            Pmap_name = sprintf('D:\\Users\\Boris\\Documents\\MATLAB\\Shape\\SAGA\\maps1\\%s_tbm_%d_mask%d.m',base_str,ROI_ids(J),i);
        end
        
        com_str = sprintf('D:\\Users\\Boris\\Documents\\MATLAB\\Shape\\CCBBM -color_attribute %s %s %s 0 %d',atlas_name,S,Pmap_name,q);
        
        system(com_str);
    end
            
        
        
    
    
end

%system('D:\Users\Boris\Documents\MATLAB\Shape\CCBBM -color_attribute out.m Rawstats_1.output-1.raw col.m');