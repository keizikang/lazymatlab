## MATurtle

파이썬 turtle을 매트랩으로 구현했습니다.

```
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
