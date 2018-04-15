% Satellite radius (it's a spherical satellite).
sat.r = 1; % m

% Satellite mass.
sat.m = 100; % kg

% Satellite is made out of unpolished aluminium.
sat.alpha = 0.25; % absorptivity
sat.epsilon = 0.25; % emissivity
sat.c = 900; % J/Kg/K

% An amplifier inside the spacecraft radiates heat. 
sat.qs = 200; % W

% Satellite thermal emitting area.
sat.Ae = 4 * pi * sat.r^2;

% Satellite thermal absorbing area.
sat.Aa = pi * sat.r^2;

save('satellite_properties.mat');