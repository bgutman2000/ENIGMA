function q = plot_FDR_SL(p,style, f_hold)

    %ps = sort(p);
    ps = [0; sort(p)];     
    % y = 1/length(p):1/length(p):1;     
     y = 0:1/length(p):1;     
     q = 0;
     
     if(max(p) < 0.05)
         q =  0.05;
     end
     
   %  for i=2:length(ps)-1
     for i=1:length(ps)-1
         if(y(i)/ps(i) > 1/ 0.05 && y(i+1)/ps(i+1) <= 1/ 0.05)
             q = ps(i);
             break;
         end
     end
     
     x = 0:.0003:1;
     
  %   size(x)
  %   size(y)
  %   size(ps)
  
     sm = 1e-10;
     
     Y = interp1(ps + [sm:sm:sm*length(ps)]',y,x,[],'extrap');
     
     % L = 20*ps;    
     L = x / 0.05;
 %    plot(ps,y,style,'LineWidth',1);
     plot(x,Y,style,'LineWidth',2);
     if(f_hold)
        hold;  
     end
     if(f_hold)
        %plot(ps,L,'red','LineWidth',3);     
        plot(x,L,'red','LineWidth',3);   
        axis([0  .05 0 1]);
     
        hold;  
     end