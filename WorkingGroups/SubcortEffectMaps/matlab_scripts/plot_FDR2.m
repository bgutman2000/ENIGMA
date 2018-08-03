function q = plot_FDR2(p,style, f_hold)


    ps = sort(p);     
     y = 1/length(p):1/length(p):1;     
     q = 0;
     
     if(max(p) < 0.05)
         q = 0.05;
     end
     
     for i=2:length(ps)-1
         if(y(i)/ps(i) > 20 && y(i+1)/ps(i+1) <= 20)
             q = ps(i);
             break;
         end
     end
     
     x = 1/length(ps):1/length(ps):1;
  %   x = 0:.0003:1;
     
  %   size(x)
  %   size(y)
  %   size(ps)
     
  %   Y = interp1(ps,y,x,[],'extrap');
     
     % L = 20*ps;    
     L = 20*ps;
 %    plot(ps,y,style,'LineWidth',1);
     plot(ps,x,style,'LineWidth',2);
     if(f_hold)
        hold;  
     end
     if(f_hold)
        %plot(ps,L,'red','LineWidth',3);     
        plot(ps,L,'red','LineWidth',3);   
        axis([0 .05 0 1]);
     
        hold;  
     end