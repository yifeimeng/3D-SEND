function [coeff,R]=fitPowerLaw(inputX,inputY)
%This function fit the data to power law y=AE^(-r)
%coeff(1) is r, coeff(2) is A
    y=log(inputY);
    x=log(inputX);
    [p,S]=polyfit(x,y,1);
    k=-p(1);
    b=p(2);
    
    coeff(1)=k;
    coeff(2)=exp(b);
    R=S.R;
    


end

