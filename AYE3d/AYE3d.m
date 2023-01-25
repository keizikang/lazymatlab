function AYE3d()

% colorcode
colors.cube_default = [.9, .9, .9]; % lightgray
colors.cube_highlight = 'g'; % light green
colors.msg_fine = [0, 100, 0]/255; % dark green
colors.msg_error = [1, 0, 0]; % red

% grid size
sizeX = 3;
sizeY = 4;
sizeZ = 5;
sz = [sizeX, sizeY, sizeZ];

% miscell
cubesize = 0.9*ones(1,3);

% Figure and Axes setting
hf = figure('color',[.95, .95, .95],...
    'MenuBar', 'none', ...
    'ToolBar', 'figure', ...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'Resize', 'off', ...
    'Position', [ 0.3536    0.3157    0.2917    0.5889], ...
    'Name', 'AYE3d (Aids Your indExing 3d)');
toolbar = allchild(hf);
toolbar.Visible = 'off';

ax = axes;
ax.Position = [0.18 0.22 0.66 0.60];
ax.XTick = 1:sizeX;
ax.YTick = 1:sizeY;
ax.ZTick = 1:sizeZ;
xlabel('axis1')
ylabel('axis2')
zlabel('axis3')
axis equal, box on
adjust_axes()
ax.View = [47 37];

% create cube grid
cube_grid = gobjects(6, sizeX, sizeY, sizeZ);
display_grid()

%% create layout

% text: title
uicontrol(...
    'Parent', hf, ...
    'Style', 'text', ...
    'String', 'AYE3d (Aids Your indExing 3d)', ...
    'BackgroundColor', [.95, .95, .95], ...
    'FontSize', 20, ...
    'units', 'normalized', ...
    'position', [0.15 0.88 0.72 0.10]);

% text: size of A
uicontrol(...
    'Parent', hf, ...
    'Style', 'text', ...
    'String', 'size of A: ', ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [.95, .95, .95], ...
    'FontSize', 18, ...
    'units', 'normalized', ...
    'position', [0.19 0.81 0.22 0.10]);

% edit: axis1 size
uicontrol(...
    'Parent', hf, ...
    'Style', 'edit', ...
    'String', string(sizeX), ...
    'Tag', 'sizeX', ...
    'BackgroundColor', [1, 1, 1], ...
    'FontSize', 16, ...
    'units', 'normalized', ...
    'position', [0.38 0.85 0.06 0.06], ...
    'Callback', @change_grid_size);

% text: x
uicontrol(...
    'Parent', hf, ...
    'Style', 'text', ...
    'String', 'x', ...
    'BackgroundColor', [.95, .95, .95], ...
    'FontSize', 20, ...
    'units', 'normalized', ...
    'position', [0.44 0.86 0.05 0.05]);

% edit: axis2 size
uicontrol(...
    'Parent', hf, ...
    'Style', 'edit', ...
    'String', string(sizeY), ...
    'Tag', 'sizeY', ...
    'BackgroundColor', [1, 1, 1], ...
    'FontSize', 16, ...
    'units', 'normalized', ...
    'position', [0.49 0.85 0.06 0.06], ...
    'Callback', @change_grid_size);

% text: x
uicontrol(...
    'Parent', hf, ...
    'Style', 'text', ...
    'String', 'x', ...
    'BackgroundColor', [.95, .95, .95], ...
    'FontSize', 20, ...
    'units', 'normalized', ...
    'position', [0.55 0.86 0.05 0.05]);

% edit: axis3 size
uicontrol(...
    'Parent', hf, ...
    'Style', 'edit', ...
    'String', string(sizeZ), ...
    'Tag', 'sizeZ', ...
    'BackgroundColor', [1, 1, 1], ...
    'FontSize', 16, ...
    'units', 'normalized', ...
    'position', [0.60 0.85 0.06 0.06], ...
    'Callback', @change_grid_size);

% text: user input background
uicontrol(...
    'Parent', hf, ...
    'Style', 'text', ...
    'String', 'A(                                               )', ...
    'BackgroundColor', [.95, .95, .95], ...
    'FontSize', 16, ...
    'units', 'normalized', ...
    'position', [0.06 0.11 0.84 0.06]);

