clear; clc;
load('BTAM.mat');
load('Btrue.mat');

Z = zeros(56680, 1);
for i = 1:56680
    Z(i) = norm(BTAM(i,:))^2 - norm(Btrue(i,:))^2;
end

% this should give us Z and we need to save it to Z.mat 