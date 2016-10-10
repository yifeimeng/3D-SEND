function resultRatio= calculateSp3Ratio(coeff)
    ratioRef=0.2923135;
    amp1=coeff(1);
    center1=coeff(2);
    dev1=coeff(3);
    amp2=coeff(4);
    center2=coeff(5);
    dev2=coeff(6);
    intensityPi=amp1*dev1;
    intensitySigma=amp2*dev2;
    ratioPiOverSigma=intensityPi./intensitySigma;
    gamma=ratioPiOverSigma./(3*ratioRef);
    resultRatio=(1-3*gamma)./(1+gamma);



end

