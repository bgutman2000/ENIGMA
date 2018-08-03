function color_map_lookup = create_lookup_colormap(min_value, max_value, color_map_var)

L = 512;
NS_col = [0.1 0 0.17];


zero_pos = ceil(L*abs(min_value)/(abs(min_value)+abs(max_value)));


std_range_val = linspace(min_value,max_value,L);
color_map = zeros(L,3);
color_map_lookup = zeros(L+2,3);
%color_map_lookup = zeros(length(std_range_val),3);

for z = 1:length(std_range_val)
    c = hot_cold(std_range_val(z), color_map_var(1),color_map_var(2), color_map_var(3),color_map_var(4),color_map_var(5),color_map_var(6),color_map_var(7));
    color_map(z,:) = c;
end

%color_map_lookup(1,:) = [0.2941 0 0.5098];
color_map_lookup(1:zero_pos-1,:) = color_map(1:zero_pos-1,:);
color_map_lookup(zero_pos:zero_pos+1,:) = [NS_col;NS_col];
color_map_lookup(zero_pos+2:end,:) = color_map(zero_pos:end,:);

%color_map_lookup = color_map;

end