function bdToPfSpot(beamDirection)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
normalizedV = beamDirection/norm(beamDirection);
equiv = poleFigureEquiv(normalizedV);
X = equiv(:,1)./(1+equiv(:,3));
Y = equiv(:,2)./(1+equiv(:,3));
hold on
scatter(X,Y,30);
xlim([-1,+1]);
ylim([-1,+1]);
hold off
end

