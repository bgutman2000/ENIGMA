function [p_vals, betas, d_vals, r_vals] = read_single_stat_csv_mega2(name, main_factor_name, measure_name)



p_val_string = sprintf('"p.val_%s"',main_factor_name);

if(length(strfind(main_factor_name,'factor')) == 0)
    clear p_val_string;
    p_val_string = sprintf('"p.val_corr"');
end

b_val_string = sprintf('"beta_%s"',main_factor_name);
%r_val_string = sprintf('"r_%s_vs_%s"',measure_name, main_factor_name);
d_val_string = sprintf('"d_%s"',main_factor_name);

err_string = sprintf('"st_err_%s"', main_factor_name);


fid=fopen(name);
tline = fgetl(fid);
fclose(fid);
num_cols = length(find(tline==','))+1;

DF_adj = (num_cols - 12)/2;

[str_betas,str_err, str_d, str_N, str_p_vals] = csvimport(name,'outputAsChar',true,'columns',{b_val_string,err_string, d_val_string,'"n.overall"',p_val_string});%,'delimiter','","');


p_vals = zeros(length(str_p_vals),1);
betas = zeros(length(str_betas),1);
d_vals = zeros(length(str_d),1);
%err_vals = zeros(length(str_err),1);
%N_vals = zeros(length(str_N),1);
%r_vals = zeros(length(str_r),1);

for i=1:length(betas)
    
    p_vals(i) = str2double(str_p_vals{i}(2:length(str_p_vals{i})-1) );
    betas(i) = str2double(str_betas{i}(2:length(str_betas{i})-1) );
    
    d_vals(i) = str2double(str_d{i}(2:length(str_d{i})-1) );
    err_vals = str2double(str_err{i}(2:length(str_err{i})-1) );
    
    N_vals = str2double(str_N{i}(2:length(str_N{i})-1) );
    
    DF = N_vals - DF_adj;
    t = 0;
    if(err_vals > 0.0)
        t = betas(i)/err_vals;
    else
        t = NaN;
    end
    r_vals(i) = t/sqrt(t*t + DF);
    
    p_vals(i) = 2*(1 - tcdf(abs(t),DF));
    
    
   % r_vals(i) = str2double(str_r{i}(2:length(str_r{i})-1) );
end
    
