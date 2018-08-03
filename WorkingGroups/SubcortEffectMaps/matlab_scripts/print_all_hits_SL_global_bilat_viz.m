function [q_list, scale_list, hits, overall_scale, area_list, mean_pos_beta_list, mean_neg_beta_list, ROI_names] = ...
    print_all_hits_SL_global_bilat_viz(P_all, BETAS_all, model_name, fig_finish, ns_roi_color, out_dir)%1 - thickness, 2 - Jacobian
% 
% display(model_name);
% return
mkdir_str1 = sprintf('mkdir %s',out_dir);
system(mkdir_str1);
  
Q_ctrl = 0.05;

measure{1} = 'RAD';
measure{2} = 'TBM';

ROI_ids = [53,17,51,12,50,11,49,10,54,18,52,13,58,26];
ROI_vector_lengths = [2502,2502,2502,2502,2502,2502,2502,2502,1368,1368,1254,1254,930,930];
[startRAD, finishRAD, startTBM, finishTBM] = ROIs_FS2(ROI_vector_lengths, ROI_ids);


ROI_ids_ord = [53,51,50,49,54,52,58,17,12,11,10,18,13,26];
ROI_vector_lengths_ord = [2502,2502,2502,2502,1368,1254,930,2502,2502,2502,2502,1368,1254,930];
[startRAD_ord, finishRAD_ord, startTBM_ord, finishTBM_ord] = ROIs_FS2(ROI_vector_lengths_ord, ROI_ids_ord);


q_list = zeros(length(ROI_ids),length(measure));
scale_list =  zeros(length(ROI_ids),length(measure));

area_list = zeros(length(ROI_ids),2);
mean_pos_beta_list = zeros(length(ROI_ids),2);
mean_neg_beta_list = zeros(length(ROI_ids),2);

hits{1,2}='';

% length(ROI_ids)
% return


%          b     blue          .     point              -     solid
%          g     green         o     circle             :     dotted
%          r     red           x     x-mark             -.    dashdot 
%          c     cyan          +     plus               --    dashed   
%          m     magenta       *     star             (none)  no line
%          y     yellow        s     square
%          k     black         d     diamond
%          w     white         v     triangle (down)
%                              ^     triangle (up)
%                              <     triangle (left)
%                              >     triangle (right)
%                              p     pentagram
%                              h     hexagram


color = {'b','g','c','m','y','b'};
point = {'o','x','+','*','s','d','v','^','<','>','p','h'};
inter = {'-',':','--'};

ROI_names{1} = 'Mean Hippo';
ROI_names{2} = 'Mean Putamen';
ROI_names{3} = 'Mean Caudate';
ROI_names{4} = 'Mean Thalamus';
ROI_names{5} = 'Mean Amygdala';
ROI_names{6} = 'Mean Pallidum';
ROI_names{7} = 'Mean Accumbens';
ROI_names{8} = 'Asym Hippo';
ROI_names{9} = 'Asym Putamen';
ROI_names{10} = 'Asym Caudate';
ROI_names{11} = 'Asym Thalamus';
ROI_names{12} = 'Asym Amygdala';
ROI_names{13} = 'Asym Pallidum';
ROI_names{14} = 'Asym Accumbens';

split_model_name = strsplit_Boris(model_name,'_');
model_name_title = split_model_name{1};

if(length(split_model_name) > 1)
    for i=2:length(split_model_name)
        model_name_title = sprintf('%s %s',model_name_title, split_model_name{i});
    end
end
    
    
%j = 1;
for k=1:3
    for j=1:12
        for i=1:6
                        
            ind = (k-1)*72 + (j-1)*6 + i;
            style{ind} = sprintf('%s%s%s',color{i},point{j},inter{k});
        end
    end
end

mult = 10000;

loc_area = (get_atlas_area(ROI_ids_ord(1))+get_atlas_area(ROI_ids_ord(8)))/2;
area = [loc_area; loc_area];

loc_coords1 = get_atlas_coords(ROI_ids_ord(1));
coords1 = [mult + loc_coords1; 2*mult + loc_coords1 ];

