function residual= removeBackgroundTwoWindow(inputX, inputY, window1, window2, method)
%Use interpolation method to create background between two windows
%power law is y=AE^(-r). coeff(1) is r, coeff(2) is A.
    switch method
        case 'power'
            [coeff,R]=fitPowerLaw([inputX(window1(1):window1(2));inputX(window2(1):window2(2))],[inputY(window1(1):window1(2));inputY(window2(1):window2(2))]);
            background=coeff(2)*inputX.^(-coeff(1));
            residual=inputY-background;
    end


end

