function dTdt = eclipse(time_eclipse, initial_T, satprop)
%ECLIPSE Thermal transient analysis for the satellite's eclipse period.

    % Stefan-Boltzmann constant
    sigma = 5.67e-8; % W/(m^2*K^4)
    
    % No power absorbed by the surface (qa).
    % Because during eclipse the Solar Constant S = 0.
    % So qa = 0.

    % Power emitted by the surface:
    qe = satprop.coating.epsilon * satprop.Ae * sigma * initial_T^4;
    
    % The transient expression becomes:
    dTdt = -qe / (satprop.mass * satprop.thermal_capacity) + (satprop.radiating_heat / (satprop.mass * satprop.thermal_capacity));

end