loc_coords2 = get_atlas_coords(ROI_ids_ord(8));
coords2 = [mult + loc_coords2; 2*mult + loc_coords2 ];

for i=2:7      
    loc_coords1 = get_atlas_coords(ROI_ids_ord(i));
    coords1 = [coords1; [(2*i-1)*mult + loc_coords1; (2*i)*mult + loc_coords1 ]];
    
    loc_coords2 = get_atlas_coords(ROI_ids_ord(i+7));
    coords2 = [coords2; [(2*i-1)*mult + loc_coords2; (2*i)*mult + loc_coords2 ]];
    
    loc_area = (get_atlas_area(ROI_ids_ord(i))+get_atlas_area(ROI_ids_ord(i+7)))/2;
    area = [area; loc_area; loc_area];
end


for i=1:14
     roi_id = ROI_ids(i);
     P_ord(startRAD_ord(roi_id):finishRAD_ord(roi_id)) = P_all(startRAD(roi_id):finishRAD(roi_id));
     P_ord(startTBM_ord(roi_id):finishTBM_ord(roi_id)) = P_all(startTBM(roi_id):finishTBM(roi_id));
end
    
%size(P_ord(1,1:size(P_ord,2)/2))
%size(P_ord(1, size(P_ord,2)/2 + 1 : size(P_ord,2)))
    
M = logical(ones([size(P_all,1) size(P_all,2)/2])); 
%size(M)
%size(coords1)
%size(coords2)

FDRmap_1 = LangersSearchlightFDR_BG(P_ord(1,1:size(P_ord,2)/2)',M',coords1,6,9,2);
FDRmap_2 = LangersSearchlightFDR_BG(P_ord(1, size(P_ord,2)/2 + 1 : size(P_ord,2))',M',coords2,6,9,2);


FDRmap_ord = [FDRmap_1; FDRmap_2];

%size(FDRmap_ord)

for i=1:14
     roi_id = ROI_ids(i);
     FDRmap_all(startRAD(roi_id):finishRAD(roi_id)) = FDRmap_ord(startRAD_ord(roi_id):finishRAD_ord(roi_id));
     FDRmap_all(startTBM(roi_id):finishTBM(roi_id)) = FDRmap_ord(startTBM_ord(roi_id):finishTBM_ord(roi_id));
end

%hits{1,1} = 'null';
tot_hits = 0;

all_min_Mean(1) = 0;
all_min_Mean(2) = 0;
all_max_Mean(1) = 0;
all_max_Mean(2) = 0;

all_min_Asym(1) = 0;
all_min_Asym(2) = 0;
all_max_Asym(1) = 0;
all_max_Asym(2) = 0;


