classdef turtle < handle
    properties (GetAccess = public, SetAccess = private, SetObservable)
        x = 0
        y = 0
        q = 0
    end
    properties (SetAccess = public)
        speed (1, 1) double = 500
    end
    properties (GetAccess = private)
        speed_reg = 100
        n_steps = 20
        ax
        l
        ht
        im
        is_pen_up = false
        is_filling = false
        fill_color
        fill_alpha
    end

    methods
        function obj = turtle()
            figure(Name='MATurtle', NumberTitle='off')
            obj.ax = axes(box="on");
            hold on,
            obj.ht = hgtransform();
            icon = flipud(imread('turtle.png'));
            obj.im = imagesc(obj.ht, icon, ...
                XData=[-30, 30], YData=[-30, 30], ...
                AlphaData=(255 - double(rgb2gray(icon)))/255);
            obj.l = plot(obj.x, obj.y, 'k');
            obj.ax.XLim = [-500, 500];
            obj.ax.YLim = [-500, 500];
            obj.ax.DataAspectRatio = [1, 1, 1];
            obj.ax.Toolbar.Visible = 'off';
            disableDefaultInteractivity(obj.ax);
        end

        function home(obj)
            obj.x = 0;
            obj.y = 0;
            obj.ht.Matrix = eye(4);
        end

        function forward(obj, dist)
            obj.step(dist);
        end

        function backward(obj, dist)
            obj.step(-dist)
        end

        function step(obj, delta)
            if numel(delta) == 1
                delta = delta*[cosd(obj.q), sind(obj.q)];
            end
            if obj.is_filling
                obj.fill(delta);
            else
                obj.move(delta);
            end            
        end

        function goto(obj, x, y)
            dx = x - obj.x;
            dy = y - obj.y;
            obj.turnto(rad2deg(atan2(dy, dx)));
            obj.step([dx, dy]);
        end
            
        function left(obj, q)
            obj.turn(q);
        end

        function right(obj, q)
            obj.turn(-q);
        end

        function turnto(obj, q)
            obj.turn(obj.wrap_angle(q - obj.q, -180));
        end

        function pen_up(obj)
            if obj.is_filling
                warning('not available while filling')
                return
            end
            obj.is_pen_up = true;
        end

        function pen_down(obj, go)
            if obj.is_pen_up
                if nargin == 1
                    obj.l(end+1) = plot(obj.x, obj.y, Color=obj.l(end).Color);
                else
                    obj.l(end+1) = go;
                end
                uistack(obj.ht, 'top')
            end
            obj.is_pen_up = false;
        end

        function color(obj, line_color)
            if obj.is_filling
                warning('not available while filling')
                return
            end
            obj.pen_up();
            obj.pen_down(plot(obj.x, obj.y, Color=line_color));
        end

        function begin_fill(obj, FaceColor, EdgeColor, FaceAlpha)
            arguments
                obj
                FaceColor = [.6, .9, .6];
                EdgeColor = [0 0.4470 0.7410];
                FaceAlpha = 1;
            end
            if obj.is_filling
                warning('already filling')
                return
            end
            obj.fill_color = FaceColor;
            obj.fill_alpha = FaceAlpha;
            obj.pen_up();
            obj.pen_down(patch(obj.x, obj.y, [1, 1, 1], ...
                EdgeColor=EdgeColor, FaceAlpha=0));
            obj.is_filling = true;
        end

        function end_fill(obj)
            if ~obj.is_filling
                warning('not filling now')
                return
            end
            obj.l(end).FaceColor = obj.fill_color;
            obj.l(end).FaceAlpha = obj.fill_alpha;
            obj.is_filling = false;
        end

        function change_icon(obj, filename)
            icon = flipud(imread(filename));
            obj.im.CData = icon;
            obj.im.AlphaData = (255 - double(rgb2gray(icon)))/255;
        end

        function clear(obj)
            obj.x = 0;
            obj.y = 0;
            delete(obj.ax.Children(2:end));
            obj.l = plot(0, 0, 'k');
            obj.ht.Matrix = eye(4);
        end
    end

    methods (Access = private)
        function animated_step(obj, delta, q, initFcn, updateFcn)
            arguments
                obj
                delta
                q
                initFcn = @() []
                updateFcn = @(~, ~) []
            end
            dx = delta(1)/obj.n_steps;
            dy = delta(2)/obj.n_steps;
            dq = q/obj.n_steps;
            pause_duration = norm(delta)/obj.speed/obj.speed_reg;
            initFcn();

            for i = 1:obj.n_steps
                updateFcn(dx, dy);

                obj.ht.Matrix = makehgtform(...
                    translate=[obj.x + dx*i, obj.y + dy*i, 0], ...
                    zrotate=deg2rad(obj.q + dq*i));
                pause(pause_duration)
                drawnow limitrate
            end

            obj.x = obj.x + delta(1);
            obj.y = obj.y + delta(2);
        end

        function obj = turn(obj, q)
            obj.animated_step([0, 0], q);
            obj.q = obj.wrap_angle(obj.q + q, 0);
        end

        function move(obj, delta)
            initFcn = @() [];
            updateFcn = @(dx, dy) [];

            if ~obj.is_pen_up
                initFcn = @() initializeLine();
                updateFcn = @(dx, dy) obj.update_end_point(obj.l(end), dx, dy);
            end

            function initializeLine()
                obj.l(end).XData(end+1) = obj.l(end).XData(end);
                obj.l(end).YData(end+1) = obj.l(end).YData(end);
            end

            obj.animated_step(delta, 0, initFcn, updateFcn);
        end

        function obj = fill(obj, delta)
            initFcn = @() initializePatch();
            updateFcn = @(dx, dy) obj.update_end_point(obj.l(end), dx, dy);

            function initializePatch()
                obj.l(end).Vertices(end+1, :) = obj.l(end).Vertices(end, :);
                obj.l(end).Faces = 1:size(obj.l(end).Vertices, 1);
            end

            obj.animated_step(delta, 0, initFcn, updateFcn);
        end
    end

    methods (Static, Access = private)
        function update_end_point(l, dx, dy)
            l.XData(end) = l.XData(end) + dx;
            l.YData(end) = l.YData(end) + dy;
        end

        function q = wrap_angle(q, min_angle)
            q = mod(q - min_angle, 360) + min_angle;
        end
    end
    
end
