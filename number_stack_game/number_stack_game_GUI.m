function number_stack_game_GUI()
% Applied a simple GUI to the number stack game!

%% default params

% size of grid
h = 10;
n_slots = 5;

% initialize
board = zeros(h, n_slots);
score = 0;
timeout = 60;
t0 = tic;

% position of grid
grid_left = 0.03;
grid_bottom = 0.15;
grid_width = 0.95;
grid_height = 0.75;

% started_flag
started = 0;

%% figure object

hf = figure('color',[.95, .95, .95],...
    'MenuBar', 'none', ...
    'ToolBar', 'none', ...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'Resize', 'on', ...
    'PaperOrientation', 'landscape', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.00 0.04 .96 .96], ...
    'PaperPositionMode', 'manual', ...
    'Position', [ 0.1    0.2    0.14    0.6], ...
    'Name', 'Number Stack Game');


%% menubar

m_new_game = uimenu(hf, 'Text', 'New Game');
uimenu(m_new_game, ...
    'Text', 'New Game', ...
    'Accelerator', 'N', ...
    'MenuSelectedFcn', @new_game ...
    );

m_about = uimenu(hf, 'Text', 'About');
uimenu(m_about, 'Text', 'About', ...
    'MenuSelectedFcn', @show_about_window);

[about_image, ~, transparency] = imread('https://github.com/keizikang/MATLAB/blob/main/color_guess_game/about_image.png?raw=true');
about_image = imresize(about_image, 0.8);
transparency = imresize(transparency, 0.8);


%% create layout

% text: time left
txt_timer = uicontrol(...
    'Parent', hf, ...
    'Style', 'text', ...
    'String', 'time left: 60.0 s', ...
    'BackgroundColor', [.95, .95, .95], ...
    'FontSize', 16, ...
    'units', 'normalized', ...
    'position', [0.17    0.87    0.68    0.10]);

% display matrix as grid
display_board();

% text: score
txt_score = uicontrol(...
    'Parent', hf, ...
    'Style', 'text', ...
    'String', 'score = 0', ...
    'BackgroundColor', [.95, .95, .95], ...
    'FontSize', 20, ...
    'units', 'normalized', ...
    'position', [0.04    0.04    0.61    0.06]);

% edit: index input
edit_cmd = uicontrol(...
    'Parent', hf, ...
    'Style', 'edit', ...
    'FontSize', 20, ...
    'units', 'normalized', ...
    'position', [0.70    0.03    0.25    0.08], ...
    'Callback', @do_something);

%% function: display matrix as grid

    function display_board()
        cell_width = grid_width/n_slots;
        cell_height = grid_height/h;

        txt = gobjects(h, n_slots);
        for j = 1:n_slots
            for i = 1:h
                left = grid_left + cell_width*(j-1);
                bottom = grid_bottom + grid_height - cell_height*i;
                if board(i, j) == 0
                    str = ' ';
                else
                    str = string(board(i, j));
                end
                txt(i,j) = uicontrol(...
                    'Parent', hf, ...
                    'Style', 'edit', ...
                    'String', str, ...
                    'Units', 'normalized', ...
                    'Position', [left    bottom    cell_width*0.99    cell_height*0.99], ...
                    'FontSize', 18);
            end
        end
    end

%% do something for input command

    function do_something(s, ~, ~)
        cmd = s.String;
        if length(cmd) == 2
            board = move(cmd, board);
        elseif cmd == 'd'
            board = deal(board);
            if started == 0
                started = 1;
                t0 = tic;
            end
        elseif cmd == 'm'
            [board, score] = merge(board, score);
        end
        display_board()
        s.String = '';
        txt_score.String = "score = " + score;
        time_left = timeout - toc(t0);
        if started == 1
            txt_timer.String = "time left: " + round(time_left, 1) + " s";
        end
        if time_left <= 0
            txt_timer.ForegroundColor = 'r';
            txt_score.ForegroundColor = 'b';
            started = 0;
            score = 0;
            edit_cmd.Enable = "off";
        end
    end

%% put new numbers on board

    function board = deal(board)
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

%% update board by dealing new numbers

    function board = update_board(to_deal, board)
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

%% move number from source column to target column

    function board = move(cmd, board)
        try
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

%% full column -> two higher numbers

    function [board, score] = merge(board, score)
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


%% start a new game

    function new_game(~, ~)
        board = zeros(h, n_slots);
        display_board()
        started = 0;
        score = 0;
        edit_cmd.Enable = "on";
        txt_timer.ForegroundColor = 'k';
        txt_timer.String = 'time left: 60.0 s';
        txt_score.ForegroundColor = 'k';
        txt_score.String = 'score = 0';
    end

%% show "about" window

    function show_about_window(~,~)
        if isempty(findobj('type', 'figure', 'tag', 'about'))
            h_about_figure = figure('color','w',...
                'Units', 'normalized', ...
                'Resize', 'off', ...
                'MenuBar', 'none', ...
                'ToolBar', 'none', ...
                'Tag', 'about', ...
                'NumberTitle', 'off', ...
                'Name', 'About' ...
                );
            h_about_figure.Position(3:4) = [0.1833 0.2380];
            axes('Units', 'normalized', ...
                'Position', [0, 0.1, 1, .9])
            h_about_image = imshow(about_image);
            h_about_image.AlphaData = transparency;
            h_about_image.ButtonDownFcn = @(~,~) web('https://github.com/keizikang/lazymatlab/tree/master/number_stack_game');
        else
            figure(findobj('type', 'figure', 'tag', 'about'))
        end
    end

end