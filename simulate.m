function [time_span, T_C] = simulate(orbit, satprop)
%SIMULATE Simulates the satellite's thermal transience and returns it's
    % temperature data over time (in Celsius and minutes respectively).

    % List that will contain data to plott.
    time_span = []
    T_K = []

    % ode45 options.
    options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8); % Accuracy.

    m = 0;
    n = 0;

    for i = (1: 1: orbit.num)

        % Eclipse phase.
        if exist('T_sun', 'var') == 1
            satprop.T0_K = T_sun(end);
        end

        tspan = [m * orbit.T_ecl + n * orbit.T_sun_ill: 1: (m+1) * orbit.T_ecl + n * orbit.T_sun_ill];
        [time_eclipse, T_eclipse] = ode45(@(t,y) eclipse(t, y, satprop), tspan, satprop.T0_K, options);
        
        m = m + 1;

        % Sun illuminated phase.
        satprop.T0_K = T_eclipse(end);
        tspan = [m * orbit.T_ecl + n * orbit.T_sun_ill: 1: m * orbit.T_ecl + (n+1) * orbit.T_sun_ill];
        [time_sun, T_sun] = ode45(@(t,y) sun(t, y, satprop), tspan, satprop.T0_K, options);
        
        n = n + 1;

        time_span = [time_span; time_eclipse; time_sun];
        T_K = [T_K; T_eclipse; T_sun];
    end

    % Time span in minutes.
    time_span = time_span / 60; 
    
    % Temperature in Celsius.
    T_C = T_K - 273;
end