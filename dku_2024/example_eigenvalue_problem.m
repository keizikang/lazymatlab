clear
close all
clc

A = [0   0  -2
     1   2   1
     1   0   3];

cp = charpoly(A, 'x')
factor(cp)

[P, D] = eig(A)