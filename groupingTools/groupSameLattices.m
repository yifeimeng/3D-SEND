function [root, rootAux] = groupSameLattices(combinedInfo, scanningHeight, scanningWidth)
%This function uses the combinedInfo to do a comprehensive grouping of same
%lattices. 

numDP = length(combinedInfo);

%initialize the DFMap. Set the value to -1 for no lattices. Set the value
%to 0 for ungrouped lattice. Other values for grouped lattices.
minimumPeakNum = 5;
threshold = 0.3;% the threshold to determine DF similarity

maxNumLattices = 0;
for i=1:1:numDP
    currNumLattices = combinedInfo(i).numSDP;
    if currNumLattices > maxNumLattices
        maxNumLattices = currNumLattices;
    end
    
end

root = zeros(numDP,maxNumLattices);
rootAux = zeros(numDP,maxNumLattices);



for i=1:1:numDP-1
    currNumLattices = combinedInfo(i).numSDP;
    for ii=1:1:currNumLattices
        currDFNumPeaks = size(combinedInfo(i).SDP{ii},1);
        currDF = squeeze(combinedInfo(i).SDF(ii,:,:));
        
        if currDFNumPeaks >= minimumPeakNum
          for j=i+1:1:numDP
            targetDFNumLattices = size(combinedInfo(j).numSDP);
            for jj=1:1:targetDFNumLattices
                targetDFNumPeaks = size(combinedInfo(j).SDP{jj},1);
                targetDF = squeeze(combinedInfo(j).SDF(jj,:,:));
                
                if targetDFNumPeaks >= minimumPeakNum
                    corrMatrix = normxcorr2(currDF, targetDF);
                    corrFactor = corrMatrix(scanningHeight, scanningWidth);%!!!
                    if corrFactor>=threshold
                        if root(i,ii) == 0 && rootAux(i,ii) == 0
                            root(j,jj) = i;
                            rootAux(j,jj) = ii;
                        else
                            root(j,jj) = root(i,ii);
                            rootAux(j,jj) = rootAux(i,ii);
                        end
                    end
                end
            
            end
          
          end
          
        else
            root(i, ii) = -1;
          
        end

    end
end


end

