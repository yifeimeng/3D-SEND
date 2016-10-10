function x = uvwRecon(exp,oneGrainDistri)
plotT = 0.01;
%initilize parameters
scanningHeight = exp.scanHeight;
scanningWidth = exp.scanWidth;
numProj = exp.numUsefulProj;
angleList = exp.angleList;
rotAxis = exp.specimenRotAxis;
%generate ray-voxel interacting matrix A
A = rayVoxelInteractTetragonal(scanningWidth, scanningHeight, angleList, numProj, rotAxis);
%group the grains and generate the observed vector b
b = oneGrainDistri;
%perform ART
itr = 10;
x0 = zeros(scanningWidth*scanningWidth*scanningHeight, 1);
options.nonneg = true;
[x, info] = kaczmarz(A, b, itr, x0, options);
%plot the distribution
%5draw3dDistri(gridSize, b, plotT);

%{
if ~isempty(x) 
    draw3dDistri(gridSize, x, plotT);
    export3DData(gridSize, x, plotT);
end
%}


end

