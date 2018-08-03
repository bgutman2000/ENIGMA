function q = FDR2(p, q_cont)


    %ps = sort(p);     
    ps = [0; sort(p)];     
    % y = 1/length(p):1/length(p):1;     
    y = 0:1/length(p):1; 
     q = 0;
     
     if(max(p) < q_cont)
         q = q_cont;
     end
     
     %for i=2:length(ps)-1
     for i=1:length(ps)-1
         if(y(i)/ps(i) > 1/q_cont && y(i+1)/ps(i+1) <= 1/q_cont)
             q = ps(i);
             break;
         end
     end
 