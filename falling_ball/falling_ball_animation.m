clear
close all
clc

figure, hold on, box on

h = 2; % 공 B 낙하 시작 높이
d = 1; % 공 B의 x 좌표
q = rad2deg(atan(h/d)); % 공 A는 공 B를 향해서 쏨
v0 = 4; % 공 A 초기속도


v0Ax = v0*cosd(q);
v0Ay = v0*sind(q);
v0Bx = 0;
v0By = 0;
dt = 0.01;
t = 0;
tt = t;
g = 9.8;
ballA = plot(0, 0, 'ro');
ballB = plot(d, h, 'bo');
lineA = plot(0, 0, 'r--');
lineB = plot(0, 0, 'b--');

xlim([-1, 2])
ylim([-1, 2])
set(gca, 'XAxisLocation', 'origin')
set(gca, 'YAxisLocation', 'origin')

v = VideoWriter("falling_ball.avi", "Motion JPEG AVI");
v.FrameRate = 30;
open(v)

posx = @(x0, v0x, t) x0 + v0x*t;
posy = @(y0, v0y, t) y0 + v0y*t - 1/2*g*t.^2;

while true
    t = t + dt;
    tt(end+1) = t;
    ballA.XData = posx(0, v0Ax, t);
    ballA.YData = posy(0, v0Ay, t);
    ballB.XData = posx(d, v0Bx, t);
    ballB.YData = posy(h, v0By, t);
    lineA.XData = posx(0, v0Ax, tt);
    lineA.YData = posy(0, v0Ay, tt);
    lineB.XData = posx(d, v0Bx, tt);
    lineB.YData = posy(h, v0By, tt);
    
    f = getframe(gcf);
    writeVideo(v, f.cdata);
    
    if norm([ballA.XData, ballA.YData]-[ballB.XData, ballB.YData])<0.05
        break
    end
end

close(v)