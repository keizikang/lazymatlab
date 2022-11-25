* $e^x$는 특별한 성질이 있습니다. 
* 미분을 해도 자기 자신이 그대로 나옵니다. 
* 일반적으로 지수함수의 미분은 아래와 같습니다.

$\frac{d}{dx} a^x = a^x \ln{a}$

* 그렇다면 미분해서 원래의 함수와 똑같이 나오는 base를 찾으면 $e$라고 볼 수 있겠군요. 
* 아래는 해당 과정을 구현한 코드입니다.


```matlab
clear
close all
clc

syms x
xmin = -2;
xmax = 2;
xx = linspace(xmin, xmax);

% factory: returns symbolic function a^x
% fdiff: returns difference (f-dfdx) for a given range of x
factory = @(base) base^x;
fdiff = @(f) double(subs(f, x, xx)) - double(subs(diff(f), x, xx));

% starting base = 2
% initial step size = 1, halves for every iteration
% direction changes based on the sign of fdiff
base = 2;
step_size = 1;

f = factory(base);
dfdx = diff(f);

figure, hold on,
set(gca, 'XAxisLocation', 'origin')
set(gca, 'YAxisLocation', 'origin')

h = fplot(f, [-2, 2], 'r');
dh = fplot(dfdx, [-2, 2], 'b');
l = legend('$a^x$', '$\frac{d}{dx}a^x$',...
    Interpreter = 'latex', ...
    fontsize = 12, ...
    location = 'northwest');
t = title(sprintf('a = %10.8f, RMSE = %g', base, norm(fdiff(f))));

pause(.3)

n_iter = 1;
while norm(fdiff(f)) > 1e-7
    base = base + sign(mean(fdiff(f)))*step_size;
    f = factory(base);
    h.Function = f;
    dh.Function = diff(f);
    step_size = step_size/2;
    t.String = sprintf('a = %10.8f, RMSE = %g', base, norm(fdiff(f)));
    n_iter = n_iter + 1;
    pause(.3)
end

l.String = {'$e^x$'  '$\frac{d}{dx}e^x$'};
t.String = sprintf('final: e = %10.8f (after %d iterations)', base, n_iter);
```

* 아래는 코드 실행 결과입니다.

![](https://github.com/keizikang/lazymatlab/blob/master/finding_e/finding_e.gif)
