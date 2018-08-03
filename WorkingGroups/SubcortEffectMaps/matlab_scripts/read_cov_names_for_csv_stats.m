function [names, factors] = read_cov_names_for_csv_stats(cov_file_name)


fid = fopen(cov_file_name,'r');
i = 1;

while(~feof(fid) );     
     str =  fscanf(fid,'%s',1); 
%     display(str);
     if(length(str) > 1)
         Split = strsplit_Boris(str,',');   
%          display('Split{1}');
%          display(Split{1});
%          display('Split{2}');
%          display(Split{2});
         names{i} = Split{1};
         factors{i} = Split{2};
         i = i+1;
     end
     
end

fclose(fid);
