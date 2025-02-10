clear; close all; clc;
% original source: https://angeloyeo.github.io/

% stretch / compression
A = [3  0
     0  1];

% shear
% A = [1  2
%      0  1];

% rotation
% q = 90; 
% A = [cosd(q) -sind(q)
%      sind(q)  cosd(q)];

% reflection about x-axis
% A = [ 1   0
%       0  -1];

% reflection about y-axis
% A = [-1   0
%       0   1];

% reflection about y=mx
% m = 1/sqrt(3);
% A = [1-m^2     2*m
%        2*m   m^2-1]/(1+m^2);

% projection
% v = [1, 1]';
% A = 1/(v'*v)*v*v';

% general
% A = [3 2
%      2 3];

% translation
% A = [1  0  2
%      0  1  0
%      0  0  1];

%% rotate initial points?

phi = 0; % in degrees

%% animation
n_steps = 100;
step_mtx = eye(2);
[x, y] = ndgrid(linspace(-1, 1, 15));

xx = [cosd(phi), -sind(phi)]*[x(:), y(:)]';
yy = [sind(phi),  cosd(phi)]*[x(:), y(:)]';
x = xx;
y = yy;

if length(A) < 3
    A = [A, zeros(2, 1)
         zeros(1, 2), 1];
end

Axy = A(1:2, :)*[x(:), y(:), ones(numel(x), 1)]';
lim_range = 1.5*max(abs(Axy(:)))*[-1, 1];

dot_colors = jet(length(x(:)));

figure, hold on,
h = scatter(x(:), y(:),30,dot_colors,'filled');
if abs(det(A(1:2, 1:2)) + 1) <= eps
    % in case of reflection, draw symm line
    fplot(@(x) tan(acos(A(1,1))/2)*x, '--', Color=[.5, .5, .5])
elseif rank(A(1:2, 1:2)) < 2
    % in case of projection, draw onto where points are projected
    fimplicit(@(x, y) A(1, 1:2)*[-y; x], '--', Color=[.5, .5, .5])
end

grid on;
set_xy_graph
axis([lim_range, lim_range])
pause;
for i = (0:n_steps)/n_steps
    dist = (1 - cos(i*pi))/2;
    step_mtx = (A - eye(3))*dist;
    
    new_xy = (eye(3) + step_mtx)*[x(:), y(:), ones(numel(x), 1)]';
    h.XData = new_xy(1,:);
    h.YData = new_xy(2,:);
    pause(0.01);
end