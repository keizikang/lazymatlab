clear
close all
clc

A = [1  1
     1  2
     1  3];

a1 = A(:,1);
a2 = A(:,2);

q1 = a1/norm(a1);
q2 = a2 - q1*q1'*a2;
q2 = q2/norm(q2);

[q1, q2]

[Q, R] = qr(A, 'econ');

Q

