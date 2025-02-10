clear
close all
clc

% M: columns form a basis of W
M = [ 1  -1
     -1  -1
      1  -1];

P = M*inv(M'*M)*M';

figure, hold on,
set_xy_graph
xlabel('x'), ylabel('y')
view(3)
fimplicit3(@(x, y, z) cross(M(:,1), M(:,2))'*[x;y;z], EdgeColor="none")
axis([-1, 1, -1, 1, -1, 1])

v = [.2, .3, .9]';
% v = rand(3, 1);

quiver3(0, 0, 0, v(1), v(2), v(3), 'k', AutoScaleFactor=1, MaxHeadSize=1)
quiver3(0, 0, 0, P(1,:)*v, P(2, :)*v, P(3, :)*v, 'k', AutoScaleFactor=1, MaxHeadSize=1)

% check if Pv is perpendicular to (v-Pv)
dot(P*v, v-P*v)