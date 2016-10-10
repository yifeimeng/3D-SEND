function residual=removeBackground(inputX,inputY,window,method)
%This function remove the EELS background based on the input data. 
%power law is y=AE^(-r). coeff(1) is r, coeff(2) is A.
    switch method
        case 'power'
            [coeff,R]=fitPowerLaw(inputX(window(1):window(2)),inputY(window(1):window(2)));
            background=coeff(2)*inputX.^(-coeff(1));
            residual=inputY-background;
    end

    
    
    


end

