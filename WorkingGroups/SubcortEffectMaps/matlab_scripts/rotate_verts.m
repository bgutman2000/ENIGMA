function res = rotate_verts(vertices,axis,angle)

mu = mean(vertices);
res = ones(size(vertices));

for i=1:size(vertices,1)
    V = vertices(i,:)' - mu';    
    V_new = cos(angle)*V + sin(angle)*cross(axis,V) + (1-cos(angle))*(axis'*V)*axis;  
 %   printf('old V\n');
   % V
 %   printf('new V\n');
  %  V_new
    res(i,:) = mu + V_new';
end
    