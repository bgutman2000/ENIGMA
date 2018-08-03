function [p_vals, betas, r] = read_single_stat_csv(name, main_factor_name)


%display(fname);

fid = fopen(name,'r');
head =  fscanf(fid,'%s',1);
headers = strsplit_Boris(head,',');
headers = str_remove_ends_Boris(headers);



p_ind = -1;
r_ind = -1;
beta_ind = -1;

for j = 1:length(headers)   
   % display(headers{j});
    if(strcmp('p.val',headers{j}))
        p_ind = j;
    end
    
    if(strcmp('r',headers{j}))
        r_ind = j;
    end
    
    if(strcmp(main_factor_name,headers{j}))
        beta_ind = j;
    end
    
end
        
        
all_found = 1;

if(p_ind < 1)
    printf('cant find pval  string %s\n','p.val');
    all_found = 0;
end

if(r_ind < 1)
    printf('cant find r-value  string %s\n','r');
    all_found = 0;
end

if(beta_ind < 1)
    printf('cant find beta string %s\n',main_factor_name);
    all_found = 0;
end

% r_ind
% p_ind
% beta_ind

i = 1;
while(~feof(fid) && all_found)
    
    str =  fscanf(fid,'%s',1);
    Split = strsplit_Boris(str,',');
    Split = str_remove_ends_Boris(Split);
  
  
    if(length(Split) >= p_ind)
        p_vals(i) = sscanf(Split{p_ind},'%g',1); 
        
        if(length(Split{r_ind}) > 0)
            r(i) = sscanf(Split{r_ind},'%g',1);
        else
            r(i) = NaN;
        end
        betas(i) = sscanf(Split{beta_ind},'%g',1);   
    end
    
    i = i + 1;
end


fclose(fid);