%{
               SPACECRAFT DYANMICS - PROJECT PART 2
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This project aims to design an Extended Kalman Filter for attitude-
independent magnetometer calibration in the Earth's parking orbit. The
code for the project runs a simulation of the magnetometer measurements
over the period of one 500km-altitude circular orbit around the Earth.

The project has four different segments: 
PART 1| Modeling spacecraft kinematics and dynamics
PART 2| Modeling the magnetometer measurement 
PART 3| Modeling Earth's magnetic field
PART 4| Extended Kalman Filer Implementation
%}

clear; clc; 

%% INITIALIZING GIVEN DATA
btrue = [5000 3000 6000]';
vDtrue = [0.05 0.1 0.05 0.05 0.05 0.05]';
Dtrue = [0.05 0.05 0.05;
         0.05 0.1  0.05;
         0.05 0.05 0.05];

%% PART 1| Spacecraft Kinematics and Dynamics
% done in a separate file and readily incorporated into models

%% PART 2| Magnetometer Measurement
% need to get attitude to insert intp magnetometer_measurements.m to get:
load('BTAM.mat'); % 56680x3 matrix

%% PART 3| Earth's Magnetic Field
% done i don't actually need it xoxoxo

%% PART 4| Kalman Filter
load('Z.mat') % 56680x1 vector

t0 = 0; dt = 0.1; tf = 5668;
Nsteps = length(t0:dt:tf)-1;
x = zeros(Nsteps, 9);
P = zeros(Nsteps, 9, 9); 

% initial guess
x(1,:) = [14.9540835620301	-35.3328010737005	-15.7937758552751 0.05 0.1 0.05 0.05 0.05 0.05];
P(1,:,:) = [3000*eye(3) zeros(3,6);
      zeros(6,3)  0.001*eye(6)];
% actual EKF loop <3 <3 <3 <3
for k = 1:Nsteps
    xnow = x(k,:)';
    Pnow = reshape(P(k,:,:), [9, 9]);
    if k<Nsteps
        [xnow, Pnow] = KF(xnow, Pnow, Z(k), BTAM(k,:)');
        x(k+1,:) = xnow';
        P(k+1, :, :) = reshape(Pnow, [1, 9, 9]);
    end
end

bKF = [x(Nsteps, 1) x(Nsteps, 2) x(Nsteps, 3)]';
vDKF = [x(Nsteps, 4) x(Nsteps, 5) x(Nsteps, 6) x(Nsteps, 7) x(Nsteps, 8) x(Nsteps, 9)]';

function [xn, Pn] = KF(xo, Po, Z, BTAM)
    % this is one run of the kalman filter loop
    % INPUTS
    %       xo - old value of x
    %       Po - old value of P
    %       z - observation at that timestep (B_TAM^2 - B_true^2)
    %       B_TAM - magnetometer

    % DECLARES
    b = [xo(1) xo(2) xo(3)]';
    vD = [xo(4) xo(5) xo(6) xo(7) xo(8) xo(9)]';
    D = [vD(1) vD(4) vD(5);
         vD(4) vD(2) vD(6);
         vD(5) vD(6) vD(3)];

    S = [BTAM(1)^2, BTAM(2)^2, BTAM(3)^2, 2*BTAM(1)*BTAM(2), 2*BTAM(1)*BTAM(3), 2*BTAM(2)*BTAM(3)];
    J = [BTAM(1)*b(1), BTAM(2)*b(2), BTAM(3)*b(3), BTAM(1)*b(2)+BTAM(2)*b(1), BTAM(1)*b(3)+BTAM(3)*b(1), BTAM(2)*b(3)+BTAM(3)*b(2)];
    dEdD = [2*(1+vD(1)) 0 0 2*vD(4) 2*vD(5) 0;
        0 2*(1+vD(2)) 0 2*vD(4) 0 2*vD(6);
        0 0 2*(1+vD(3)) 0 2*vD(5) 2*vD(6);
        vD(4) vD(4) 0 2+vD(1)+vD(2) vD(6) vD(5);
        vD(5) 0 vD(5) vD(6) 2+vD(1)+vD(3) vD(4);
        0 vD(6) vD(6) vD(5) vD(4) 2+vD(2)+vD(3)];

    H = [2*BTAM'*(eye(3)+D) - 2*b', -S*dEdD+2*J];

    R = 300^2;
    A = 1;
    Q = 0;
    % prediction step
    xp = A*xo;
    Pp = A*Po*A' + Q;
    % correction step
    K = Pp*H'/(H*Pp*H'+R); % K will be a 9x1 vector
    xn = xp + K*(Z - H*xp); % x is always a 9x1 vector
    Pn = Pp - K*H*Pp; % P is always a 9x9 matrix
end
