% Analyze modulus of Phantom on UIH
clear all
close all
clc

Nsli = 10;
%% load data and analyze
root = pwd;
phantom = {'1','2','3','4','5','6'};
rep =  {'1','2'};
for nphantom = 1:length(phantom)
    for nrep = 1:length(rep)
        cd([phantom{nphantom},'_',rep{nrep}]);
        % Mag
        cd('./Mag/')
        Mag_list = dir('*.dcm');
        for nsli = 1:length(Mag_list)
            Mag(:,:,nsli) = double(dicomread(Mag_list(nsli).name));
        end
        cd('../');
        % Modulus
        cd('./Mod_CM/');
        Mod_list = dir('*.dcm');
        for nsli = 1:length(Mod_list)
            info = dicominfo(Mod_list(nsli).name);
            Mod(:,:,nsli) = double(dicomread(Mod_list(nsli).name));
            Mod(:,:,nsli) = Mod(:,:,nsli);
        end
        % Generate mask using magnitude data
        se = strel('disk',4);
        gs_filter = fspecial('gaussian',3);
        for nsli = 1:length(Mag_list)
            mask(:,:,nsli) = gen_mask_EPIMRE_liver_auto_v2(imfilter(Mag(:,:,nsli),gs_filter),0.2);
            mask(:,:,nsli) = imerode(mask(:,:,nsli),se);
        end
        mask(mask==0) = nan;
        % extract roi and analyze
        Mod_roi = Mod.*mask;
        Mod_mean = 0;
        for nsli = 1:10
            Mod_mean = Mod_mean+nanmean(Mod_roi(:,:,nsli),'all');
        end
        Mod_mean = Mod_mean/10;
        results{nphantom,nrep*2-1} = [phantom{nphantom},'_',rep{nrep}];
        results{nphantom,nrep*2} = Mod_mean/1000;
        
%         figure;imshow(imtile(mask),[]);
        cd(root);
    end
end