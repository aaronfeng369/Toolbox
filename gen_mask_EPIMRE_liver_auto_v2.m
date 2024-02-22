% To automatically generate a mask for MRE unwrapping or display 
% Input:
% img--the complex image (3D)
% L--threshhold to separate background and tissue
% Output:
% maskDouble--mask,background=0
% maskNaN--mask,background=NaN
function [maskDouble,maskNaN] = gen_mask_EPIMRE_liver_auto_v2(img,L)
try
    img = abs(img);
    img = mat2gray(img);
    mask = zeros(size(img));
    for ii = 1:size(img,3)
%         mask(:,:,ii) = im2bw(imadjust(squeeze(img(:,:,ii))),L);
        mask(:,:,ii) = im2bw((squeeze(img(:,:,ii))),L);
    end
    L1 = bwlabeln(mask,6);
    L1(L1~=1) = 0;
    L2 = bwlabeln(L1,26);
    L2(L2~=1) = 0;
    idx = find(L2 > 0);
    [x,y,z] = ind2sub(size(img),idx);
    x1 = min(x(:)); x2 = max(x(:));
    y1 = min(y(:)); y2 = max(y(:));
    z1 = min(z(:)); z2 = max(z(:));
    img = L2(x1:x2,y1:y2,z1:z2);
    L2(x1:x2,y1:y2,z1:z2) = cell2mat(regionprops3(img,'ConvexImage').ConvexImage);
    
    maskDouble = L2;
    maskNaN = maskDouble;
    maskNaN(maskNaN==0) = NaN;
catch ME
    maskDouble = zeros(size(img));
    maskNaN = zeros(size(img));
    return;
end
end