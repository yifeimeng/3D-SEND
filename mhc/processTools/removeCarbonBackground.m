function resultSignal=removeCarbonBackground(inputEnergyAxis,inputSignal,carbonInfo)
            %retrive window edge information based on edge
            winEdge=carbonInfo.edgeInfo(1).background;
            %get size of the input signal
            [xDim,yDim,zDim]=size(inputSignal);
            %find the corresponding indices in the energyAxis
            [~,startIndex]=min(abs(inputEnergyAxis-winEdge(1,1)));
            [~,endIndex]=min(abs(inputEnergyAxis-winEdge(1,2)));
            %create inputX and window for background removal
            window=[startIndex,endIndex];
            inputX=inputEnergyAxis;
            %substract background for each pixel under the same window
            resultSignal=zeros(xDim,yDim,zDim);
            for x=1:1:xDim
                for y=1:1:yDim
                    inputY=squeeze(inputSignal(x,y,:));
                    residual=removeBackground(inputX,inputY,window,'power');
                    resultSignal(x,y,:)=residual;

                
                end
            end
           

end %end of removeBackground
