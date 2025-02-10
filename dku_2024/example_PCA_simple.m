clear
close all
clc

% height, weight
X = [170 70
       150 45
       160 55
       180 60
       172 80
       100 17
       110 20
        90 20
       105 18
        88 21
    ];

figure, hold on,

plot(X(:,1), X(:,2), 'bo')
xlabel('height')
ylabel('weight')

Xc = X - mean(X);

figure, hold on,
plot(Xc(:,1), Xc(:,2), 'bo')
set_xy_graph

[U, S, V] = svd(Xc);
fimplicit(@(x, y) V(1, 1)*(-y)+V(2, 1)*x)

% projecting Xc onto the first principal axis
Xc*V(:, 1)