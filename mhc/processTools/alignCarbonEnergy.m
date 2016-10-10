function [resultSignal,resultDriftMap]=alignCarbonEnergy(inputEnergyAxis,inputEnergyScale,inputSignal,carbonInfo,existMap)
           %find correlations between reference and signal. resolution
            %difference between reference and signal may require
            %intrapolation for reference.
            %get size of the input signal
            [xDim,yDim,zDim]=size(inputSignal);
            resultSignal=zeros(xDim,yDim,zDim);
            resultDriftMap=zeros(xDim,yDim);
            %examine if the scale matches, if not, perform the
            %interpolation
            diff=inputEnergyScale-carbonInfo.dlcRefInterpolated.scale;
            if diff>1e-3
                carbonInfo.dlcRefInterp(inputEnergyScale);
            end
            inputRef=carbonInfo.dlcRefInterpolated.data;
            for x=1:1:xDim
                for y=1:1:yDim
                    if existMap(x,y)==true
                        %construct input data for cross correlation
                        spectrum=double(squeeze(inputSignal(x,y,:)));
                        %perform the cross correlation and find the shift
                        [corr,lags]=xcorr(spectrum,inputRef);
                        [~,index]=max(corr);
                        shift=lags(index);
                        %find the lag required for alignment
                        realShiftEnergy=shift*inputEnergyScale;
                        idealShiftEnergy=carbonInfo.dlcRefInterpolated.origin-inputEnergyAxis(1);
                        correction=(idealShiftEnergy-realShiftEnergy)/inputEnergyScale;
                        correction=double(round(correction));
                        %align the signal to ideal position and assign zero to
                        %empty pixcels
                        spectrumForCorrect=squeeze(inputSignal(x,y,:));
                        correctedSpectrum=lagmatrix(spectrumForCorrect,correction);
                        correctedSpectrum(isnan(correctedSpectrum))=0;
                        %asign the corrected signal back to original signal
                        resultSignal(x,y,:)=correctedSpectrum;
                        resultDriftMap(x,y,1)=correction;
                    end
                        
                
                end
            end
end %end of alignEnergy