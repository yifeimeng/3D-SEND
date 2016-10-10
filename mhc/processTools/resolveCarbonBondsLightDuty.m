function [resultCoeff,chi]=resolveCarbonBondsLightDuty(inputEnergyAxis,inputSignal,carbonInfo,sampleType)
            %retrive window for two gaussian fit and some start coefficients
            winEdge=carbonInfo.dlcFitWindow;

            %find the corresponding indices in the energyAxis
            [~,startIndex]=min(abs(inputEnergyAxis-winEdge(1)));
            [~,endIndex]=min(abs(inputEnergyAxis-winEdge(2)));
            %create inputX and window for two gaussian fit
            inputX=inputEnergyAxis(startIndex:endIndex);
            %get coefficients for fitting
            if strcmp(sampleType,'head')==1
                %set options for least-square linear fit
                %opts=optimset('Display','off','MaxIter',100,'Algorithm','levenberg-marquardt','UseParallel','always');
                opts=optimset('Display','off','Algorithm','trust-region-reflective','UseParallel','always');
                startCoeff=carbonInfo.dlcStartCoeff(1:6);
                lowBound=carbonInfo.dlcCoeffLowBound(1:6);
                highBound=carbonInfo.dlcCoeffHighBound(1:6);
                inputY=squeeze(inputSignal(1,1,startIndex:endIndex));
                %fit the window with two gaussian
                [resultCoeff,chi]=lsqcurvefit(@twoPeakGaussian,double(startCoeff),double(inputX),double(inputY),lowBound,highBound,opts);
                %display resolve results
                x=inputEnergyAxis;
                amp1=resultCoeff(1);
                center1=resultCoeff(2);
                dev1=resultCoeff(3);
                amp2=resultCoeff(4);
                center2=resultCoeff(5);
                dev2=resultCoeff(6);
                yG1=gaussmf(x,dev1,center1)*amp1;
                yG2=gaussmf(x,dev2,center2)*amp2;
                y3=squeeze(inputSignal(1,1,:));
                figure;
                plot(x,yG1,x,yG2,x,y3);
            elseif strcmp(sampleType,'media')==1
                %use bounding conditions for three peak gaussian 
                opts=optimset('Display','off','Algorithm','trust-region-reflective','UseParallel','always');
                startCoeff=carbonInfo.dlcStartCoeff(1:9);
                lowBound=carbonInfo.dlcCoeffLowBound(1:9);
                highBound=carbonInfo.dlcCoeffHighBound(1:9);
                inputY=squeeze(inputSignal(1,1,startIndex:endIndex));
                %fit the window with two gaussian
                [resultCoeff,chi]=lsqcurvefit(@threePeakGaussian,double(startCoeff),double(inputX),double(inputY),lowBound,highBound,opts);
                %display resolve results
                x=inputEnergyAxis;
                amp1=resultCoeff(1);
                center1=resultCoeff(2);
                dev1=resultCoeff(3);
                amp2=resultCoeff(4);
                center2=resultCoeff(5);
                dev2=resultCoeff(6);
                amp3=resultCoeff(7);
                center3=resultCoeff(8);
                dev3=resultCoeff(9);
                yG1=gaussmf(x,dev1,center1)*amp1;
                yG2=gaussmf(x,dev2,center2)*amp2;
                yG3=gaussmf(x,dev3,center3)*amp3;
                
                y3=squeeze(inputSignal(1,1,:));
                figure;
                plot(x,yG1,x,yG2,x,yG3,x,y3);
            end
            
            function result=gaussmf(x,sigma,c)
                result=exp(-((x-c).^2)/(2*sigma.^2));
            
            end
 

            
           
end %end of resolveBonds

