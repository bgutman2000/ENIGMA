function q = FDR(p)


    %ps = sort(p);     
    ps = [0; sort(p)];     
    % y = 1/length(p):1/length(p):1;     
    y = 0:1/length(p):1; 
     q = 0;
     
     if(max(p) < 0.05)
         q = 0.05;
     end
     
     %for i=2:length(ps)-1
     for i=1:length(ps)-1
         if(y(i)/ps(i) > 20 && y(i+1)/ps(i+1) <= 20)
             q = ps(i);
             break;
         end
     end
 