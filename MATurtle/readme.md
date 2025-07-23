## MATurtle

파이썬 turtle을 매트랩으로 구현했습니다.

```matlab
t = turtle(); % 터틀을 시작합니다.

t.forward(100); % 100만큼 앞으로 갑니다.
t.backward(100); % 100만큼 뒤로 갑니다.
t.left(90); % 90도만큼 왼쪽(반시계 방향)으로 돕니다.
t.right(90); % 90도만큼 오른쪽(시계 방향)으로 돕니다.
t.goto(100, 100); % 절대좌표 (100, 100)으로 이동합니다.
t.turnto(90); % 90도(북쪽)을 향하도록 돕니다.

t.speed(1000); % 이동속도를 1000으로 세팅합니다. (초기값=500)

t.pen_up(); % 펜을 듭니다. 움직여도 선이 그려지지 않습니다.
t.pen_down(); % 펜을 붙입니다. 이제 움직이면 선이 그려집니다.

t.color('b'); % 선 색을 'b'로 바꿉니다.

t.begin_fill(FaceColor, EdgeColor, FaceAlpha); % 채우기를 시작합니다.
t.end_fill(); % 채우기를 끝냅니다.

t.change_icon('person.png'); % 아이콘을 person.png로 바꿉니다.

t.clear(); % 화면을 초기화합니다.
```

예제 1: 오망성 그리기

```matlab
t = turtle();

for i = 1:5
    t.forward(200);
    t.left(144);
end
```

예제 2: 육망성 그리기

```matlab
t = turtle();

t.pen_up();
t.goto(0, 100);
t.turnto(240);
t.pen_down();
t.color('r')

for i = 1:3
    t.forward(150/cosd(30));
    t.left(120);
end

t.pen_up();
t.goto(0, -100);
t.turnto(60);
t.pen_down();
t.color('b')

for i = 1:3
    t.forward(150/cosd(30));
    t.left(120);
end
```

예제 3: MATLAB 글자 쓰기

```matlab
coords = [
    1	-352	 146
    0	-352	 330
    0	-276	 330
    0	-248	 222
    0	-220	 330
    0	-144	 330
    0	-144	 146
    0	-192	 146
    0	-192	 280
    0	-226	 146
    0	-268	 146
    0	-304	 280
    0	-304	 146
    0	-352	 146
    1	-40	 146
    0	  26	 330
    0	  90	 330
    0	 160	 146
    0	  98	 146
    0	  90	 176
    0	  26	 176
    0	  16	 146
    0	-40	 146
    1	  38	 216
    0	  58	 278
    0	  76	 216
    0	  38	 216
    1	 248	 330
    0	 420	 330
    0	 420	 284
    0	 362	 284
    0	 362	 146
    0	 306	 146
    0	 306	 284
    0	 248	 284
    0	 248	 330
    1	-350	-104
    0	-350	-288
    0	-146	-288
    0	-146	-242
    0	-294	-242
    0	-294	-104
    0	-350	-104
    1	-40	-288
    0	  26	-104
    0	  90	-104
    0	 160	-288
    0	  98	-288
    0	  90	-258
    0	  26	-258
    0	  16	-288
    0	-40	-288
    1	  38	-218
    0	  58	-156
    0	  76	-218
    0	  38	-218
    1	 250	-104
    0	 250	-288
    0	 356	-288
    0	 406	-256
    0	 408	-214
    0	 374	-192
    0	 406	-168
    0	 406	-132
    0	 366	-104
    0	 250	-104
    1	 298	-142
    0	 298	-178
    0	 330	-178
    0	 344	-168
    0	 344	-156
    0	 332	-144
    0	 298	-144
    1	 298	-212
    0	 298	-246
    0	 330	-246
    0	 344	-238
    0	 344	-226
    0	 332	-212
    0	 298	-212
    1	0	0
];


close; t = turtle;
t.speed = 1500;
t.pen_up();
colors = 'rgwbmcwyww';
ci = 0;
for i = 1:length(coords)
    if coords(i, 1) == 1
        t.end_fill();
        t.pen_up();
    elseif coords(i - 1, 1) == 1 && coords(i, 1) == 0
        ci = ci + 1;
        t.begin_fill(colors(ci), 'k');
    end
    t.goto(coords(i, 2), coords(i, 3));
end
```

![](https://github.com/keizikang/lazymatlab/blob/cd8ba7a90d252262b904f59afde9bfc2a06ab230/MATurtle/MATurtle.gif)
