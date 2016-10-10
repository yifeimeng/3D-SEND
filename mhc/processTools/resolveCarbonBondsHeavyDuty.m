function resultCoeffMap = resolveCarbonBondsHeavyDuty(inputEnergyAxis,inputSignal,carbonInfo,existMap,sampleType)
%RESOLVECARBONBONDSHEAVYDUTY Summary of this function goes here
%   Detailed explanation goes here
            [xDim,yDim,zDim]=size(inputSignal);
%retrive window for two gaussian fit and some start coefficients
            winEdge=carbonInfo.dlcFitWindow;

            %find the corresponding indices in the energyAxis
            [~,startIndex]=min(abs(inputEnergyAxis-winEdge(1)));
            [~,endIndex]=min(abs(inputEnergyAxis-winEdge(2)));
            %create inputX and window for two gaussian fit
            inputX=inputEnergyAxis(startIndex:endIndex);
            %preallocate result arrays
            %set options for least-square linear fit
            %opts=optimset('Display','off','MaxIter',100,'Algorithm','levenberg-marquardt','UseParallel','always');
            opts=optimset('Display','off','Algorithm','trust-region-reflective','UseParallel','always');
            %get coefficients for fitting
            if strcmp(sampleType,'head')==1
                %classify variables for parallel computing
                tempSignal=reshape(inputSignal,xDim*yDim,1,length(inputEnergyAxis));
                tempCoeffMap=zeros(xDim*yDim,1,7);
                tempExistMap=reshape(existMap,xDim*yDim,1);
                %Get starting coefficient and bounds information
                startCoeff=carbonInfo.dlcStartCoeff(1:6);
                lowBound=carbonInfo.dlcCoeffLowBound(1:6);
                highBound=carbonInfo.dlcCoeffHighBound(1:6);
                %start parallel computing
                delete(gcp('nocreate'));
                calculatePool=parpool('local',2);
                parfor i=1:xDim*yDim
                    if tempExistMap(i)==true
                        inputY=squeeze(tempSignal(i,1,startIndex:endIndex));
                        %fit the window with two gaussian
                        [coeffFinal,chi]=lsqcurvefit(@twoPeakGaussian,double(startCoeff),double(inputX),double(inputY),lowBound,highBound,opts);
                        tempCoeffMap(i,1,:)=[coeffFinal,chi];
                    end
                    
                end
                %end parallel computing
                delete(calculatePool);
                resultCoeffMap=reshape(tempCoeffMap,xDim,yDim,7);
            elseif strcmp(sampleType,'media')==1
                %classify variables for parallel computing
                tempSignal=reshape(inputSignal,xDim*yDim,1,length(inputEnergyAxis));
                tempCoeffMap=zeros(xDim*yDim,1,10);
                tempExistMap=reshape(existMap,xDim*yDim,1);
                %Get starting coefficient and bounds information
                startCoeff=carbonInfo.dlcStartCoeff(1:9);
                lowBound=carbonInfo.dlcCoeffLowBound(1:9);
                highBound=carbonInfo.dlcCoeffHighBound(1:9);
                %start parallel computing
                delete(gcp('nocreate'));
                calculatePool=parpool('local',2);
                parfor i=1:xDim*yDim
                    if tempExistMap(i)==true
                        inputY=squeeze(tempSignal(i,1,startIndex:endIndex));
                        %fit the window with two gaussian
                        [coeffFinal,chi]=lsqcurvefit(@threePeakGaussian,double(startCoeff),double(inputX),double(inputY),lowBound,highBound,opts);
                        tempCoeffMap(i,1,:)=[coeffFinal,chi];
                    end
                    
                end
                %end parallel computing
                delete(calculatePool);
                resultCoeffMap=reshape(tempCoeffMap,xDim,yDim,10);
            end
                
end

