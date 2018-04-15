function dTdt = eclipse(time_eclipse, initial_T)
%ECLIPSE Thermal transient for the satellite's eclipse period.
    load('satellite_properties');

    % Stefan-Boltzmann constant
    sigma = 5.67e-8; % W/(m^2*K^4)
    
    % No power absorbed by the surface.
    % Because during eclipse the Solar Constant S = 0.
    % So sat.qa = 0.

    % Power emitted by the surface:
    qe = sat.epsilon * sat.Ae * sigma * initial_T^4;
    
    % No external heating source during eclise so sat.qs = 0.
    % This means that (sat.qs / (sat.m * sat.c) = 0
    
    % The transient expression becomes:
    dTdt = -qe / (sat.m * sat.c);

end