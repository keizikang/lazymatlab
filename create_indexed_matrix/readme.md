# 인덱스 행렬 만들기

* symbolic을 이용하는 방법

```matlab
>> A = sym('A', [2, 4])
A =
[A1_1, A1_2, A1_3, A1_4]
[A2_1, A2_2, A2_3, A2_4]
```

* ndgrid를 이용하는 방법

```matlab
function arr = idx_mat(varargin)

arr_cell = cell(nargin, 1);
idx = cell(nargin, 1);

for i=1:nargin
    idx{i} = 1:varargin{i};
end

[arr_cell{:}] = ndgrid(idx{:});

arr = zeros(varargin{:});

for i=1:nargin
    arr = arr + 10^(nargin-i)*arr_cell{i};
end

end
```

```matlab
>> idx_mat(3, 4)
ans =
    11    12    13    14
    21    22    23    24
    31    32    33    34
>> idx_mat(3, 4, 2)
ans(:,:,1) =
   111   121   131   141
   211   221   231   241
   311   321   331   341
ans(:,:,2) =
   112   122   132   142
   212   222   232   242
   312   322   332   342
```

