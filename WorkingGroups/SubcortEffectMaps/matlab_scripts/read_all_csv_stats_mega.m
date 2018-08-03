function [P, BETA] = read_all_csv_stats_mega(prefix, file_names, postfix,factor_names)


ROI_ids = [53,17,51,12,50,11,49,10,54,18,52,13,58,26];
ROI_vector_lengths = [2502,2502,2502,2502,2502,2502,2502,2502,1368,1368,1254,1254,930,930];

[startRAD, finishRAD, startTBM, finishTBM] = ROIs_FS2(ROI_vector_lengths, ROI_ids);


for i = 1:length(file_names)
    
    main_factor_name = factor_names{i};
    cur_pref_id = 1;
    
    for j=1:length(ROI_ids)
        
        ID = ROI_ids(j);
        
        
       if(j == 1)
            for k = 1:length(prefix)
                LogJacs_name = sprintf('%s_%d_LogJacs_%s_%s.csv',prefix{k},ID,file_names{i},postfix);
                fid = fopen(LogJacs_name,'r');
                if(fid > 0)
                    cur_pref_id = k;
                    fclose(fid);
                    break;
                end
            end
       end
       
        LogJacs_name = sprintf('%s_%d_LogJacs_%s_%s.csv',prefix{cur_pref_id},ID,file_names{i},postfix);   
        display(LogJacs_name);
        [p_vals, betas] = read_single_stat_csv_mega(LogJacs_name, main_factor_name);        
        
        P_cur(startTBM(ID):finishTBM(ID)) = p_vals;
        BETA_cur(startTBM(ID):finishTBM(ID)) = betas;        
        
        
        thick_name = sprintf('%s_%d_thick_%s_%s.csv',prefix{cur_pref_id},ID,file_names{i},postfix);
        [p_vals2, betas2] = read_single_stat_csv_mega(thick_name, main_factor_name);        
        
        P_cur(startRAD(ID):finishRAD(ID)) = p_vals2;
        BETA_cur(startRAD(ID):finishRAD(ID)) = betas2;        
        
    end
    
    P{i} = P_cur;
    BETA{i} = BETA_cur;
    
end
    
    
        