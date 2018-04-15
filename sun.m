function dTdt = sun(time_sun, initial_T, satprop)
%SUN Thermal transient analysis for the satellite's sun illuminated period.

    % Stefan-Boltzmann constant.
    sigma = 5.67e-8; % W/(m^2*K^4)
    
    % Solar constant.
    S = 1378;
    
    % Power absorbed by the surface.
    qa = satprop.coating.alpha * satprop.Aa * S;

    % Power emitted by the surface.
    qe = satprop.coating.epsilon * satprop.Ae * sigma * initial_T^4;
    
    dTdt = (1 / (satprop.mass * satprop.thermal_capacity)) * (qa - qe) + (satprop.radiating_heat / (satprop.mass * satprop.thermal_capacity));
end

