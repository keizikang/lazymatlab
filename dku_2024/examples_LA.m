clear

%% Vector norm
clc

a = [1, 2, 3];

sqrt(a * a')
sqrt(sum(a.^2))
norm(a)

%% Dot product and orthogonality
clc

a = [1, 2, 3, 4];
b = [-4, -3, 2, 1];
a * b'
dot(a, b)

%% Matrix is a collection of data.
clc
close all

img = imread('cameraman.tif');
imshow(img)

%% Matrix is a collection of vectors.
clc

A = [3, 4, 5, 6
    1, 9, 8, 9
    7, 4, 2, 7];

A(:, 1)
A(2, :)

%% Matrix represents a linear system.
clc

A = [2, 1, 3
    1, 3, 4
    3, 0, 1];
b = [9, 12, 5]';

x = A\b
A*x


%% The solution of a linear system is the intersection of hyperplanes.
close all

A = [2, 1, 3
    1, 3, 4
    3, 0, 1];
b = [9, 12, 5]';
x = A\b;

figure, hold on,
fimplicit3(@(x, y, z) dot(A(1, :), [x, y, z]) - b(1))
fimplicit3(@(x, y, z) dot(A(2, :), [x, y, z]) - b(2))
fimplicit3(@(x, y, z) dot(A(3, :), [x, y, z]) - b(3))

axis equal
xlim([-0.1, 0.1] + x(1))
ylim([-0.1, 0.1] + x(2))
zlim([-0.1, 0.1] + x(3))
view(3)


%% Colon operator
clc

A = 1:10
B = 5:8
C = 1.5:5.5

A = 1:2:9
B = 5:10:55
C = 0:0.1:1

A = 5:-1:1
B = 10:-2:2

A = 10:1

A = 5:5
B = 5:10:5
C = 1:10:100

A = (1:5)'


%% linspace
clc

A = linspace(1, 10, 10)
B = linspace(1, 9, 5)

A = linspace(1, 100)

B = linspace(1, 9, 5)
C = linspace(9, 1, 5)

D = linspace(10, 10, 5)


%% logspace
clc

A = logspace(1, 4, 4)


%% Merging matrices
clc

A1 = [1, 2, 3];
A2 = [4, 5, 6];
AH = [A1, A2]
AV = [A1; A2]
AH2 = [A1', A2']

B1 = [1, 2; 3, 4];
B2 = [11, 12; 13, 14];
BH = [B1, B2]
BV = [B1; B2]
BB = [BH; BV, BV]

repmat(B1, 1, 3)
repmat(B1, 3, 1)


%% reshape
clc

A = 1:12;
reshape(A, 3, 4)
reshape(A, 6, 2)


%% Special functions
clc

ones(3, 4)
ones(3)

zeros(3, 4)
zeros(3)

rand(10, 1)
randn(10, 1)
randi([10, 20], [3, 4])

magic(3)


%% Matrix operaion
clc

A = magic(3);
B = reshape(1:9, 3, 3);
A + B
A - B
B + 10
20 + A
A * 2
B / 3
A * B
A .* B
A ./ B
A.^2
1 ./ B

C = [2, 3, 4];
D = [5, 4, 3];
C.^D


%% Implicit expansion
clc

A = [3, 4, 5]
B = magic(3)

A + B
A' + B
A .* B
B ./ A

C = [10, 20, 30]

A' + C


%% Functions for matrices
clc

A = [magic(3) (1:3)']
size(A)
length(A)
numel(A)

A'
transpose(A)

flipud(A)
fliplr(A)

A = [4, 3, 5, 1, 2]

min(A)
[v, i] = min(A)

A = magic(5)
min(A)
min(A, [], 'all')
[v, i] = min(A, [], 'all')

A = reshape(1:9, 3, 3)
sum(A)
sum(A, 2)
sum(A, 'all')
prod(A)
prod(A, 2)
mean(A)
mean(A, 2)
std(A)
std(A')
cumsum(A)
cumsum(A, 2)
cumprod(A)
cumprod(A, 2)

A = [1, 2, 0, 0, 3]
find(A)

A = [12, 34, 0 ; 0, 0, 100]
[i, j, v] = find(A)

A = [2, 3, 1, 4, 5];
find(A == 1)

sort(A)
sort(A, 'descend')


%% Elementary row operations
clc

A = [1, 0, 4, 2
     1, 2, 6, 2
     2, 0, 8, 8
     2, 1, 9, 4];
rref(A)

A = row_add(A, 1, 2, -1);
A = row_add(A, 1, 3, -2);
A = row_add(A, 1, 4, -2);
A

A = row_add(A, 2, 4, -1/2);
A

A = row_mult(A, 2, 1/2);
A = row_mult(A, 3, 1/4);
A 

A = row_add(A, 3, 1, -2);
A


%% Particular solution and general solution
clc

A = [
    1,  3, -2,  0,  2,  0 
    2,  6, -5, -2,  4, -3
    0,  0,  5, 10,  0, 15
    2,  6,  0,  8,  4, 18
    ];

b = [0, -1, 5, 6]';

rref([A, b])

r = 1;
s = 2;
t = 3;
x1 = -3*r - 4*s - 2*t;
x2 = r;
x3 = -2*s;
x4 = s;
x5 = t;
x6 = 1/3;

B = [-3,  1,  0,  0,  0,  0
     -4,  0, -2,  1,  0,  0
     -2,  0,  0,  0,  1,  0]';

Bo = null(A);

% Check if Bo is a basis for the solution space of Ax = 0.
% How can we know B and Bo are two bases of same vector space?



%% Inverse of a matrix
clc

A = magic(3);
B = inv(A);
A * B
B * A

A = [magic(3), [0, 1, 2]']
rank(A)
A * pinv(A)

B = [magic(3); [0, 1, 2]]
rank(B)
pinv(B) * B

[L, U, P] = lu(magic(3))


%% Calculation of the inverse
clc

A = [
     2,  4,  3,  5
    -4, -7, -5, -8
     6,  8,  2,  9
     4,  9, -2, 14];


E1 = eye(4); E1(2,1) = 2;
E2 = eye(4); E2(3,1) = -3;
E3 = eye(4); E3(4,1) = -2;

E4 = eye(4); E4(3,2) = 4;
E5 = eye(4); E4(4,2) = -1;

E6 = eye(4); E6(4,3) = -3;

U = E6*E5*E4*E3*E2*E1*A;

L = inv(E6*E5*E4*E3*E2*E1);


%% Condition number
clc

A = [400, -201
    -800, 401];

inv(A)
A(1,1) = 401;
% inv(A)

b = [200, -200]';

A\b
    
A = [1/1, 1/2, 1/3
     1/2, 1/3, 1/4
     1/3, 1/4, 1/5];
inv(A)

B = A + 0.001*eye(3);
inv(B)

b = ones(3, 1);

A\b
B\b


%% Determinant of a 2 x 2 matrix
clc
close all

A = [3, 1
     1, 2];

figure, hold on,
x = [0, A(1, 1), A(1, 1)+A(2, 1), A(2, 1), 0];
y = [0, A(1, 2), A(1, 2)+A(2, 2), A(2, 2), 0];
plot(x, y)
axis equal

det(A)
polyarea(x, y)


%% Determinant of a 3 x 3 matrix

A = magic(3);
figure, hold on,
qdata = zeros(12, 6);
qdata( 1, :) = [zeros(1, 3), A(1, :)];
qdata( 2, :) = [zeros(1, 3), A(2, :)];
qdata( 3, :) = [zeros(1, 3), A(3, :)];
qdata( 4, :) = [A(1, :), A(2, :)];
qdata( 5, :) = [A(2, :), A(1, :)];
qdata( 6, :) = [A(2, :), A(3, :)];
qdata( 7, :) = [A(1, :), A(3, :)];
qdata( 8, :) = [sum(A(1:2, :)), A(3, :)];
qdata( 9, :) = [A(3, :), A(1, :)];
qdata(10, :) = [A(3, :), A(2, :)];
qdata(11, :) = [sum(A([1, 3], :)), A(2, :)];
qdata(12, :) = [sum(A(2:3, :)), A(1, :)];

c = 'rgb';
for i = 1:3
    quiver3(qdata(i, 1), qdata(i, 2), qdata(i, 3), ...
        qdata(i, 4), qdata(i, 5), qdata(i, 6), c(i), autoscale="off")
end

quiver3(qdata(4:end, 1), qdata(4:end, 2), qdata(4:end, 3), ...
    qdata(4:end, 4), qdata(4:end, 5), qdata(4:end, 6), autoscale="off")

view(3)
axis equal
grid on
det(A)


%% Properties of determinant

A = rand(3);
[det(A), det(A')]

B = rand(3);
det(A*B)
det(B*A)


%% Check if vectors are linearly independent
clc

A = [1, 2, 3];
B = [2, 4, 6];
C = [3, 6, 8];


%% Orthogonal complement and hyperplane
clc
close all

A = [1, -2];
b = -2;
figure,
fimplicit(@(x, y) dot(A, [x, y]) - b)

ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
axis equal


A = [1, 2, 3];
b = 6;
figure, hold on,
fimplicit3(@(x, y, z) dot(A, [x, y, z]) - b, ...
    EdgeColor="none")
quiver3(0, 0, 0, A(1), A(2), A(3), ...
    LineWidth=5)

axis equal
view(3)
grid on


%% General solution of a linear system
clc
close all

A = [1, -2];
b = -2;
figure, hold on,
fimplicit(@(x, y) dot(A, [x, y]) - b)
fimplicit(@(x, y) dot(A, [x, y]))
legend('Ax = b', 'Ax = 0')
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
axis equal


%% Basis
clc

A = [
    1,  3, -2,  0,  2,  0 
    2,  6, -5, -2,  4, -3
    0,  0,  5, 10,  0, 15
    2,  6,  0,  8,  4, 18
    ];

rref(A)

orth(A')'

% Check if orth(A) is a basis of col(A).
% Find the linear combination of each column of A 
% by the basis orth(A')'.


%% ERO and fundamental spaces
clc

A = [1, -2,   0,   2
     0,  1,   5,  10
     0, -3, -14, -28
     0, -2,  -9, -18
     2, -4,   0,   4];

% For what vectors b is Ax=b consistent?

syms b1 b2 b3 b4 b5

augA = [A, [b1 b2 b3 b4 b5].']

augA = row_add(augA, 1, 5, -2)

% Is the solution space a subspace of row(A) or col(A)?

%% Rank-Nullity Theorem

clc

A = [
    1,  3, -2,  0,  2,  0 
    2,  6, -5, -2,  4, -3
    0,  0,  5, 10,  0, 15
    2,  6,  0,  8,  4, 18
    ];

rref(A)
rank(A)

% How to see the nullity(A)?

A = magic(8)
rank(A)

%% Rank of orthogonal complement
clc

A = [1, 3, 5, 2, 4]';
B = [2, 4, 3, 1, 5];

A*B

% Change the numbers to symbolic and see why rank(A*B)=1.
