function [p_vals, betas] = read_single_stat_csv_mega(name, main_factor_name)


p_val_string = sprintf('"p.val.OfInt_%s"',main_factor_name);
b_val_string = sprintf('"beta_%s"',main_factor_name);



[str_betas,str_p_vals] = csvimport(name,'outputAsChar',true,'columns',{b_val_string,p_val_string});%,'delimiter','","');


p_vals = zeros(length(str_p_vals),1);
betas = zeros(length(str_betas),1);

for i=1:length(betas)
    
    p_vals(i) = str2double(str_p_vals{i}(2:length(str_p_vals{i})-1) );
    betas(i) = str2double(str_betas{i}(2:length(str_betas{i})-1) );
end
    
