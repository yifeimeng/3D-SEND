function [resultSignal,resultExistMap]=tellCarbonExistence(inputSignal,signalThreshold)
    %get size of the input signal
    [xDim,yDim,zDim]=size(inputSignal);
    resultSignal=zeros(xDim,yDim,zDim);
    resultExistMap=false(xDim,yDim);
    for x=1:1:xDim
        for y=1:1:yDim
            inputY=squeeze(inputSignal(x,y,:));
            [maxIntensity,~]=max(filter(ones(1,5)/5,1,inputY));
            %tell if the signal is noise or carbon edge
            if maxIntensity>signalThreshold
                resultExistMap(x,y)=true;
                % normalize the signal
                normalizeFactor=(500)./maxIntensity;
                inputY=inputY*normalizeFactor;
                resultSignal(x,y,:)=inputY;
            end

                
         end
     end
end
