function S = strsplit_Boris(str,delim)

n = 1;
pos(1) = 0;

for i = 1: length(str)
    
    if(strcmp(str(i),delim))
        n = n+1;
        pos(n) = i;
    end
end

pos(n+1) = length(str);


if(n > 1)

for i = 1: n-1    
    S{i} = str(pos(i)+1:pos(i+1)-1);
end

end

S{n} = str(pos(n)+1:pos(n+1));