for RID=1:2
    
    cur_beta = [];
    all_max_Mean(RID) = 0.0;
    all_max_Asym(RID) = 0.0;
    

    k = 0;
    for i = 1:length(ROI_ids_ord)/2
        
        roi_id = ROI_ids_ord(i);
        
        B = zeros(finishRAD(roi_id)-startRAD(roi_id)+1,1);
        FDRmap = zeros(finishRAD(roi_id)-startRAD(roi_id)+1,1);
        
        if(RID == 1)
            FDRmap = FDRmap_all(startRAD(roi_id):finishRAD(roi_id));
            B = BETAS_all(startRAD(roi_id):finishRAD(roi_id));
        else
            FDRmap = FDRmap_all(startTBM(roi_id):finishTBM(roi_id));
            B = BETAS_all(startTBM(roi_id):finishTBM(roi_id));
        end
                
        q_list(i,RID) = double(min(FDRmap) < Q_ctrl)*Q_ctrl;
        if(q_list(i,RID) > 0)
            tot_hits = tot_hits + 1; 
        end
            
        if(q_list(i,RID) > 0)
            k = k + 1;
            hits{k,RID} = roi_id;
        end
          
        for j = 1:length(B)
            betas(j) = 0;
            if(FDRmap(j) < q_list(i,RID))
                betas(j)=B(j);
            end
        end
        
        cur_beta = [cur_beta abs(betas(betas~=0.0))];
       
        
    end   
     
    if(length(cur_beta) > 0)
        length(cur_beta)
        sorted_beta = sort(cur_beta);
        all_min_Mean(RID) = sorted_beta(max(1,round(0.05*length(sorted_beta))));
        all_max_Mean(RID) = sorted_beta(min(length(sorted_beta),round(0.95*length(sorted_beta))));
    end
    printf('number of mean hits %s: %d\n',measure{RID},k);
    
    cur_beta = [];
    for i = length(ROI_ids_ord)/2+1:length(ROI_ids_ord)
        
        roi_id = ROI_ids_ord(i);
        
        B = zeros(finishRAD(roi_id)-startRAD(roi_id)+1,1);
        FDRmap = zeros(finishRAD(roi_id)-startRAD(roi_id)+1,1);
        
        if(RID == 1)
            FDRmap = FDRmap_all(startRAD(roi_id):finishRAD(roi_id));
            B = BETAS_all(startRAD(roi_id):finishRAD(roi_id));
        else
            FDRmap = FDRmap_all(startTBM(roi_id):finishTBM(roi_id));
            B = BETAS_all(startTBM(roi_id):finishTBM(roi_id));
        end
                
        q_list(i,RID) = double(min(FDRmap) < Q_ctrl)*Q_ctrl;
        if(q_list(i,RID) > 0)
            tot_hits = tot_hits + 1; 
        end
            
        if(q_list(i,RID) > 0)
            k = k + 1;
            hits{k,RID} = roi_id;
        end
          
        for j = 1:length(B)
            betas(j) = 0;
            if(FDRmap(j) < q_list(i,RID))
                betas(j)=B(j);
            end
        end
        
        cur_beta = [cur_beta abs(betas(betas~=0.0))];
       
        
    end   
     
    if(length(cur_beta) > 0)
        length(cur_beta)
        sorted_beta = sort(cur_beta);
        all_min_Asym(RID) = sorted_beta(max(1,round(0.05*length(sorted_beta))));
        all_max_Asym(RID) = sorted_beta(min(length(sorted_beta),round(0.95*length(sorted_beta))));
    end
    printf('number of mean and symmetry hits %s: %d\n',measure{RID},k);
    
    
end




