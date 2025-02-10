ccc

A = [1  1  0  0
     0  1  0  0
     0  0  1  0
     0  0  0  1];

B = [1  1  0  0
     0  1  0  0
     0  0  1  1
     0  0  0  1];

fprintf('determinants : %d, %d\n\n', det(A), det(B))
fprintf('rank         : %d, %d\n\n', rank(A), rank(B))
fprintf('trace        : %d, %d\n\n', trace(A), trace(B))

fprintf('poly.char.(A): %s\n', char(charpoly(A, 'x')))
fprintf('poly.char.(B): %s\n', char(charpoly(B, 'x')))

[P_A, D_A] = eig(A);
[P_B, D_B] = eig(B);

