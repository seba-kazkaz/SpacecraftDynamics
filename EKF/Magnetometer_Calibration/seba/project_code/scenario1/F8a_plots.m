clear; clc; 

% video explaining the code: 
% https://www.youtube.com/watch?v=wP3jjk1O18A&t=403s

% my color palette
paynes_gray =      [102 106 134]/255;
jet =              [60 55 68]/255;
celadon =          [155 222 172]/255;
dark_slate_green = [33 79 75]/255;
atomic_tangerine = [247 157 132]/255;
bittersweet =      [238 99 82]/255;
peach_yellow =     [237 207 142]/255;
naples_yellow =    [249 220 92]/255;


% this will plot everything alhamdulillah use once this on each scenario
load('BTAM.mat');
load('Btrue.mat'); 
load('B_KF.mat');
load('bKF.mat');
load('vDKF.mat');
load('x.mat')

btrue = [5000 3000 6000];
vDtrue = [0.05 0.1 0.05 0.05 0.05 0.05];
Nsteps = 56680;
time = 0.1:0.1:5668;

%% PLOT 1 - angle between measurement model and KF magnetosphere vectors
% getting the data 
angBet = zeros(Nsteps, 1);
for i = 1:Nsteps
    angBet(i) = angle_between(BTAM(i,:), BKF(i,:));
end
% plotting
fig1 = figure(1);
plot(time, rad2deg(angBet), '+', 'Color', peach_yellow, 'MarkerSize', 1)
xlabel('Time / s')
ylabel('Angle Between Estimated and Measured MF Vectors / deg')


% this works
ax = gca
ax.Color = jet
ax.YColor = 'w'
ax.XColor = 'w'