for ind_bilat=0:1
    
  all_max = zeros(2,1);
  all_min = zeros(2,1);
  tot_hits = 0;
  ind_names = 0;
  
  Betas_fig = cell(2,length(ROI_ids));
  betas_cmap = zeros(2,2*sum(ROI_vector_lengths)); %to get an estimate of max and min beta values
  
  bilat_type = 'bilateral_mean';
  if(ind_bilat == 1)
      bilat_type = 'asymmetry';
  end

  for RID=1:2
      
    all_max(RID) = all_max_Mean(RID);
    all_min(RID) = all_min_Mean(RID);

    if(ind_bilat == 1)
        all_max(RID) = all_max_Asym(RID);
        all_min(RID) = all_min_Asym(RID);
    end
    if(all_min(RID) == all_max(RID))
        all_min(RID) = 0.1*all_max(RID);
    end
    
  end
  
  for RID=1:2
    k = 0;
    for i = ind_bilat*length(ROI_ids_ord)/2 + 1:(ind_bilat+1)*length(ROI_ids_ord)/2
        
        roi_id = ROI_ids_ord(i);
        roi_id2 = ROI_ids_ord(i-7*ind_bilat);
        
        B = zeros(finishRAD(roi_id)-startRAD(roi_id)+1,1);
        FDRmap = zeros(finishRAD(roi_id)-startRAD(roi_id)+1,1);
        
        if(RID == 1)
            FDRmap = FDRmap_all(startRAD(roi_id):finishRAD(roi_id))';
            B = BETAS_all(startRAD(roi_id):finishRAD(roi_id));
        else
            FDRmap = FDRmap_all(startTBM(roi_id):finishTBM(roi_id))';
            B = BETAS_all(startTBM(roi_id):finishTBM(roi_id));
        end
                
        q_list(i,RID) = double(min(FDRmap) < Q_ctrl)*Q_ctrl;
        
        ind_sig = (FDRmap < q_list(i,RID));
        ind_sig_pos = ind_sig.*(B > 0)';
        ind_sig_neg = ind_sig.*(B < 0)';
               
        if(RID == 1)
           loc_area2  = area(startRAD_ord(roi_id2):finishRAD_ord(roi_id2));
        else
           loc_area2  = area(startTBM_ord(roi_id2):finishTBM_ord(roi_id2)); 
        end
           
        area_list(i,RID) = loc_area2'*ind_sig/sum(loc_area2);
        mean_pos_beta_list(i,RID) = (loc_area2.*ind_sig_pos)'*B'/(loc_area2'*ind_sig_pos + 1e-10);
        mean_neg_beta_list(i,RID) = (loc_area2.*ind_sig_neg)'*B'/(loc_area2'*ind_sig_neg + 1e-10);
  
        f_hold = 0;
        if(q_list(i,RID) > 0)
            sum(FDRmap < q_list(i,RID))
            ind_names = ind_names + 1;
            tot_hits = tot_hits + 1; 
            
            if(tot_hits == 1)
                f_hold = 1;
            end
            plot_FDR_SL(FDRmap,style{tot_hits+1}, f_hold);
            
            if(tot_hits == 1)
                hold
            end   
            
            if(ind_names == 2)
                names{ind_names} =  'y = 20x';                
                for rrID = 1:2
                    names{ind_names} = sprintf('%s; B_{%s} = [%.2g , %.2g]',names{ind_names}, measure{rrID}, all_min(rrID), all_max(rrID) );
                end
                
                ind_names = ind_names + 1;
            end
            
            names{ind_names} = sprintf('%s %s p_c = %.3g', ROI_names{i},measure{RID},q_list(i,RID));
                
        end
        
    
        if(q_list(i,RID) > 0)
            k = k + 1;
            hits{k,RID} = roi_id;
        end
        

        base_name = sprintf('%s_betas',model_name);
        P_name = sprintf('%s_pmap',model_name);

        if(RID == 1)
            base_name = sprintf('%s_thick',base_name);
            P_name = sprintf('%s_thick',P_name);
        else
            base_name = sprintf('%s_LogJacs',base_name);
            P_name = sprintf('%s_LogJacs',P_name);
        end

        clear betas
        for j = 1:length(B)
            betas(j) = 0;
            if(FDRmap(j) < q_list(i,RID))
               % display('hit vertex');
                betas(j)=B(j);
                
                if(abs(betas(j)) < all_min(RID))
                   betas(j) = sign(betas(j))* all_min(RID);
                end
            end
        end

        scale_list(i,RID) = max(abs(betas));
        cutoff = min(abs(betas(betas~=0))); %currently not used
        
        if(q_list(i,RID) > 0)
            names{ind_names} = sprintf('%s, b = %.2g', names{ind_names},  scale_list(i,RID));
        end
        
        if(q_list(i,RID) > 0 || ns_roi_color == 2)
            betas(betas==0) = sign(B(betas==0)).*all_min(RID)/2;
        end

        Betas_fig{RID,i} = min(all_max(RID),max(-1.0*all_max(RID),betas));
         
        if(q_list(i,RID) > 0)
            if RID == 1
                betas_cmap(RID,startRAD(roi_id):finishRAD(roi_id)) = Betas_fig{RID,i};
            else
                betas_cmap(RID,startTBM(roi_id):finishTBM(roi_id)) = Betas_fig{RID,i};
            end 
          write_attribute_with_mesh_gen(betas,base_name,roi_id,-1*all_max(RID), all_max(RID), all_min(RID), model_name, out_dir);
          write_P_with_mesh_plain_gen(FDRmap',P_name,roi_id,q_list(i,RID),model_name, out_dir);
        end
    end

    printf('number of hits %s: %d\n',measure{RID},k);
    
  end

  overall_scale = [];

  if(tot_hits > 0)
    overall_scale{1} = all_min;
    overall_scale{2} = all_max;
  end


  printf('total number of hits: %d\n',tot_hits);

  to_save = fullfile(out_dir,sprintf('%s_%s',model_name,bilat_type));

  col_bar_res = 512;

  if(tot_hits > 0)
    title(model_name_title,'FontSize',16);
    xlabel('Observed Q-value','FontSize',14);
    ylabel('Cumulative P-value','FontSize',14);
    legend(names);
    %saveas( gcf, model_name, 'fig' );
    saveas( gcf, to_save, 'fig' );
    hold
    
    maps_dir = fullfile(out_dir,'map_images',model_name);
    mkdir_str1 = sprintf('mkdir %s',maps_dir);
    system(mkdir_str1);

    for RID = 1:2
      if(max(q_list(:,RID)) > 0)

        % create custom colormap lookup table
        %val,  epsilon_p,  epsilon_m, max_, min_, r_bg,  g_bg,  b_bg
        %val = eg. beta value,  -epsilon_p = epsilon_m = 5th percentile,
        %max_ = -min_ = 95th percentile, (r_bg,  g_bg, b_bg)=(0.5,0.5,0.5)
        color_map_var = [all_min(RID), -all_min(RID), all_max(RID), -all_max(RID), 0.5, 0.5, 0.5];
        color_map_lookup = create_lookup_colormap(min(betas_cmap(RID,:)),max(betas_cmap(RID,:)), color_map_var);%, col_bar_res, min(q_list(ind_bilat*7+1:(ind_bilat+1)*7,RID)) == 0);
        
      %  NS_val = (min(betas_cmap(RID,:)) + 2.0*(min(betas_cmap(RID,:))-max(betas_cmap(RID,:)))/col_bar_res);
        %beta value for totally non-significant ROIs for coloring differently

        %straight view
        view = 1;
        figure;

        
        for i = ind_bilat*length(ROI_ids_ord)/2 + 1:(ind_bilat+1)*length(ROI_ids_ord)/2
            if(q_list(i,RID) == 0 && ns_roi_color == 1)
                Betas_fig{RID,i} = zeros(size(Betas_fig{RID,i}));%0;%ones(size(Betas_fig{RID,i}))*NS_val;
            end
                
            make_beta_maps(Betas_fig{RID,i}, ROI_ids_ord(i), view, color_map_lookup, fig_finish)
            hold on;
        end
        
        colorbar('FontSize',24);
        hold off;
        camlight headlight;
        hold off;
        title(measure{RID});
        fig_name = sprintf('%s_%s_%s', model_name, bilat_type, measure{RID});
        saveas( gcf, fullfile(maps_dir, fig_name), 'fig' );
     
        fig = gcf;
        set(fig, 'PaperUnits', 'points', 'PaperPosition', [0, 0, 656, 984]);
        print(fig,sprintf('%s.bmp',fullfile(maps_dir,fig_name)),'-dbmp','-r0');
 
        %mirror view
        view = -1;
        figure;
        for i = ind_bilat*length(ROI_ids_ord)/2 + 1:(ind_bilat+1)*length(ROI_ids_ord)/2
            make_beta_maps(Betas_fig{RID,i}, ROI_ids_ord(i), view, color_map_lookup, fig_finish)
            hold on;
        end
        
        colorbar('FontSize',24);        
        hold off;
        camlight headlight;
        hold off;
        title_str = sprintf('%s mirror',measure{RID});
        title(title_str);
        fig_name = sprintf('%s_%s_%s_mirror', model_name, bilat_type, measure{RID});
        saveas( gcf, fullfile(maps_dir, fig_name), 'fig' );
      
        fig = gcf;
        set(fig, 'PaperUnits', 'points', 'PaperPosition', [0, 0, 656, 984]);
        print(fig,sprintf('%s.bmp',fullfile(maps_dir,fig_name)),'-dbmp','-r0');
 
      end    
    end
    
    close all
  end
  
end







    
    
    
    
    