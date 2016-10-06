# 3D-SEND
3D-SEND is a TEM 3D orientaion mapping technique that acquires nano-grains' 3D morphologies and orientations through scanning electron nanobeam diffraction. Details about this technique can be found in our publication "Meng, Y. & Zuo, J.-M. (2016). IUCrJ 3, 300-308". 
## Installation
We recommend to run all the codes on a 64 bit MATLAB with a version number later than R2012b. Copy the .m files into your working directory and add all subfolders to the path. Due to the size limitation of the repository, we do not provide sample data set here. Sample tomographic SEND data set can be provided upon request.
## Input images and output plotting
The default input files are .dm3, which is read by the script developed by F. Sigworth. Other formats are compatible too by modifying the input part of the codes. 2D image is read as 2D matrix. Image stack is read as 3D matrix (n\*m\*r), where r is the number of slices.
Processing results are displayed using the plotting functions in MATLAB.
## Features
The data processing in 3D-SEND includes the following building blocks: (1) diffraction peak identification, (2) generation of virtual dark-field images, (3) cluster analysis of dark-field images, (4) 2D morphology identifiaction, (5) 3D reconstruction, (6) spot diffractino patern indexing, (7) orientation determination. (1)(2)(3)(5)(7) are fully automatic. (4) is manual. (6) is semi-automatic.  