% edit: index input
edit_index_input = uicontrol(...
    'Parent', hf, ...
    'Style', 'edit', ...
    'FontSize', 16, ...
    'units', 'normalized', ...
    'position', [0.27 0.12 0.44 0.05], ...
    'Callback', @highlight);

% cbox: show index 1d
cbox_1d_index = uicontrol(...
    'Parent', hf, ...
    'Style', 'checkbox', ...
    'units', 'normalized', ...
    'FontSize', 14, ...
    'String', '1D index', ...
    'position', [0.78 0.12 0.18 0.05], ...
    'Callback', @change_ind_sub);

% text: error message
txt_error = uicontrol(...
    'Parent', hf, ...
    'Style', 'text', ...
    'String', 'Everything is fine.', ...
    'HorizontalAlignment', 'left', ...
    'ForegroundColor', colors.msg_fine, ...
    'BackgroundColor', [.9, .9, .9], ...
    'FontSize', 18, ...
    'units', 'normalized', ...
    'position', [0.0553    0.04    0.8357    0.0547]);

%% function: display matrix as grid

    function display_grid()
        
        if exist('cube_grid', 'var')
            delete(evalin('caller', 'cube_grid'))
        end
        cube_grid = gobjects(6, sizeX, sizeY, sizeZ);
        for k=1:sizeZ
            for j=1:sizeY
                for i=1:sizeX
                    cube_origin = [i-.5, j-.5, k-.5];
                    cube_grid(:, i, j, k) = plotcube(cubesize, cube_origin);
                end
            end
        end
    end

%% change grid size

    function change_grid_size(s, ~, ~)

        try
            zeros(str2double(s.String), 1);
        catch
            display_error('error: invalid matrix size');
            return
        end

        % change base variables
        switch s.Tag
            case 'sizeX'
                sizeX = str2double(s.String);
            case 'sizeY'
                sizeY = str2double(s.String);
            case 'sizeZ'
                sizeZ = str2double(s.String);
        end
        sz = [sizeX, sizeY, sizeZ];

        % change grid size
        display_grid();
        display_fine()

        % adjust axes
        adjust_axes()
    end

%% highlight selected cubes

    function highlight(s, ~, ~)

        try
            A = zeros(sizeX, sizeY, sizeZ);
            eval("A(" + s.String + ");"); % to check if index is within the range
            eval("A(" + s.String + ") = 1;");

            for kk=1:sizeZ
                for jj=1:sizeY
                    for ii=1:sizeX
                        for ff = 1:6
                            if A(ii,jj,kk) == 1
                                cube_grid(ff,ii,jj,kk).FaceColor = colors.cube_highlight;
                                cube_grid(ff,ii,jj,kk).FaceAlpha = 1;
                            else
                                cube_grid(ff,ii,jj,kk).FaceColor = colors.cube_default;
                                cube_grid(ff,ii,jj,kk).FaceAlpha = 0.3;
                            end
                        end
                    end
                end
            end
            display_fine()
        catch ME
            if strcmp(ME.identifier, 'MATLAB:badsubscript')
                msg = 'error: index out of range';
            elseif strcmp(ME.identifier, 'MATLAB:UndefinedFunction')
                msg = 'error: uninterpretable index input';
            else
                msg = 'error: unknown';
            end
            display_error(msg)
        end
        cbox_1d_index.Enable = 'off';

    end

