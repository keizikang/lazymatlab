clear
close all
clc

A = [3  1
     0  2];
x = [0, 1]';
Ax = A*x;

[P, D] = eig(A);

figure, tiledlayout(2, 2, TileSpacing="compact")
nexttile, hold on,
f0 = fimplicit(@(x, y) x.^2 + y.^2 -1);
plot(f0.XData, f0.YData, 'k');
set_xy_graph
axis([-4, 4, -4, 4])
axis square
grid on
quiver(0, 0, x(1), x(2), 'm', LineWidth=2, AutoScale='off')

pause

nexttile(3), hold on,
set_xy_graph
axis([-4, 4, -4, 4])
axis square
grid on
ax = gca;
ax.XAxis.Visible = 'off';
ax.YAxis.Visible = 'off';
fimplicit(@(x, y) P(1,1)*(-y) + P(2,1)*x, 'r')
fimplicit(@(x, y) P(1,2)*(-y) + P(2,2)*x, 'b')
quiver(0, 0, P(1,1), P(2,1), 'r', LineWidth=2, AutoScale='off')
quiver(0, 0, P(1,2), P(2,2), 'b', LineWidth=2, AutoScale='off')
quiver(0, 0, x(1), x(2), 'm', LineWidth=2, AutoScale='off')
plot(f0.XData, f0.YData, 'k');

pause

nexttile(4), hold on,
set_xy_graph
axis([-4, 4, -4, 4])
axis square
grid on
ax = gca;
ax.XAxis.Visible = 'off';
ax.YAxis.Visible = 'off';
fimplicit(@(x, y) P(1,1)*(-y) + P(2,1)*x, 'r')
fimplicit(@(x, y) P(1,2)*(-y) + P(2,2)*x, 'b')
quiver(0, 0, P(1,1), P(2,1), 'r', LineWidth=2, AutoScale='off')
quiver(0, 0, P(1,2), P(2,2), 'b', LineWidth=2, AutoScale='off')
quiver(0, 0, Ax(1), Ax(2), 'm', LineWidth=2, AutoScale='off')
plot(A(1,:)*[f0.XData; f0.YData], ...
    A(2,:)*[f0.XData; f0.YData], 'k');

pause

nexttile(2), hold on,
set_xy_graph
axis([-4, 4, -4, 4])
axis square
grid on
quiver(0, 0, Ax(1), Ax(2), 'm', LineWidth=2, AutoScale='off')
plot(A(1,:)*[f0.XData; f0.YData], ...
    A(2,:)*[f0.XData; f0.YData], 'k');