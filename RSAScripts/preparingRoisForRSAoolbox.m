% Use the same script as for the TDT toolbox
% The error message means that TDT does not know how to relate your betas to
% the ROI images. TDT doesn't do any interpolation, but assumes all images
% have the same rotation and the same voxel dimensions.
% 
% Check the dimensionality of your ROI images and beta_0017.img using
% [BB,vx] = spm_get_bbox(V);
% 
% where V is the header loaded with spm_vol('beta_0017.img') or
% spm_vol('yourroi.img')
% 
% Then you can use the bounding box of the beta image to adjust your ROI using
% http://www0.cs.ucl.ac.uk/staff/g.ridgway/vbm/resize_img.m
% 
% Best is to check if the ROI is still in the right location afterwards.


%% get one example beta file to get the correct bounding box and voxel dimensions (are the same for all subjects)
Vbeta = spm_vol('C:\Users\penv395\Desktop\transMem\fMRI_study\Results\fMRI\DATA\Control\Pic_Recog\VP34\modelMVPANorm\beta_0002.nii');
[BB,vx] = spm_get_bbox(Vbeta);

%% get all the rois
folderROIs = 'C:\Users\penv395\Desktop\transMem\fMRI_study\Results\fMRI\SCRIPTS\Masken\ROIS_RSA_Analysis\';
Rois = dir(folderROIs);
Rois = Rois(3:end);
Roi_files = {};
for r = 1: size(Rois,1)
    Roi_files = [Roi_files, [folderROIs,Rois(r).name]];
end

for r = 1: size(Roi_files, 2)
    resize_img(Roi_files{r}, abs(vx), BB)
end

