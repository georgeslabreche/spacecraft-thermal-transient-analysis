% main thermal transient
% Author: Leonard Felicetti
% Copyright Leonard Felicetti

clear all;
close all;
clc;

global r m alpha epsilon c qs Ae Aa sigma S
h = 600; % km
Re = 6378; % km

r = 1; % m
m = 100; %kg
alpha = 0.25; 
epsilon = 0.25;
c = 900; % J/Kg/K
qs= 200; 
sigma = 5.67e-8; % W/(m^2*K^4)
Ae = 4*pi*r^2;
Aa = pi*r^2;
S = 1378;
MUe = 398600;

% Initial temperature
T0 = 10+273;


% Orbital period
T_orb = 
% Eclipse period
T_ecl =
% Sun-illuminated period
T_sun_ill = 

% First Eclipse
tspan = [0 : 1: T_ecl];
y0 = [T0];
options = odeset('RelTol',1e-8,'AbsTol',1e-8 );

% you need to write the function eclipse(t,y)
[time_eclipse_1,T_eclipse_1] = ode45(@eclipse,tspan,y0,options);



% Sun illuminated phase
T0 = T_eclipse_1(end);
tspan = [T_ecl : 1: T_ecl+T_sun_ill];
y0 = [T0];
options = odeset('RelTol',1e-8,'AbsTol',1e-8 );

% you need to write the function sun(t,y) 
[time_sun,T_sun] = ode45(@sun,tspan,y0,options);

% Second Eclipse
T0 = T_sun(end);
tspan = [ T_ecl + T_sun_ill : 1: 2*T_ecl+T_sun_ill];
y0 = [T0];
options = odeset('RelTol',1e-8,'AbsTol',1e-8 );

[time_eclipse_2,T_eclipse_2] = ode45(@eclipse,tspan,y0,options);

% It might be extended to longer simulation periods


time = [time_eclipse_1; time_sun; time_eclipse_2];
T = [T_eclipse_1; T_sun; T_eclipse_2];



figure(1)
plot(time/60,T-273)
xlabel('time, min')
ylabel('temperature, celsius')
grid




