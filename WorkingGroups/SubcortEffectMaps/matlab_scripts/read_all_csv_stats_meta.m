function [P, D, BETA] = read_all_csv_stats_meta(prefix, file_names, postfix,factor_names)


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
                LogJacs_name = sprintf('%s_D_%d_LogJacs_%s',prefix{k},ID,file_names{i});
                if(~isempty(postfix))
                    LogJacs_name = sprintf('%s_%s',LogJacs_name,postfix);
                end
                LogJacs_name = sprintf('%s.csv',LogJacs_name);
                    
                fid = fopen(LogJacs_name,'r');
                if(fid > 0)
                    cur_pref_id = k;
                    fclose(fid);
                    break;
                end
            end
       end
       
        LogJacs_name = sprintf('%s_D_%d_LogJacs_%s',prefix{cur_pref_id},ID,file_names{i});   
        LogJacs_name_betas = sprintf('%s_B_%d_LogJacs_%s',prefix{cur_pref_id},ID,file_names{i}); 
        if(~isempty(postfix))
            LogJacs_name = sprintf('%s_%s',LogJacs_name,postfix);
            LogJacs_name_betas = sprintf('%s_%s',LogJacs_name_betas,postfix);
        end
        LogJacs_name = sprintf('%s.csv',LogJacs_name);        
        LogJacs_name_betas = sprintf('%s.csv',LogJacs_name_betas);   
         
        display(LogJacs_name);
        
        [p_vals, betas, d] = read_single_stat_meta_csv(LogJacs_name, LogJacs_name_betas, main_factor_name);        
        
        P_cur(startTBM(ID):finishTBM(ID)) = p_vals;
        D_cur(startTBM(ID):finishTBM(ID)) = d;
        BETA_cur(startTBM(ID):finishTBM(ID)) = betas;        
        
        
        thick_name = sprintf('%s_D_%d_thick_%s',prefix{cur_pref_id},ID,file_names{i});
        thick_name_betas = sprintf('%s_B_%d_thick_%s',prefix{cur_pref_id},ID,file_names{i});
        if(~isempty(postfix))
            thick_name = sprintf('%s_%s',thick_name,postfix);
            thick_name_betas = sprintf('%s_%s',thick_name_betas,postfix);
        end
        thick_name = sprintf('%s.csv',thick_name); 
        thick_name_betas = sprintf('%s.csv',thick_name_betas); 
        
        [p_vals2, betas2, d2] = read_single_stat_meta_csv(thick_name, thick_name_betas, main_factor_name);        
        
        P_cur(startRAD(ID):finishRAD(ID)) = p_vals2;
        D_cur(startRAD(ID):finishRAD(ID)) = d2;
        BETA_cur(startRAD(ID):finishRAD(ID)) = betas2;        
        
    end
    
    P{i} = P_cur;
    D{i} = D_cur;
    BETA{i} = BETA_cur;
    
end
    
    
        