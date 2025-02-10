clear
close all
clc

A = [1  5  3  4
     1  3  4 11
     1  4  2  6
     1 11  6  7
     1  6  7  5];

y = [9 7 8 9 10]';

[1, 4, 11, 6]*pinv(A)*y


