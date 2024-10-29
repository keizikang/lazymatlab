%% 2-D graph is a collection of line segments.
close all

x = [0, 1, 2, 3];
y = [0, 1, 4, 9];
 
plot(x, y)

x = linspace(0, 1);
y = x.^2;
 
plot(x, y)

%% Lots of line segments looks like a smooth curve.
close all

x = linspace(0, 1);
y = x.^2;
 
plot(x, y)


%% Multiple lines, line specifier, miscell info
close all

x = linspace(0, 1, 11);

figure, hold on,
plot(x, x.^1, 'r*-')
plot(x, x.^2, 'gs:')
plot(x, x.^3, 'b^-.')

xlabel('input')
ylabel('output')
title('polynomials')
legend('linear', ...
    'quadratic', ...
    'cubic')


%% axis
close all

x = linspace(-2, 2, 21);

figure, hold on,
plot(x, x.^1, 'r*-')
plot(x, x.^2, 'gs:')
plot(x, x.^3, 'b^-.')

legend('linear', ...
    'quadratic', ...
    'cubic')

axis([-3, 3, -10, 10])
xlim([-3, 3])
ylim([-10, 10])

% axis padded     % margin at all boundaries
% axis tight      % no margin
% axis equal      % equal ruler for all axes
% axis square     % square axes
% axis normal     % back to default


%% fplot
close all

figure, hold on,
fplot(@(x) 2*x, 'r*-')
fplot(@(x) x.^2, 'gs:')
fplot(@sin, 'b^-.')
fplot(@exp, [-4, 1], 'mo')

legend('y=2x', 'y=x^2', ...
    'y=sin(x)', 'y=exp(x)')

%% subplot
close all

figure,
subplot(2, 2, 1), fplot(@sin)
subplot(2, 2, 2), fplot(@cos)
subplot(2, 2, 3), fplot(@tan)
subplot(2, 2, 4), fplot(@exp)


%% plot3
close all

t = 0:0.1:10*pi;

x = sin(2*t);
y = cos(2*t);
z = t;

figure,
plot3(x, y, z)
xlabel('x'), ylabel('y'), zlabel('z')
title('3d spiral')


%% fplot3
close all

fplot3(@(t) sin(2*t), ...
    @(t) cos(2*t), ...
    @(t) t, ...
    [0, 10*pi])


%% surf
close all

x = linspace(-1, 3);
y = linspace(1, 4);
[xx, yy] = meshgrid(x, y);
zz = xx.*yy.^2./(xx.^2+yy.^2);

surf(xx, yy, zz)
shading interp

colormap hot
colorbar


%% fsurf
close all

fsurf(@(x, y) x.*y.^2./ ...
    (x.^2 + y.^2), ...
    [-1, 3, 1, 4])
