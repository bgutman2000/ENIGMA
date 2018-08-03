function color = hot_cold( val,  epsilon_p,  epsilon_m, max_, min_, r_bg,  g_bg,  b_bg)

full_range = 1;

t = val;
epsilon_minus = epsilon_m;
epsilon_plus = epsilon_p;

if(full_range)
    if (val > 0.0)
        t = (val - epsilon_p) / (max_-epsilon_p);
        if (t < 0.0) 
            t = 0.0;
        end
    end
    if (val < 0.0)
        t = (-1.0)*(val - epsilon_m) / (min_-epsilon_m);
        if (t > 0.0) 
            t = 0.0;
        end
    end
    
    epsilon_minus = -1e-20;
    epsilon_plus = 1e-20;
end
    
     color = [0, 0, 0];  
     if(t <= epsilon_plus && t >= epsilon_minus)
        color = [r_bg, g_bg, b_bg];    
    else
        if(t > epsilon_plus)

             color(1) = 0.25 + t*0.75;

             if(t > 0.5 && t <= 0.75)
 %           if(t > 0.5 & t <= 0.75)
                 color(2) = 3.25*(t-0.5);
            end
            if(t > 0.75)

                color(2) = color(1);
                 color(3) = 4.0*(t-0.75);
            end
        else

            t = t*(-1.0);
            if(t < 0.5)
            %	color(3) = 0.25 + 0.375*t;			 % %also, shouldn't this be 	color(3) = 0.25 + 1.5*t;	
                 color(3) = 0.25 + 1.5*t;			 % %also, shouldn't this be 	color(3) = 0.25 + 1.5*t;
            end
            if(t >= 0.5)

                color(2) = (t-0.5)*2.0;
                color(3) = 1.0 - color(2);
            end
        end
    end
    
    if(t > 1.0)
		color = [1.0,1.0,1.0];
    end

	if(t > 1.0 && val < 0)
		color = [0.0,1.0,0.0];
    end


