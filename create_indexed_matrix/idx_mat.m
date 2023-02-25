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
