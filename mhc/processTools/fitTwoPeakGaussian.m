function [coeff,chi]=fitTwoPeakGaussian(startCoeff,inputX,inputY)
%FITTWOGAUSSIAN Summary of this function goes here
%    amp1=coeff(1);
%    center1=coeff(2);
%    dev1=coeff(3);
%    amp2=coeff(4);
%    center2=coeff(5);
%    dev2=coeff(6);
    import lib.mathTools.UsefulMathFunctions.twoPeakGaussian
    
    opts=optimset('Display','off');
    [coeff,chi]=lsqcurvefit(@twoPeakGaussian,startCoeff,inputX,inputY,[],[],opts);


end

