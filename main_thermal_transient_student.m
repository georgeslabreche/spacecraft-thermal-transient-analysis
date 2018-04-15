% Thermal transient
% Author: Leonard Felicetti
% Copyright: Leonard Felicetti
% Modifications: Georges L. J. Labreche

% Clear all.
clear all;
close all;
clc;

% Earth radius.
Re = 6378; % km

% Satellite altitude.
h = 600; % km

% Stefan-Boltzmann constant
sigma = 5.67e-8; % W/(m^2*K^4)

% Standard gravitational parameter for Earth. 
GMe = 398600; % km^3/s^-2 

% Initial temperature (in Kelvin).
T0_C = 10; % Celsius.
T0_K = T0_C + 273; % Kelvin.

% There are two special type of Sun synchronous orbit:
%   1. Dawn-dusk orbit and noon-midnight orbit.
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
% Fall 2003
fE = (1/pi) * acos(sqrt(h^2 + 2 * Re * h) / ((Re + h) * cos(beta)));

% Eclipse period
T_ecl =  fE * T_orb;

% Sun-illuminated period
T_sun_ill = (1 - fE) * T_orb;

% First Eclipse.
tspan = [0 : 1: T_ecl];
options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8); % Accuracy.

% Thermal transient.
[time_eclipse_1, T_eclipse_1] = ode45(@eclipse, tspan, T0_K, options); 

for i = (1: 1: 3)
   strcat(num2str(time_eclipse_1(i)), ':',  num2str(T_eclipse_1(i)))
end

% Sun illuminated phase.
T0_K = T_eclipse_1(end);
tspan = [T_ecl: 1: T_ecl + T_sun_ill];
options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8 ); % Accuracy.

% Thermal transient.
[time_sun, T_sun] = ode45(@sun, tspan, T0_K, options);

% Second Eclipse.
T0_K = T_sun(end);
tspan = [T_ecl + T_sun_ill: 1: 2*T_ecl+T_sun_ill];
options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8); % Accuracy.

% Thermal transient.
[time_eclipse_2, T_eclipse_2] = ode45(@eclipse, tspan, T0_K, options);

% It might be extended to longer simulation periods.
time_span = [time_eclipse_1; time_sun; time_eclipse_2];
T_C = [T_eclipse_1; T_sun; T_eclipse_2];
T_K = T_C - 273;

% Draw figure.
figure(1)
plot(time_span / 60, T_K) % Plot temperature in celsius across time.
xlabel('time, min')
ylabel('temperature, celsius')
grid






