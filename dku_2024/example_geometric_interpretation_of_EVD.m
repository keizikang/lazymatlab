clear
close all
clc

A = [3  2
     2  3];

x = [-1, 2]';

[P, D] = eig(A);

figure, hold on,
set_xy_graph

x_proj1 = D(1,1)*P(:,1)*P(:,1)'*x;
x_proj2 = D(2,2)*P(:,2)*P(:,2)'*x;

quiver(0, 0, x(1), x(2), 'm', AutoScale="off", LineWidth=2)
quiver(0, 0, P(1,1), P(2,1), 'k')
quiver(0, 0, P(1,2), P(2,2), 'k')

quiver(0, 0, x_proj1(1), x_proj1(2), 'r', AutoScale='off', LineWidth=2)
quiver(0, 0, x_proj2(1), x_proj2(2), 'b', AutoScale='off', LineWidth=2)