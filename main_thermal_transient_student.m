% Thermal transient
% Author: Leonard Felicetti
% Copyright: Leonard Felicetti
% Modifications: Georges L. J. Labreche

% Clear all.
clear all;
close all;
clc;

% Standard gravitational parameter for Earth. 
GMe = 398600; % km^3/s^-2 

% Stefan-Boltzmann constant.
sigma = 5.67e-8; % W/(m^2*K^4)

% Number of orbits.
orbit_num = 10;

% Earth radius.
Re = 6378; % km

% Satellite altitude.
h = 600; % km

% Initial temperature (in Kelvin).
T0_C = 10; % Celsius.
T0_K = T0_C + 273; % Kelvin.

% There are two special type of Sun synchronous orbit Dawn-dusk orbit and
% noon-midnight orbit.
%   1. Dawn-dusk orbit.
%       - The sun beta angle is 90 deg.
%       - The orbit plane normal points the sun always.
%       - This orbit doesn't undergo eclipses.
%       - A spacecraft placed in this orbit passes through the terminator
%         line of the earth i.e. day-night separator.
%
%   2. Moon-midnight orbit:
%       - The sun beta angle is 0 deg.
%       - The sun is always in the orbital plane.
%
%   Source:
%   "What is the beta angle with respect to sun-synchronous satellites?"
%   Rajesh Kannan, Scientist, Flight Dynamics Section, ISRO, MCF, Hassan, INDIA
%   Quora.com, May 21, 2017.
%   https://www.quora.com/What-is-the-beta-angle-with-respect-to-sun-synchronous-satellites
beta = 0;

% Orbital period - Kepler's Third Law.
T_orb = 2 * pi * sqrt((Re + h)^3 / GMe); % Seconds.

% To calculate the eclipse period and the sun illumination period, first 
% calculate the spacecraft eclipse fraction using the equation in the
% following source:
%
% Satellite Engineering, Bill Nadie.
% Equation 4 under section "Calculation of Eclipse Time."
% Fall 2003.
fE = (1/pi) * acos(sqrt(h^2 + 2 * Re * h) / ((Re + h) * cos(beta)));

% Eclipse period.
T_ecl =  fE * T_orb;

% Sun-illuminated period.
T_sun_ill = (1 - fE) * T_orb;

% For final plotting.
time_span = []
T_K = []

% ode45 options.
options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8); % Accuracy.

m = 0;
n = 0;

for i = (1: 1: orbit_num)
    
    % Eclipse phase.
    if exist('T_sun', 'var') == 1
        T0_K = T_sun(end);
    end
       
    tspan = [m * T_ecl + n * T_sun_ill: 1: (m+1) * T_ecl + n * T_sun_ill];
    [time_eclipse, T_eclipse] = ode45(@eclipse, tspan, T0_K, options); 
    
    m = m + 1;
    
    % Sun illuminated phase.
    T0_K = T_eclipse(end);
    tspan = [m * T_ecl + n * T_sun_ill: 1: m * T_ecl + (n+1) * T_sun_ill];
    [time_sun, T_sun] = ode45(@sun, tspan, T0_K, options);
    
    n = n + 1;
    
    time_span = [time_span; time_eclipse; time_sun];
    T_K = [T_K; T_eclipse; T_sun];

end

T_C = T_K - 273;

% Draw figure.
figure(1)
plot(time_span / 60, T_C) % Plot temperature in celsius across time.
xlabel('time, minutes')
ylabel('temperature, celsius')
grid






