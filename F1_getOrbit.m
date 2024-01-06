clear;clc;
% this code gives me the exact points for the parking orbit for dt=0.1

% necessary constants
G = 6.67430e-20;
m_E = 5.9722e24; 
R_E = 6.3710e3; 
mu_E = G*m_E;
Operiod = 5668; % seconds

% simulation initiation parameters
t0 = 0; dt = 0.1; tf = Operiod; % one full orbital period
Nsteps = length(t0:dt:tf)-1;
R = zeros(Nsteps, 3);

% givens
r0 = [523.7, -5801.1, -3644.7];
v0 = [7.5877, 0.6612, 0.0379];

% preliminary 
normal = cross(v0,r0)/norm(cross(v0,r0)); % normal vector to orbital plane
meanMotion = 2*pi/Operiod; % angular velocity of the circular orbit

% build
R(1, :) = r0;
for i = 2:Nsteps
    theta = meanMotion*i*dt;
    R(i, :) = rotate(r0, normal, theta);
end

% plot to verify everything went according to plan
figure(2)
plot3(R(:, 1), R(:, 2), R(:, 3));

% defining a function to rotate my position vector
function rotated_vector = rotate(vector, normal, theta) 
    % Rodrigues' rotation formula to rotate a vector about a normal by an
    % angle theta
    rotated_vector = vector*cos(theta) + cross(normal, ...
        vector)*sin(theta) + normal*dot(normal,vector)*(1-cos(theta));
end