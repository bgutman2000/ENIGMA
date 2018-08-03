function [q_list, scale_list, hits, overall_scale] = print_all_hits_global(P_all, BETAS_all, model_name, out_dir)%1 - thickness, 2 - Jacobian
% 
% display(model_name);
% return

measure{1} = 'RAD';
measure{2} = 'TBM';

ROI_ids = [53,17,51,12,50,11,49,10,54,18,52,13,58,26];
ROI_vector_lengths = [2502,2502,2502,2502,2502,2502,2502,2502,1368,1368,1254,1254,930,930];
[startRAD, finishRAD, startTBM, finishTBM] = ROIs_FS2(ROI_vector_lengths, ROI_ids);


q_list = zeros(length(ROI_ids),length(measure));
scale_list =  zeros(length(ROI_ids),length(measure));

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

ROI_names{1} = 'R Hippo';
ROI_names{2} = 'L Hippo';
ROI_names{3} = 'R Putamen';
ROI_names{4} = 'L Putamen';
ROI_names{5} = 'R Caudate';
ROI_names{6} = 'L Caudate';
ROI_names{7} = 'R Thalamus';
ROI_names{8} = 'L Thalamus';
ROI_names{9} = 'R Amygdala';
ROI_names{10} = 'L Amygdala';
ROI_names{11} = 'R Pallidum';
ROI_names{12} = 'L Pallidum';
ROI_names{13} = 'R Accumbens';
ROI_names{14} = 'L Accumbens';


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

%hits{1,1} = 'null';
tot_hits = 0;

all_min(1) = 0;
all_min(2) = 0;
all_max(1) = 0;
all_max(2) = 0;


