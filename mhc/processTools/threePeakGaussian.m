function y=threePeakGaussian(coeff,x)
    amp1=coeff(1);
    center1=coeff(2);
    dev1=coeff(3);
    amp2=coeff(4);
    center2=coeff(5);
    dev2=coeff(6);
    amp3=coeff(7);
    center3=coeff(8);
    dev3=coeff(9);
    
    gaussian1=amp1*exp(-((x-center1).^2)/(2*dev1.^2));
    gaussian2=amp2*exp(-((x-center2).^2)/(2*dev2.^2));
    gaussian3=amp3*exp(-((x-center3).^2)/(2*dev3.^2));
    y=gaussian1+gaussian2+gaussian3;
    
            
end

