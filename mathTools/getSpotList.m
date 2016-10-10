function corrMatrix = getSpotList(spotTemplate,expDP,threshold)
%This function extracts spots from a DP based on the template and
%threshold

corrMatrix = normxcorr2(spotTemplate,expDP);
corrMatrix(corrMatrix<threshold) = 0;

end

