# AYE (Aids Your Indexing)

* 매트랩 인덱싱을 연습할 수 있는 교육용 UI가 하나 있으면 좋겠다는 생각이 들었다.
* 딱히 어렵지도 않을 것 같다. 바로 만들어보자.

### GUI 스케치

* 대충 이렇게 만들면 되겠다 싶었다.

![](https://github.com/keizikang/lazymatlab/blob/df2147786d5f2d66bfe49b8e10ac56dd55f30f7d/AYE/sketch.png)

* 아래에 인덱스 표현식을 넣으면 해당되는 영역을 녹색으로 보여준다.
* 행렬의 크기는 위에서 정할 수 있다.
* 일단 2차원만 해보기로 했다. 3차원은 나중에 기회가 되면 해보는 걸로.

### display_layout: Layout 만들기

* UI 가운데에 행렬은 grid처럼 생겼으니까 지금부터 grid라고 부르겠다.
* 우선 grid가 들어갈 위치를 대충 정한다.

![](https://github.com/keizikang/lazymatlab/blob/39b5c5ad4dcea6f0432ef2adedb7f1cb9ba9ed58/AYE/sketch_layout.png)

```matlab
% size of grid
Nrows = 4;
Ncols = 5;

% position of grid
grid_left = 0.03;
grid_bottom = 0.25;
grid_width = 0.95; 
grid_height = 0.55;
```

* bottom이 저렇게 높고 height가 저렇게 낮은 이유는 앱 이름, 행렬 크기, 인덱스 쓰는 곳 공간을 위함이다.
* 맨 밑에는 메시지 박스도 넣을 예정이다.
* 위치를 정했으면 이제 바탕이 될 Figure 객체를 만든다. 세팅은 적절히 잡는다.

```matlab
hf = figure('color',[.95, .95, .95],...
    'MenuBar', 'none', ...
    'ToolBar', 'figure', ...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'Resize', 'off', ...
    'PaperOrientation', 'landscape', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.00 0.04 .96 .96], ...
    'PaperPositionMode', 'manual', ...
    'Position', [ 0.3536    0.3157    0.2917    0.5889], ...
    'Name', 'AYE (Aids Your indExing)');

toolbar = allchild(hf);
toolbar.Visible = 'off';
```

* grid를 제외하고 나머지 객체들의 위치를 잡는다. 
* 노가다가 좀 필요하다.

```matlab
% text: title
txt_title = uicontrol(...
    'Parent', hf, ...
    'Style', 'text', ...
    'String', 'AYE (Aids Your indExing)', ...
    'BackgroundColor', [.95, .95, .95], ...
    'FontSize', 20, ...
    'units', 'normalized', ...
    'position', [0.1691    0.8833    0.6756    0.1000]);

% text: size of A
txt_matrix_size = uicontrol(...
    'Parent', hf, ...
    'Style', 'text', ...
    'String', 'size of A: ', ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [.95, .95, .95], ...
    'FontSize', 18, ...
    'units', 'normalized', ...
    'position', [0.2459    0.8004    0.2166    0.1000]);

% edit: number of rows
edit_Nrows = uicontrol(...
    'Parent', hf, ...
    'Style', 'edit', ...
    'String', string(Nrows), ...
    'Tag', 'Nrows', ...
    'BackgroundColor', [1, 1, 1], ...
    'FontSize', 22, ...
    'units', 'normalized', ...
    'position', [0.4500    0.83    0.0964    0.0867]);

% edit: number of columns
edit_Ncols = uicontrol(...
    'Parent', hf, ...
    'Style', 'edit', ...
    'String', string(Ncols), ...
    'Tag', 'Ncols', ...
    'BackgroundColor', [1, 1, 1], ...
    'FontSize', 22, ...
    'units', 'normalized', ...
    'position', [0.6200    0.83    0.0964    0.0867]);

% text: x
txt_cross = uicontrol(...
    'Parent', hf, ...
    'Style', 'text', ...
    'String', 'x', ...
    'BackgroundColor', [.95, .95, .95], ...
    'FontSize', 24, ...
    'units', 'normalized', ...
    'position', [0.5600    0.82    0.0454    0.0947]);

% index: user input
txt_A_index = uicontrol(...
    'Parent', hf, ...
    'Style', 'text', ...
    'String', 'A(                                               )', ...
    'BackgroundColor', [.95, .95, .95], ...
    'FontSize', 22, ...
    'units', 'normalized', ...
    'position', [0.0571    0.12    0.8357    0.0947]);

edit_user_indexing = uicontrol(...
    'Parent', hf, ...
    'Style', 'edit', ...
    'FontSize', 22, ...
    'units', 'normalized', ...
    'position', [0.1714 0.14 0.6429 0.08], ...
    'Callback', @highlight);

txt_error = uicontrol(...
    'Parent', hf, ...
    'Style', 'text', ...
    'String', 'Everything is fine.', ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [.9, .9, .9], ...
    'FontSize', 18, ...
    'units', 'normalized', ...
    'position', [0.0553    0.04    0.8357    0.0547]);
```

![](https://github.com/keizikang/lazymatlab/blob/8104792d51225b449d6f0b3d2c7fadff5699e635/AYE/layout_without_grid.png)


* grid 생성부는 함수로 만들기로 했다.

```matlab
% position of grid
grid_left = 0.03;
grid_bottom = 0.25;
grid_width = 0.95; 
grid_height = 0.55;

function display_grid(hf, grid, Nrows, Ncols)

grid_width = grid.grid_width;
grid_height = grid.grid_height;
grid_left = grid.grid_left;
grid_bottom = grid.grid_bottom;

cell_width = grid_width/Ncols;
cell_height = grid_height/Nrows;
```

* 맨 처음 만들었던 grid_left 등을 일일이 쓰기 귀찮으니 struct로 묶었다.
* cell은 행렬의 각 요소이다.

```matlab
txt = gobjects(Nrows, Ncols);
for j=1:Ncols
    for i=1:Nrows
        left = grid_left + cell_width*(j-1);
        bottom = grid_bottom + grid_height - cell_height*i;
        txt(i,j) = uicontrol(...
            'Parent', hf, ...
            'Style', 'edit', ...
            'String', string(i) + ',' + string(j), ...
            'Units', 'normalized', ...
            'Position', [left    bottom    cell_width*0.99    cell_height*0.99], ...
            'FontSize', 18);
    end
end
assignin('base', 'txt', txt);
```

* gobjects로 그래픽 객체의 array를 초기화할 수 있다.
* txt가 grid의 모든 cell을 담고 있는 array이다.
* cell_width와 cell_height에 0.99를 곱해 cell 간에 약간의 틈을 주었다.
* 각 셀의 String은 i, j의 형태를 부여했다.
* assignin과 evalin은 사랑입니다.
* 위 코드 앞에 한 가지 snippet을 추가했다.

```matlab
try
    delete(evalin('base', 'txt'));
catch
end
```

* 나중에 grid 크기를 바꾸게 될텐데, cell 위치를 다시 잡느니 그냥 없애고 새로 만드는게 편하겠다 싶었다.
* 어차피 속도는 티가 안나더라.
* display_grid 함수의 전체 모습은 아래와 같다.

```matlab
function display_grid(hf, grid, Nrows, Ncols)

grid_width = grid.grid_width;
grid_height = grid.grid_height;
grid_left = grid.grid_left;
grid_bottom = grid.grid_bottom;

cell_width = grid_width/Ncols;
cell_height = grid_height/Nrows;

try
    delete(evalin('base', 'txt'));
catch
end

txt = gobjects(Nrows, Ncols);
for j=1:Ncols
    for i=1:Nrows
        left = grid_left + cell_width*(j-1);
        bottom = grid_bottom + grid_height - cell_height*i;
        txt(i,j) = uicontrol(...
            'Parent', hf, ...
            'Style', 'edit', ...
            'String', string(i) + ',' + string(j), ...
            'Units', 'normalized', ...
            'Position', [left    bottom    cell_width*0.99    cell_height*0.99], ...
            'FontSize', 18);
    end
end
assignin('base', 'txt', txt);

end
```

![](https://github.com/keizikang/lazymatlab/blob/6db118f5a66ec9b964dbea75d10f22dbcfdf9f7d/AYE/layout_complete.png)

### change_grid_size: grid 크기 변경 구현

* Nrows와 Ncols가 바뀔 때 호출할 콜백 함수가 필요하다.
* 함수를 하나만 만들고 호출한 객체의 Tag로 구분하는 것이 편할 것 같다.

```matlab
function change_grid_size(s, ~, ~)

% change base variables
if strcmp(s.Tag, 'Nrows')
    assignin('base', 'Nrows', str2double(s.String));
elseif strcmp(s.Tag, 'Ncols')
    assignin('base', 'Ncols', str2double(s.String));
end

% change grid size
display_grid(s.Parent, ...
    evalin('base', 'grid'), ...
    evalin('base', 'Nrows'), ...
    evalin('base', 'Ncols'));

end
```

Nrow와 Ncols에도 콜백 함수를 추가한다.

```matlab
% edit: number of rows
edit_Nrows = uicontrol(...
    'Parent', hf, ...
    'Style', 'edit', ...
    'String', string(Nrows), ...
    'Tag', 'Nrows', ...
    'BackgroundColor', [1, 1, 1], ...
    'FontSize', 22, ...
    'units', 'normalized', ...
    'position', [0.4500    0.83    0.0964    0.0867], ...
    'Callback', @change_grid_size);

% edit: number of columns
edit_Ncols = uicontrol(...
    'Parent', hf, ...
    'Style', 'edit', ...
    'String', string(Ncols), ...
    'Tag', 'Ncols', ...
    'BackgroundColor', [1, 1, 1], ...
    'FontSize', 22, ...
    'units', 'normalized', ...
    'position', [0.6200    0.83    0.0964    0.0867], ...
    'Callback', @change_grid_size);
```

### highlight: 인덱싱에 따른 cell 하이라이트 구현

* 이제 사용자가 인덱스를 넣으면 해당되는 cell을 녹색으로 보여줘야 한다.

```matlab
function highlight(s, ~, ~)

Nrows = evalin('base', 'Nrows');
Ncols = evalin('base', 'Ncols');
txt = evalin('base', 'txt');

A = zeros(Nrows, Ncols);
eval("A(" + s.String + ") = 1;");

for j=1:Ncols
    for i=1:Nrows
        txt(i,j).BackgroundColor = [.94, .94, .94];
        if A(i,j) == 1                
            txt(i,j).BackgroundColor = [189, 236, 182]/255;
        end
    end
end

end
```

* Nrows x Ncols 크기의 영행렬 A를 만들고, 입력 인덱스에 해당되는 요소의 값을 1로 만든다.
* grid를 모두 담고 있는 txt를 순회하면서, A의 값이 1인 곳(cell)의 색을 바꾼다.
* 매번 이렇게 해야 다른 인덱스 입력이 들어왔을 때 녹색을 흰색으로 편하게 바꿀 수 있다.
* 한 가지 기능을 추가하자: 인덱스 표현식이 잘못됐을 때 무시하기
  * try-catch를 사용한다.
  * 입력 인덱스 표현식을 그대로 대입하여 에러가 나면 catch 하게 한다.
  * 이때 실행할 statement는 에러 발생이 목적이므로 아무 의미 없어도 된다. 예를 들면 이렇게.

```matlab
eval("A(" + s.String + ");"); % to check if index is within the range
```

* catch는 나중에 에러 메시지와 한번에 구현하기로 하고, 일단 여기까지 정리한다.

```matlab
function highlight(s, ~, ~)

Nrows = evalin('base', 'Nrows');
Ncols = evalin('base', 'Ncols');
txt = evalin('base', 'txt');

try 
    A = zeros(Nrows, Ncols);
    eval("A(" + s.String + ");"); % to check if index is within the range
    eval("A(" + s.String + ") = 1;");
    
    for j=1:Ncols
        for i=1:Nrows
            txt(i,j).BackgroundColor = [.94, .94, .94];
            if A(i,j) == 1                
                txt(i,j).BackgroundColor = evalin('base', 'highlight_color');
            end
        end
    end
catch
end

end
```

### display_error, display_fine: 에러 메시지 구현하기

* 발생 가능한 에러 목록을 만들어본다.
  * 행렬 크기가 잘못된 경우 (정수가 아니거나 숫자가 아니거나)
  * 인덱스 표현식이 잘못된 경우 (범위를 벗어났거나 표현이 잘못됐거나)

