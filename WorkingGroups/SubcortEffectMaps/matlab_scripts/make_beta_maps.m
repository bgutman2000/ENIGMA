function make_beta_maps(betas, roi_id, view, color_map_lookup, fig_finish) 
%
% function make_beta_maps(betas, roi_id, view, color_map_lookup)
% betas - beta values
% roi_id - not in use as of now
% view - set as straight view or mirror view
% color_map_lookup - RGB lookup table
% 
% using the shape atlas files to show the beta maps
% spreading them to view all ROIs 
% FS has left ROIs on right and vice versa, code changes that
%
%  (C) 2017. Anjanibhargavi Ragothaman  aragotha@loni.usc.edu
% Last update March 10, 2017.
AXES = [1,1,1,1,1,1,1,1,1,-0.402163064104136,-0.105076973476408,-0.287186604101499,-0.471527848576560,1,1,1,-0.0203229377590604,0.607368499546018,1,1,1,1,1,1,1,0.147016053920688,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.376147378221815,0.141339376808721,0.320462936074349,0.521268469811576,-0.0623740182706436,-0.415034093674185,1,1,1,-0.189340584825704;1,1,1,1,1,1,1,1,1,-0.307161919898957,0.228797148724548,-0.121028581759313,-0.197404413045417,1,1,1,0.330671655948847,0.582055804024673,1,1,1,1,1,1,1,-0.683556504704401,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,-0.302008624469363,0.214086149815058,-0.141272047851049,-0.236320027894391,0.363633038972131,0.633546056921917,1,1,1,-0.546228342589648;1,1,1,1,1,1,1,1,1,0.862505898434532,0.967786492146153,0.950197840884717,0.859472504346099,1,1,1,0.943527018242132,0.540661212554046,1,1,1,1,1,1,1,0.714938308363660,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0.875958869241574,0.966535204232462,0.936667344951546,0.820019528301791,0.929451717311161,0.652967146835688,1,1,1,0.815956335038602];
z_ax = [0,1,0]';
y_ax = [0,0,1]';

filename = sprintf('C:\\Users\\bgutm\\Documents\\MATLAB\\Test_for_grad_students\\atlas\\atlas_%d.off',roi_id);
[vertex,face] = read_off(filename);

fv.vertices = vertex';
fv.faces = face';

%Move all left ROIs by 5mm
if (roi_id < 27)
    fv.vertices = [fv.vertices(:,1)+5 fv.vertices(:,2) fv.vertices(:,3)];
end
%Caudate
if (roi_id == 11 || roi_id == 50)
    fv.vertices = [fv.vertices(:,1) fv.vertices(:,2) fv.vertices(:,3)+25];
end
if (roi_id == 11)        
    res = rotate_verts(fv.vertices,AXES(:,roi_id),pi/7);
    res = rotate_verts(res,z_ax,-pi/20);
    fv.vertices = [res(:,1) res(:,2) res(:,3)-5];
end
if (roi_id == 50)        
    res = rotate_verts(fv.vertices,AXES(:,roi_id),-pi/7);
    res = rotate_verts(res,z_ax,pi/20);
    fv.vertices = [res(:,1) res(:,2) res(:,3)-5];
end
%Accumbens
if (roi_id == 26)
    fv.vertices = [fv.vertices(:,1)-2 fv.vertices(:,2) fv.vertices(:,3)+40];
    res = rotate_verts(fv.vertices,y_ax,-pi/10);
    fv.vertices = [res(:,1) res(:,2) res(:,3)];
end
if (roi_id == 58)
    fv.vertices = [fv.vertices(:,1)+2 fv.vertices(:,2) fv.vertices(:,3)+40];
    res = rotate_verts(fv.vertices,y_ax,pi/10);
    fv.vertices = [res(:,1) res(:,2) res(:,3)];
end
%Pallidum
if (roi_id == 13)
    fv.vertices = [fv.vertices(:,1)+10 fv.vertices(:,2) fv.vertices(:,3)+40];
end
if (roi_id == 52)
    fv.vertices = [fv.vertices(:,1)-10 fv.vertices(:,2) fv.vertices(:,3)+40];
end
%Putamen
if (roi_id == 12)    
    fv.vertices = [fv.vertices(:,1)+20 fv.vertices(:,2) fv.vertices(:,3)+45];
    res = rotate_verts(fv.vertices,AXES(:,roi_id),pi/3);
    fv.vertices = [res(:,1) res(:,2) res(:,3)];
end
if (roi_id == 51)
    fv.vertices = [fv.vertices(:,1)-20 fv.vertices(:,2) fv.vertices(:,3)+45];
    res = rotate_verts(fv.vertices,AXES(:,roi_id),-pi/3);
    fv.vertices = [res(:,1) res(:,2) res(:,3)];
end
%Hippocampus
if (roi_id == 17)
    fv.vertices = [fv.vertices(:,1)+15 fv.vertices(:,2) fv.vertices(:,3)];
end
if (roi_id == 53)
    fv.vertices = [fv.vertices(:,1)-15 fv.vertices(:,2) fv.vertices(:,3)];
end
%Amygdala
 if (roi_id == 18)
    fv.vertices = [fv.vertices(:,1)+15 fv.vertices(:,2) fv.vertices(:,3)+10];
end
if (roi_id == 54)
    fv.vertices = [fv.vertices(:,1)-15 fv.vertices(:,2) fv.vertices(:,3)+10];
end

% Make right ROIs on right side and left ROIs on left side
fv.vertices = [(-1)*fv.vertices(:,1) fv.vertices(:,2) fv.vertices(:,3)];

if (view == -1)
     fv.vertices = [view*fv.vertices(:,1) view*fv.vertices(:,2) fv.vertices(:,3)];
end

figure_trimesh(fv,betas,roi_id, 'custom',color_map_lookup, fig_finish);
% figure_trimesh(fv,betas,roi_id);
%figure_trimesh(fv,betas,roi_id, 'ryw',color_map_var);
% hold on;

end
