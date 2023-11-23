function number_stack_game()

board = zeros(10, 5);
score = 0;

t0 = tic;
timeout = 60; % sec

while true
    clc
    disp_board(board)
    fprintf('current score: %d\n\n', score)
    fprintf('time left: %.1f sec\n\n', timeout - toc(t0))
    cmd = input('next move? (enter to deal): ', 's');
    if length(cmd) == 2
        board = move(cmd, board);
    elseif isempty(cmd)
        board = deal(board);
    elseif strcmp(cmd, 'm')
        [board, score] = merge(board, score);
    else
        fprintf(2, 'invalid command')
    end
    if toc(t0) > timeout
        fprintf('final score: %d\n', score)
        break
    end
end

end

%%
function board = deal(board)
% put new numbers on board

[~, n_slots] = size(board);

% where to put?
to_place = randsample(n_slots, 4, false)'; % TODO: 4 as a variable?

% how many of 1, 2, 3, 4 to make?
counts = randi([1, 5], [1, 4]); % TODO: 4 as a variable?
to_deal = zeros(max(counts), n_slots);
for j = 1:length(counts)
    for i = 1:counts(j)
        to_deal(i, to_place(j)) = j;
    end
end
to_deal = flipud(to_deal);

% place new numbers
board = update_board(to_deal, board);

end

%%
function board = update_board(to_deal, board)
% update board by dealing new numbers

[h, n_slots] = size(board);

for i = 1:n_slots
    col = board(:, i);
    col = col(col>0);
    col = [to_deal(:, i); col]; 
    % in case of not enough space, put as many as possible and discard the rest.
    if length(col) > h
        col = col(length(col)-h+1:end);
    end

    board(:, i) = [zeros(h-length(col), 1); col];
end

end


%%
function board = move(cmd, board)
% move number from source column to target column

arguments
    cmd (1, 2)
    board
end

try
    h = size(board, 1);

    from = str2double(cmd(1));
    to = str2double(cmd(2));

    col_from = board(:, from);
    col_to = board(:, to);
    col_from = col_from(col_from>0);
    col_to = col_to(col_to>0);

    % if target column is full, do nothing.
    if length(col_to) >= h
        fprintf(2, 'target column is full\n')
        return
    end

    % move numbers one by one
    while length(col_to) < h && ~isempty(col_from)
        % move until (top of 'from' column) ~= (top of 'to' column)
        if ~isempty(col_to) && col_from(1) ~= col_to(1)
            break
        end
        col_to = [col_from(1); col_to];
        col_from(1) = [];
    end
    if isempty(col_from)
        col_from = zeros(h, 1);
    else
        col_from = padarray(col_from, [h-length(col_from), 0], 0, 'pre');
    end
    if isempty(col_to)
        col_to = zeros(h, 1);
    else
        col_to = padarray(col_to, [h-length(col_to), 0], 0, 'pre');
    end
    board(:, from) = col_from;
    board(:, to) = col_to;

catch
    fprintf(2, 'invalid input\n')
    return
end

end

%%

function [board, score] = merge(board, score)
% full column -> two higher numbers

[h, n_slots] = size(board);

for j = 1:n_slots
    if sum(board(:, j)) > 0 && length(unique(board(:, j))) == 1
        score = score + board(1, j);
        % if a column is full of 4's, clear the column.
        if board(1, j) == 4 % TODO: 4 as a variable?
            board(:, j) = 0;
        else
            col = (board(1, j) + 1)*ones(2, 1); % TODO: 2 as a variable?
            col = [zeros(h-2, 1); col];
            board(:, j) = col;
        end
    end
end

end

%%

function disp_board(board)
% function to display the board

for i = 1:size(board, 1)
    fprintf('\t')
    for j = 1:size(board, 2)
        if board(i, j) == 0
            fprintf('.\t')
        else
            fprintf('%d\t', board(i, j))
        end
    end
    fprintf('\n')
end
fprintf('\n')
end