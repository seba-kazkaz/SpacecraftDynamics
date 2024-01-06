clear; clc;
% COMMANDS TO OBTAIN LLA COORDINATES + TRUE MAGNETOSPHERE MODEL 
% add this code to the main loop 
load('LLAorbit.mat');

t0 = 0; dt = 0.1; tf = 5668;
Nsteps = length(t0:dt:tf)-1;

Btrue = zeros(Nsteps, 3);

for i = 1:Nsteps
    [Btrue(i, :), ~] = igrfmagm(LLAorbit(i, 3), LLAorbit(i, 1), LLAorbit(i, 2), decyear(2024,11,22));
end