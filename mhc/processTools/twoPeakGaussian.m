function y=twoPeakGaussian(coeff,x)
    amp1=coeff(1);
    center1=coeff(2);
    dev1=coeff(3);
    amp2=coeff(4);
    center2=coeff(5);
    dev2=coeff(6);
    
    gaussian1=amp1*exp(-((x-center1).^2)/(2*dev1.^2));
    gaussian2=amp2*exp(-((x-center2).^2)/(2*dev2.^2));
    y=gaussian1+gaussian2;
    
            
end
