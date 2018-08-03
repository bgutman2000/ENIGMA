function [Q_LIST_ALL, SCLALE_LIST_ALL, HITS_all, SCALE, AREA, MEAN_POS_B, MEAN_NEG_B, ROI_names] ...
    = all_shape_SL_global_bilat_viz(P,BETA,names, fig_finish, ns_roi_color, output_dir)

output_summary_file = fullfile(output_dir,'summary.csv');
%fclose(fid);
fid = fopen(output_summary_file,'w+');

for i=1:length(P)    
    [q_list, scale_list, hits, overall_scale, area_list, mean_pos_beta_list, mean_neg_beta_list, ROI_names] ...
        = print_all_hits_SL_global_bilat_viz(P{i}, BETA{i}, names{i}, fig_finish, ns_roi_color, output_dir);
    Q_LIST_ALL{i} = q_list;
    SCLALE_LIST_ALL{i} = scale_list;
    HITS_all{i} = hits;
    SCALE{i} = overall_scale;
    AREA{i} = area_list;
    MEAN_POS_B{i} = mean_pos_beta_list;
    MEAN_NEG_B{i} = mean_neg_beta_list;
    
   fprintf(fid,',%s',names{i});
    
end

fprintf(fid,'\n');

 
 measure{1} = 'thick';
 measure{2} = 'LogJac';
 
   
for i=1:length(ROI_names)
    name = sprintf('%s',ROI_names{i});
    for j=1:2
       m_name = sprintf('%s',measure{j});
       
       fprintf(fid,'%s %s %% area',name, m_name);
       for k=1:length(P)
           fprintf(fid,',%d',AREA{k}(i,j));
       end
       fprintf(fid,'\n');
       
       fprintf(fid,'%s %s: mean + effect size',name, m_name);
       for k=1:length(P)
           fprintf(fid,',%d',MEAN_POS_B{k}(i,j));
       end
       fprintf(fid,'\n');
       
            fprintf(fid,'%s %s: mean - effect size',name, m_name);
       for k=1:length(P)
           fprintf(fid,',%d',MEAN_NEG_B{k}(i,j));
       end
       fprintf(fid,'\n');
    end
           
           
end
  
fclose(fid);