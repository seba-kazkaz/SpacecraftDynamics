clear; clc;
% COMMANDS TO OBTAIN LLA COORDINATES + TRUE MAGNETOSPHERE MODEL 
% add this code to the main loop 
load('R.mat');

t0 = 0; dt = 0.1; tf = 5668;
Nsteps = length(t0:dt:tf)-1;

LLAorbit = zeros(Nsteps, 3);
Btrue = zeros(Nsteps, 3);

% initiating the date
% date = datetime(2026, 11, 22, 11, 24, 54);
% jdate = juliandate(date);
R_E = 6.3710e6;

for i = 1:Nsteps
%     % time update and formatting
%     jdate = jdate+dt;
%     date = datetime(jdate, 'convertfrom', 'juliandate');
%     utc = datetime(date, 'Format','yyyy MM dd HH mm ss', 'TimeZone','local');
%     % eci to lla conversion
    [LLAorbit(i,1), LLAorbit(i,2), LLAorbit(i,3)] = my_eci2lla(R(i,1), R(i,2), R(i,3));
end

function [lat, lon, alt] = my_eci2lla(x, y, z)
    % Earth's mean radius in kilometers
    R_E = 6.3710e3; % Earth's radius in kilometers

    % Calculate distance from the origin (satellite) to the XY plane
    r_xy = sqrt(x^2 + y^2);
    
    % Calculate latitude and altitude
    lat = atan2d(z, r_xy); % Latitude in degrees
    lon = atan2d(y, x); % Longitude in degrees
    alt = sqrt(x^2 + y^2 + z^2) - R_E; % Altitude in kilometers above Earth's surface
end
