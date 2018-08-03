function [p_vals, betas, D] = read_single_stat_meta_csv(name, name_Betas, main_factor_name)


p_val_string = sprintf('"meta_b_pval_%s"',main_factor_name);
b_val_string = sprintf('"meta_b_%s"',main_factor_name);
d_val_string = '"meta_d"';


[str_d_vals] = csvimport(name,'outputAsChar',true,'columns',{d_val_string});
[str_betas,str_p_vals] = csvimport(name_Betas,'outputAsChar',true,'columns',{b_val_string,p_val_string});


p_vals = zeros(length(str_p_vals),1);
betas = zeros(length(str_betas),1);
D = zeros(length(str_d_vals),1);

for i=1:length(betas)
    
    p_vals(i) = str2double(str_p_vals{i}(2:length(str_p_vals{i})-1) );
    betas(i) = str2double(str_betas{i}(2:length(str_betas{i})-1) );
    
    if(length(str_d_vals{i}) <= 2   )%strcmp('NA',str_d_vals{i}))
        D(i) = NaN;
    else
        D(i) = str2double(str_d_vals{i}(2:length(str_d_vals{i})-1) );
    end
end