q_overall = FDR(P_all');

for RID=1:2
    
    cur_beta = [];
    all_max(RID) = 0.0;
    all_cutoff(RID) = 1e20;
    all_min_max(RID) = 1e20;

    k = 0;
    for i = 1:length(ROI_ids)
        
        roi_id = ROI_ids(i);
        
        B = zeros(finishRAD(roi_id)-startRAD(roi_id)+1,1);
        p = zeros(finishRAD(roi_id)-startRAD(roi_id)+1,1);
        
        if(RID == 1)
            p = P_all(startRAD(roi_id):finishRAD(roi_id));
            B = BETAS_all(startRAD(roi_id):finishRAD(roi_id));
        else
            p = P_all(startTBM(roi_id):finishTBM(roi_id));
            B = BETAS_all(startTBM(roi_id):finishTBM(roi_id));
        end
    
       % q_list(i,RID) = FDR(p');        
%         f_hold = 0;
        if(min(p) < q_overall)
%             sum(p < q_list(i,RID))
%             ind_names = ind_names + 1;
            tot_hits = tot_hits + 1; 
            
%             if(tot_hits == 1)
%                 f_hold = 1;
%             end
%             plot_FDR(p,style{tot_hits+1}, f_hold);
%             
%             if(tot_hits == 1)
%                 hold
%             end   
%             
%             if(ind_names == 2)
%                 names{ind_names} =  'y = 20x';
%                 ind_names = ind_names + 1;
%             end
%             
%             names{ind_names} = sprintf('%s %s p_c = %.3g', ROI_names{i},measure{RID},q_list(i,RID));
                
        end
        
    
        if(min(p) < q_overall)
            k = k + 1;
            hits{k,RID} = roi_id;
        end
        

%         base_name = sprintf('%s_betas',model_name);
%         P_name = sprintf('%s_pmap',model_name);
% 
%         if(RID == 1)
%             base_name = sprintf('%s_thick',base_name);
%             P_name = sprintf('%s_thick',P_name);
%         else
%             base_name = sprintf('%s_LogJacs',base_name);
%             P_name = sprintf('%s_LogJacs',P_name);
    

        
        for j = 1:length(B)
            betas(j) = 0;
            if(p(j) < q_overall)
               % display('hit vertex');
                betas(j)=B(j);
            end
        end
        
        cur_beta = [cur_beta abs(betas(betas~=0.0))];

%         scale_list(i,RID) = max(abs(betas));
%         cutoff = min(abs(betas(betas~=0))); %currently not used
%         
%         if(all_max < scale_list(i,RID))
%             all_max = scale_list(i,RID);
%         end
%         
%         if(all_cutoff > cutoff)
%             all_cutoff = cutoff;
%         end
%         
%          if(all_min_max > scale_list(i,RID))
%             all_min_max = scale_list(i,RID);
%         end
        
        
    end   
     
    if(length(cur_beta) > 0)
        length(cur_beta)
        sorted_beta = sort(cur_beta);
        all_min(RID) = sorted_beta(max(1,round(0.05*length(sorted_beta))));
        all_max(RID) = sorted_beta(min(length(sorted_beta),round(0.95*length(sorted_beta))));
    end
    
%         if(q_list(i,RID) > 0)
%             names{ind_names} = sprintf('%s, b = %.2g', names{ind_names},  scale_list(i,RID));
%         end
% 
%         if(q_list(i,RID) > 0)
%             write_attribute_with_mesh3(betas,base_name,roi_id,-1*scale_list(i,RID), scale_list(i,RID), scale_list(i,RID)/4, model_name);
%             write_P_with_mesh_plain3(p,P_name,roi_id,q_list(i,RID),model_name);
%         end
end

%     printf('number of hits %s: %d\n',measure{RID},k);
    




tot_hits = 0;
ind_names = 0;



for RID=1:2

    k = 0;
    for i = 1:length(ROI_ids)
        
        roi_id = ROI_ids(i);
        
        B = zeros(finishRAD(roi_id)-startRAD(roi_id)+1,1);
        p = zeros(finishRAD(roi_id)-startRAD(roi_id)+1,1);
        
        if(RID == 1)
            p = P_all(startRAD(roi_id):finishRAD(roi_id));
            B = BETAS_all(startRAD(roi_id):finishRAD(roi_id));
        else
            p = P_all(startTBM(roi_id):finishTBM(roi_id));
            B = BETAS_all(startTBM(roi_id):finishTBM(roi_id));
        end
    
   %     q_list(i,RID) = FDR(p');        
        f_hold = 0;
        if(min(p) < q_overall)
            sum(p < q_overall)
            ind_names = ind_names + 1;
            tot_hits = tot_hits + 1; 
            
            if(tot_hits == 1)
                f_hold = 1;
            end
            plot_FDR(p',style{tot_hits+1}, f_hold);
            
            if(tot_hits == 1)
                hold
            end   
            
            if(ind_names == 2)
                names{ind_names} =  'y = 20x';  
                names{ind_names} = sprintf('%s; P_c = %.2g',names{ind_names}, q_overall);
                for rrID = 1:2
                    names{ind_names} = sprintf('%s; B_{%s} = [%.2g , %.2g]',names{ind_names}, measure{rrID}, all_min(rrID), all_max(rrID) );
                end
                
                ind_names = ind_names + 1;
            end
            
            names{ind_names} = sprintf('%s %s p_c = %.3g', ROI_names{i},measure{RID},q_overall);%q_list(i,RID));
                
        end
        
    
        if(min(p) < q_overall)
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

        
        for j = 1:length(B)
            betas(j) = 0;
            if(p(j) < q_overall)
               % display('hit vertex');
                betas(j)=B(j);
                
                if(abs(betas(j)) < all_min(RID))
                   betas(j) = sign(betas(j))* all_min(RID);
                end
            end
        end

        scale_list(i,RID) = max(abs(betas));
        cutoff = min(abs(betas(betas~=0))); %currently not used
        
        if(min(p) < q_overall)
            names{ind_names} = sprintf('%s, b = %.2g', names{ind_names},  scale_list(i,RID));
        end

        if(min(p) < q_overall)
        %    write_attribute_with_mesh3(betas,base_name,roi_id,-1*scale_list(i,RID), all_max(RID), all_min(RID), model_name);
          write_attribute_with_mesh_gen(betas,base_name,roi_id,-1*all_max(RID), all_max(RID), all_min(RID), model_name, out_dir);
       %  write_attribute_with_mesh3(betas,base_name,roi_id,-1*all_max(RID), all_max(RID),0.99* all_max(RID), model_name);
            write_P_with_mesh_plain_gen(p,P_name,roi_id,q_overall,model_name, out_dir);
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


%to_save = out_dir;

to_save = sprintf('%s\\%s',out_dir,model_name);

if(tot_hits > 0)
    title(model_name_title,'FontSize',16);
    xlabel('Observed P-value','FontSize',14);
    ylabel('Cumulative P-value','FontSize',14);
    legend(names);
    %saveas( gcf, model_name, 'fig' );
    saveas( gcf, to_save, 'fig' );
    hold
end







    
    
    
    
    