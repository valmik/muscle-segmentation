# muscle-segmentation

This code is used to segment ultrasound scans of the upper arm. Work here is done in conjunction with Berkeley's HART Lab.

The code is divided into two parts: First a Matlab script converts the .nii files into a matrix with features, and creates a training set for the machine learning algorithm. Then, an R script loads the .mat training sets and analyzes the data.

The matlab file depends on James Shen's [Tools for NifTI](https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image?requestedDomain=www.mathworks.com) package. It also depends on allcomb by Jos, though that's included in the repo.

To run the matlab code, edit SetupWorkspace.m to add the package path for the NifTI tools package as well as the filepath to your ultrasound data. Then run CreateFullSets2 after editing the volume and segmentation .nii filenames at the top, and the desired .mat file name at the bottom. Note that at the bottom, you can uncomment/uncomment the relevant line to save either a 10% sample or the full data set to the .mat file.

Most of our initial analysis was done in the RF_CART_LDA.R file, which reads in four sample data sets and tests the performance of CART trees, Linear Discriminant Analysis, and Random Forest methods.

A full segmentation was attempted in FullSegment.R.





