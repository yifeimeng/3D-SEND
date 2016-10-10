 function [resultEnergyAxis,resultSignal]=cropEnergy(inputEnergyAxis,inputSignal,winEdge)
            %find the corresponding indices in the energyAxis
            [~,startIndex]=min(abs(inputEnergyAxis-winEdge(1)));
            [~,endIndex]=min(abs(inputEnergyAxis-winEdge(2)));
            %crop the energy axis
            resultEnergyAxis=inputEnergyAxis(startIndex:endIndex);
            %crop the eels spectrum for each pixcel
            resultSignal=inputSignal(:,:,startIndex:endIndex);
 end %end of crop energy