picturewidth = 20;
hw_ratio = 0.65;
set(findall(fig1, '-property', 'FontSize'), 'FontSize', 21)
set(findall(fig1, '-property', 'Box'), 'Box', 'off')
set(findall(fig1, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(fig1, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(fig1, 'Units', 'centimeters', 'Position', [3 3 picturewidth hw_ratio*picturewidth])
pos = get(fig1, 'Position');
set(fig1, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'PaperSize', [pos(3), pos(4)])
print(fig1, 'png_figure', '-dpng', '-painters')


%% PLOT 2 - true and estimated bias vector components
fig2 = figure(2);
subplot(3,1,1)
plot(time, btrue(1)*ones(length(time),1), 'Color', bittersweet, 'LineWidth', 2); %  true bias vector 1st component
xticks([]); xlim([0 5668]); ylim([-25000 15000]); ylabel('$b_x$ / nT')
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
plot(time, x(:,1), 'Color', celadon, 'LineWidth', 2); 
subplot(3,1,2)
plot(time, btrue(2)*ones(length(time),1), 'Color', bittersweet, 'LineWidth', 2); %  true bias vector 1st component
xticks([]); xlim([0 5668]); ylim([-25000 15000]); ylabel('$b_y$ / nT')
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
plot(time, x(:,2), 'Color', celadon, 'LineWidth', 2);
subplot(3,1,3)
plot(time, btrue(3)*ones(length(time),1), 'Color', bittersweet, 'LineWidth', 2); %  true bias vector 1st component
xlim([0 5668]); ylim([-25000 15000]); ylabel('$b_z$ / nT')
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
plot(time, x(:,3), 'Color', celadon, 'LineWidth', 2);
linkaxes([subplot(3,1,1) subplot(3,1,2) subplot(3,1,3)], 'x'); xlabel('Time / s')

picturewidth = 20;
hw_ratio = 0.65;
set(findall(fig2, '-property', 'FontSize'), 'FontSize', 17)
set(findall(fig2, '-property', 'Box'), 'Box', 'off')
set(findall(fig2, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(fig2, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(fig2, 'Units', 'centimeters', 'Position', [3 3 picturewidth hw_ratio*picturewidth])
pos = get(fig2, 'Position');
set(fig2, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'PaperSize', [pos(3), pos(4)])
print(fig2, 'png_figure', '-dpng', '-painters')


%% PLOT 3 - absolute error in bias vector components
fig3 = figure(3);
subplot(3,1,1)
plot(time, abs(x(:,1)-btrue(1)*ones(length(time),1)), 'Color', paynes_gray, 'LineWidth', 2);
xticks([]); xlim([0 5668]); ylim([0 32000]); ylabel('$b_x$ / nT')
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
subplot(3,1,2)
plot(time, abs(x(:,2)-btrue(2)*ones(length(time),1)), 'Color', paynes_gray, 'LineWidth', 2)
xticks([]); xlim([0 5668]); ylim([0 32000]); ylabel('$b_y$ / nT')
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
subplot(3,1,3)
plot(time, abs(x(:,3)-btrue(3)*ones(length(time),1)), 'Color', paynes_gray, 'LineWidth', 2)
xlim([0 5668]); ylim([0 32000]); ylabel('$b_z$ / nT')
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
linkaxes([subplot(3,1,1) subplot(3,1,2) subplot(3,1,3)], 'x'); xlabel('Time / s')

picturewidth = 20;
hw_ratio = 0.65;
set(findall(fig3, '-property', 'FontSize'), 'FontSize', 17)
set(findall(fig3, '-property', 'Box'), 'Box', 'off')
set(findall(fig3, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(fig3, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(fig3, 'Units', 'centimeters', 'Position', [3 3 picturewidth hw_ratio*picturewidth])
pos = get(fig3, 'Position');
set(fig3, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'PaperSize', [pos(3), pos(4)])
print(fig3, 'png_figure', '-dpng', '-painters')


%% PLOT 4 - true and estimated orthogonality corrections vector components
fig4 = figure(4);
subplot(3,2,1)
plot(time, vDtrue(1)*ones(length(time),1), 'Color', bittersweet, 'LineWidth', 1.5); 
hold on; xlabel('Time / s'); ylabel('$D_{11}$'); xlim([0 5668]); ylim([-4 4]);
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
plot(time, x(:,4), 'Color', celadon, 'LineWidth', 1.5);
subplot(3,2,2)
plot(time, vDtrue(2)*ones(length(time),1), 'Color', bittersweet, 'LineWidth', 1.5); 
hold on; xlabel('Time / s'); ylabel('$D_{22}$'); xlim([0 5668]); ylim([-4 4]);
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
hold on;
plot(time, x(:,5), 'Color', celadon, 'LineWidth', 1.5);
subplot(3,2,3)
plot(time, vDtrue(3)*ones(length(time),1), 'Color', bittersweet, 'LineWidth', 1.5); 
hold on; xlabel('Time / s'); ylabel('$D_{33}$'); xlim([0 5668]); ylim([-4 4]);
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
hold on;
plot(time, x(:,6), 'Color', celadon, 'LineWidth', 1.5);
subplot(3,2,4)
plot(time, vDtrue(4)*ones(length(time),1), 'Color', bittersweet, 'LineWidth', 1.5); 
hold on; xlabel('Time / s'); ylabel('$D_{12}$'); xlim([0 5668]); ylim([-4 4]);
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
hold on;
plot(time, x(:,7), 'Color', celadon, 'LineWidth', 1.5);
subplot(3,2,5)
plot(time, vDtrue(5)*ones(length(time),1), 'Color', bittersweet, 'LineWidth', 1.5); 
hold on; xlabel('Time / s'); ylabel('$D_{13}$'); xlim([0 5668]); ylim([-4 4]);
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
hold on;
plot(time, x(:,8), 'Color', celadon, 'LineWidth', 1.5);
subplot(3,2,6)
plot(time, vDtrue(6)*ones(length(time),1), 'Color', bittersweet, 'LineWidth', 1.5); 
hold on; xlabel('Time / s'); ylabel('$D_{23}$'); xlim([0 5668]); ylim([-4 4]);
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
hold on;
plot(time, x(:,9), 'Color', celadon, 'LineWidth', 1.5);

picturewidth = 20;
hw_ratio = 0.65;
set(findall(fig4, '-property', 'FontSize'), 'FontSize', 13)
set(findall(fig4, '-property', 'Box'), 'Box', 'off')
set(findall(fig4, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(fig4, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(fig4, 'Units', 'centimeters', 'Position', [3 3 picturewidth hw_ratio*picturewidth])
pos = get(fig4, 'Position');
set(fig4, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'PaperSize', [pos(3), pos(4)])
print(fig4, 'png_figure', '-dpng', '-painters')

%% PLOT 5 - absolute error in orthogonality correction vector components
fig5 = figure(5);
subplot(3,2,1)
plot(time, abs(x(:,4)-vDtrue(1)*ones(length(time),1)), 'Color', paynes_gray, 'LineWidth', 1.5); 
hold on; xlabel('Time / s'); ylabel('$D_{11}$'); xlim([0 5668]); ylim([0 4]);
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
subplot(3,2,2)
plot(time, abs(x(:,5)-vDtrue(2)*ones(length(time),1)), 'Color', paynes_gray, 'LineWidth', 1.5); 
hold on; xlabel('Time / s'); ylabel('$D_{22}$'); xlim([0 5668]); ylim([0 4]);
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
subplot(3,2,3)
plot(time, abs(x(:,6)-vDtrue(3)*ones(length(time),1)), 'Color', paynes_gray, 'LineWidth', 1.5);
hold on; xlabel('Time / s'); ylabel('$D_{33}$'); xlim([0 5668]); ylim([0 4]);
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
subplot(3,2,4)
plot(time, abs(x(:,7)-vDtrue(4)*ones(length(time),1)), 'Color', paynes_gray, 'LineWidth', 1.5); 
hold on; xlabel('Time / s'); ylabel('$D_{12}$'); xlim([0 5668]); ylim([0 4]);
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
subplot(3,2,5)
plot(time, abs(x(:,8)-vDtrue(5)*ones(length(time),1)), 'Color', paynes_gray, 'LineWidth', 1.5); 
hold on; xlabel('Time / s'); ylabel('$D_{13}$'); xlim([0 5668]); ylim([0 4]);
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;
subplot(3,2,6)
plot(time, abs(x(:,9)-vDtrue(6)*ones(length(time),1)), 'Color', paynes_gray, 'LineWidth', 1.5); 
hold on; xlabel('Time / s'); ylabel('$D_{23}$'); xlim([0 5668]); ylim([0 4]);
ax = gca; ax.Color = jet; ax.YColor = 'w'; ax.XColor = 'w'; hold on;


picturewidth = 20;
hw_ratio = 0.65;
set(findall(fig5, '-property', 'FontSize'), 'FontSize', 13)
set(findall(fig5, '-property', 'Box'), 'Box', 'off')
set(findall(fig5, '-property', 'Interpreter'), 'Interpreter', 'latex')
set(findall(fig5, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex')
set(fig5, 'Units', 'centimeters', 'Position', [3 3 picturewidth hw_ratio*picturewidth])
pos = get(fig5, 'Position');
set(fig5, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'PaperSize', [pos(3), pos(4)])
print(fig5, 'png_figure', '-dpng', '-painters')



function angle = angle_between(A, B)
    angle = acos(dot(A,B)/(norm(A)*norm(B)));
end