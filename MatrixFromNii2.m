function [output] = MatrixFromNii2(nii)
% Reslices the .nii file and saves under the newname provided
% Returns an xyz matrix of intensity or segmentation values
% If seg is true, removes all non-integer segmentation values


prefix = SetupWorkspace();

new = load_untouch_nii([prefix, nii]);

output = new.img;

end