# muscle-segmentation

This code is used to segment ultrasound scans of the upper arm. Work here is done in conjunction with Berkeley's HART Lab.

The code is divided into two parts: First a Matlab script converts the .nii files into a matrix with features, and creates a training set for the machine learning algorithm. Then, an R script loads the .mat training sets and analyzes the data.

The .mat file depends on James Shen's [Tools for NifTI](https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image?requestedDomain=www.mathworks.com) package. It also depends on allcomb by Jos, though that's included in the repo.

To run the code, edit SetupWorkspace.m to add the package path for the NifTI tools package as well as the filepath to your ultrasound data. Then run CreateFullSets2 after editing the volume and segmentation .nii filenames at the top, and the desired .mat file name at the bottom.




