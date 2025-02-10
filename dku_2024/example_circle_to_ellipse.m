clear
close all
clc

A = [3  1
     0  2];

[P, D] = eig(A);

figure, hold on,
f0 = fimplicit(@(x, y) x.^2 + y.^2 -1);
f = plot(f0.XData, f0.YData);
set_xy_graph
axis([-4, 4, -4, 4])
axis square
grid on

quiver(0, 0, D(1,1)*P(1,1), D(1,1)*P(2,1), 'r', AutoScaleFactor=1)
quiver(0, 0, D(2,2)*P(1,2), D(2,2)*P(2,2), 'b', AutoScaleFactor=1)

p = [1, 0
     0, 1
     -1/sqrt(2), 1/sqrt(2)
     -1, 0
     0, -1
     1/sqrt(2), -1/sqrt(2)
     ];

pause

for i=1:size(p, 1)
    slide(plot(p(i, 1), p(i, 2), 'k.'), A, 50);
end

slide(f, A, 50)

%%

function slide(h, A, Nsteps)

xy = [h.XData; h.YData];
for x = (0:Nsteps)/Nsteps
    dist = (1 - cos(x*pi))/2;
    Am = (A - eye(2))*dist + eye(2);
    Axy = Am * xy;
    h.XData = Axy(1, :);
    h.YData = Axy(2, :);
    pause(0.01)
end

end