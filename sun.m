function dTdt = sun(time_sun, initial_T)
%SUN Summary of this function goes here
%   Detailed explanation goes here
    load('satellite_properties');  
    
    % Stefan-Boltzmann constant.
    sigma = 5.67e-8; % W/(m^2*K^4)
    
    % Solar constant.
    S = 1378;
    
    % Power absorbed by the surface.
    qa = sat.alpha * sat.Aa * S;

    % Power emitted by the surface.
    qe = sat.epsilon * sat.Ae * sigma * initial_T^4;
    
    dTdt = (1 / (sat.m * sat.c)) * (qa - qe) + (sat.qs / (sat.m * sat.c));
end

