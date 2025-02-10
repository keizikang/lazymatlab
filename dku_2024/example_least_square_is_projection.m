clear
close all
clc

x = [1, 2, 3]';
y = [2, 3, 5]';

figure, plot(x, y, 'bo')
set_xy_graph
box off
axis([-1, 4, -1, 6])

%% Best fit as a projection onto col(A)

A = [ones(3, 1), x];

disp('========================================')
disp('  Best fit as a projection onto col(A)')
disp('========================================')
coeff = inv(A'*A)*A'*y
y_hat = A*coeff

%% Best fit using polyfit

disp('========================================')
disp('  Best fit using polyfit')
disp('========================================')

coeff = polyfit(x, y, 1)
y_hat = polyval(coeff, x)

%% Best fit using qr decomposition

disp('========================================')
disp('  Best fit using qr decomposition')
disp('========================================')

[Q, R] = qr(A, 'econ');
coeff = Q'*y
y_hat = Q*Q'*y

%% Best fit using pseudoinverse

disp('========================================')
disp('  Best fit using pseudoinverse')
disp('========================================')

coeff = A\y
coeff = pinv(A)*y

%% plot the best fit line

hold on,
fplot(@(x) coeff(1) + coeff(2)*x, 'b--')