%% draw cube and return patches (faces)

    function faces = plotcube(varargin)
        % PLOTCUBE - Display a 3D-cube in the current axes
        %
        %   PLOTCUBE(EDGES,ORIGIN,ALPHA,COLOR) displays a 3D-cube in the current axes
        %   with the following properties:
        %   * EDGES : 3-elements vector that defines the length of cube edges
        %   * ORIGIN: 3-elements vector that defines the start point of the cube
        %   * ALPHA : scalar that defines the transparency of the cube faces (from 0
        %             to 1)
        %   * COLOR : 3-elements vector that defines the faces color of the cube
        %
        % Example:
        %   >> plotcube([5 5 5],[ 2  2  2],.8,[1 0 0]);
        %   >> plotcube([5 5 5],[10 10 10],.8,[0 1 0]);
        %   >> plotcube([5 5 5],[20 20 20],.8,[0 0 1]);
        % ref: https://www.mathworks.com/matlabcentral/fileexchange/15161-plotcube

        % Default input arguments
        inArgs = { ...
            [10 56 100] , ... % Default edge sizes (x,y and z)
            [10 10  10] , ... % Default coordinates of the origin point of the cube
            .3          , ... % Default alpha value for the cube's faces
            colors.cube_default,       ... % Default Color for the cube
            };
        % Replace default input arguments by input values
        inArgs(1:nargin) = varargin;
        % Create all variables
        [edges,origin,alpha,clr] = deal(inArgs{:});
        XYZ = { ...
            [0 0 0 0]  [0 0 1 1]  [0 1 1 0] ; ...
            [1 1 1 1]  [0 0 1 1]  [0 1 1 0] ; ...
            [0 1 1 0]  [0 0 0 0]  [0 0 1 1] ; ...
            [0 1 1 0]  [1 1 1 1]  [0 0 1 1] ; ...
            [0 1 1 0]  [0 0 1 1]  [0 0 0 0] ; ...
            [0 1 1 0]  [0 0 1 1]  [1 1 1 1]   ...
            };
        XYZ = mat2cell(...
            cellfun( @(x,y,z) x*y+z , ...
            XYZ , ...
            repmat(num2cell(edges),6,1) , ...
            repmat(num2cell(origin),6,1) , ...
            'UniformOutput',false), ...
            6,[1 1 1]);
        faces = gobjects(1, 6);
        for n=1:6
            faces(n) = patch(XYZ{1}{n},XYZ{2}{n},XYZ{3}{n},...
                clr, 'FaceAlpha', alpha, ...
                'ButtonDownFcn', @show_index);
        end
    end

%% adjust Axes 

    function adjust_axes
        ax.XLim = [0, sizeX+1];
        ax.YLim = [0, sizeY+1];
        ax.ZLim = [0, sizeZ+1];
        ax.XTick = 1:sizeX;
        ax.YTick = 1:sizeY;
        ax.ZTick = 1:sizeZ;
    end

%% display error status

    function display_error(msg)

        txt_error.String = msg;
        txt_error.ForegroundColor = colors.msg_error;

    end

%% display fine status

    function display_fine()

        txt_error.String = 'Everything is fine.';
        txt_error.ForegroundColor = colors.msg_fine;

    end

%% show index of selected cell

    function show_index(s, ~, ~)
        idx = ceil(find(cube_grid==s)/6);
        [p1, p2, p3] = ind2sub(...
            [sizeX, sizeY, sizeZ], idx);
        for i=1:numel(cube_grid)
            cube_grid(i).FaceColor = colors.cube_default;
            cube_grid(i).FaceAlpha = .3;
        end
        for i=1:6
            cube_grid(i, p1, p2, p3).FaceColor = colors.cube_highlight;
            cube_grid(i, p1, p2, p3).FaceAlpha = 1;
        end
        if cbox_1d_index.Value
            idx_string = num2str(idx);
        else
            idx_string = sprintf(...
            '%d,%d,%d',p1, p2, p3);
        end
        edit_index_input.String = idx_string;
        cbox_1d_index.Enable = 'on';
    end

%% change index <-> subscript

    function change_ind_sub(s, ~, ~)
        if s.Value % sub -> ind
            p = zeros(1,3);
            [p(:)] = deal(cellfun(@str2double,split(edit_index_input.String,','))');
            edit_index_input.String = num2str(sub2ind(sz, p(1), p(2), p(3)));
        else % ind -> sub
            [p1, p2, p3] = ind2sub(sz, str2double(edit_index_input.String));
            edit_index_input.String = string([p1, p2, p3]).join(",");
        end
    end
end