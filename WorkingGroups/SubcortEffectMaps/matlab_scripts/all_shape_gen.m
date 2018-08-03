function [Q_LIST_ALL, SCLALE_LIST_ALL, HITS_all, SCALE] = all_shape_gen(P,BETA,names, output_dir)

for i=1:length(P)    
    [q_list, scale_list, hits, overall_scale] = print_all_hits_gen(P{i}, BETA{i}, names{i}, output_dir);
    Q_LIST_ALL{i} = q_list;
    SCLALE_LIST_ALL{i} = scale_list;
    HITS_all{i} = hits;
    SCALE{i} = overall_scale;
end