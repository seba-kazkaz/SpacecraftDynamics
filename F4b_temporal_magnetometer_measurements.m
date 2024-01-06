clear; clc;
% COMMANDS TO OBTAIN LLA COORDINATES + TRUE MAGNETOSPHERE MODEL 
% add this code to the main loop 
load('Btrue.mat'); % 56680x3 matrix
load('A.mat'); % this should be the euler angles at each timestep (56680x3)

t0 = 0; dt = 0.1; tf = 5668;
Nsteps = length(t0:dt:tf)-1;

BTAM = zeros(Nsteps, 3);
btrue = zeros(Nsteps, 3);

for i = 1:Nsteps
    [BTAM(i, :), btrue(i, :)] = magnetometer(Btrue(i,:), angle2dcm(A(i,3), A(i,2), A(i,1)));
end


function [BTAM, btrue] = magnetometer(Btrue, Adcm)
    dt = 0.1;
    % for now the magnetometer measurement is constant
    Dtrue = [0.05 0.05 0.05;
             0.05 0.1  0.05;
             0.05 0.05 0.05];
    btrue = 300*randn(3,1)*dt;

    BTAM = inv(eye(3,3)+Dtrue)*(Adcm*Btrue' + btrue + 300*randn(3,1));
end
