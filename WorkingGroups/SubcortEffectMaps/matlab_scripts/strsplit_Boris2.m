function S = strsplit_Boris2(str,delim)

n = 1;


for i = 1: length(str)
    
    for j=1:length(delim)
        if(strcmp(str(i:min(i - 1 + length(delim{j}), length(str))  ),delim{j}))
            
            start(n) = i - 1 + length(delim{j});
            if(n > 1)
                finish(n-1) = i;
            end
            
            if(i - 1 + length(delim{j}) >= length(str))
                finish(n) = i;
            end            
            
            i = i + length(delim{j}) - 1;
            n = n+1;
        end
    end
end

pos(n+1) = length(str);


if(n > 1)

for i = 1: n-1    
    S{i} = str(start(i)+1:finish(i)-1);
end

end

%S{n} = str(pos(n)+1:pos(n+1));


