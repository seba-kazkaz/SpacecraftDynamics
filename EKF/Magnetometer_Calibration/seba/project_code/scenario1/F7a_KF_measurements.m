clear; clc;
% COMMANDS TO OBTAIN LLA COORDINATES + TRUE MAGNETOSPHERE MODEL 
% add this code to the main loop 
load('Btrue.mat'); % 56680x3 matrix
load('A.mat'); % this should be the euler angles at each timestep (56680x3)
load('bKF.mat'); % final guess of the bias vector done by the EKF
load('vDKF.mat'); % final guess of the orthogonality matrix done by the EKF

DKF = [vDKF(1)  vDKF(4)  vDKF(5);
       vDKF(4)  vDKF(2)  vDKF(6);
       vDKF(5)  vDKF(6)  vDKF(3)];

t0 = 0; dt = 0.1; tf = 5668;
Nsteps = length(t0:dt:tf)-1;

BKF = zeros(Nsteps, 3);

for i = 1:Nsteps
    BKF(i, :) = KFmagnetometer(Btrue(i,:), angle2dcm(A(i,3), A(i,2), A(i,1)), bKF, DKF);
end


function BKF = KFmagnetometer(Btrue, Adcm, bKF, DKF)
    BKF = inv(eye(3,3)+DKF)*(Adcm*Btrue' + bKF + 300*randn(3,1));
end