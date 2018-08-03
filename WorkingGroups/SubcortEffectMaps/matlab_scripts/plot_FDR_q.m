function q = plot_FDR_q(p,style, f_hold, Q_ctrl)

    %ps = sort(p);
    ps = [0; sort(p)];     
    % y = 1/length(p):1/length(p):1;     
     y = 0:1/length(p):1;     
     q = 0;
     
     if(max(p) < Q_ctrl)
         q = Q_ctrl;
     end
     
   %  for i=2:length(ps)-1
     for i=1:length(ps)-1
         if(y(i)/ps(i) > 1/Q_ctrl && y(i+1)/ps(i+1) <= 1/Q_ctrl)
             q = ps(i);
             break;
         end
     end
     
     x = 0:.00003:1;
     
  %   size(x)
  %   size(y)
  %   size(ps)
     
     Y = interp1(ps,y,x,[],'extrap');
     
     % L = 20*ps;    
     L = x/Q_ctrl;
 %    plot(ps,y,style,'LineWidth',1);
     plot(x,Y,style,'LineWidth',2);
     if(f_hold)
        hold;  
     end
     if(f_hold)
        %plot(ps,L,'red','LineWidth',3);     
        plot(x,L,'red','LineWidth',3);   
        axis([0 Q_ctrl 0 1]);
     
        hold;  
     end