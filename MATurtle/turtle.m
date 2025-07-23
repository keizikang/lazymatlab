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
                XData=[-30, 30], YData=[-30, 30]);
            obj.im.AlphaData = (255 - double(rgb2gray(icon)))/255;
            obj.l = plot(obj.x, obj.y, 'k');
            obj.ax.XLim = [-500, 500];
            obj.ax.YLim = [-500, 500];
            obj.ax.DataAspectRatio = [1, 1, 1];
            obj.ax.Toolbar.Visible = 'off';
            disableDefaultInteractivity(obj.ax);
        end

        function obj = home(obj)
            obj.x = 0;
            obj.y = 0;
            obj.ht.Matrix = eye(4);
        end

        function obj = forward(obj, dist)
            delta = dist*[cosd(obj.q), sind(obj.q)];
            if obj.is_filling
                obj.fill(delta);
            else
                obj.move(delta);
            end
        end

        function obj = backward(obj, dist)
            delta = dist*[cosd(obj.q + 180), sind(obj.q + 180)];
            if obj.is_filling
                obj.fill(delta);
            else
                obj.move(delta);
            end
        end

        function obj = left(obj, q)
            obj.turn(q);
        end

        function obj = right(obj, q)
            obj = obj.turn(-q);
        end

        function obj = turnto(obj, q)
            dq = mod(q - obj.q + 180, 360) - 180;
            obj.turn(dq);
        end

        function obj = goto(obj, x, y)
            dx = x - obj.x;
            dy = y - obj.y;
            dq = rad2deg(atan2(dy, dx)) - obj.q;
            dq = mod(dq + 180, 360) - 180;
            obj.turn(dq);
            if obj.is_filling
                obj.fill([dx, dy]);
            else
                obj.move([dx, dy]);
            end
        end
            
        function obj = pen_up(obj)
            if obj.is_filling
                warning('not available while filling')
                return
            end
            obj.is_pen_up = true;
        end

        function obj = pen_down(obj, go)
            if obj.is_pen_up
                if nargin == 1
                    line_color = obj.l(end).Color;
                    obj.l(end+1) = plot(obj.x, obj.y, Color=line_color);
                else
                    obj.l(end+1) = go;
                end
                uistack(obj.ht, 'top')
            end
            obj.is_pen_up = false;
        end

        function obj = color(obj, line_color)
            if obj.is_filling
                warning('not available while filling')
                return
            end
            obj.pen_up();
            obj.pen_down(plot(obj.x, obj.y, Color=line_color));
        end

        function obj = begin_fill(obj, FaceColor, EdgeColor, FaceAlpha)
            arguments
                obj
                FaceColor = [.6, .9, .6];
                EdgeColor = [0 0.4470 0.7410];
                FaceAlpha = 1;
            end
            obj.fill_color = FaceColor;
            obj.fill_alpha = FaceAlpha;
            obj.pen_up();
            obj.pen_down(patch(obj.x, obj.y, [1, 1, 1], ...
                EdgeColor=EdgeColor, FaceAlpha=0));
            obj.is_filling = true;
        end

        function obj = end_fill(obj)
            if ~obj.is_filling
                warning('not filling now')
                return
            end
            obj.l(end).FaceColor = obj.fill_color;
            obj.l(end).FaceAlpha = obj.fill_alpha;
            obj.is_filling = false;
        end

        function obj = change_icon(obj, filename)
            icon = flipud(imread(filename));
            obj.im.CData = icon;
            obj.im.AlphaData = (255 - double(rgb2gray(icon)))/255;
        end

        function obj = clear(obj)
            obj.x = 0;
            obj.y = 0;
            delete(obj.ax.Children(2:end));
            obj.l = plot(0, 0, 'k');
            obj.ht.Matrix = eye(4);
        end
    end

    methods (Access = private)
        function obj = move(obj, delta)
            dx = delta(1)/obj.n_steps;
            dy = delta(2)/obj.n_steps;

            if obj.is_pen_up
                update_line = @(~) [];
            else
                cur_l = obj.l(end);
                cur_l.XData = [cur_l.XData, cur_l.XData(end)];
                cur_l.YData = [cur_l.YData, cur_l.YData(end)];
                update_line = @() obj.update_end_point(cur_l, dx, dy);                
            end
            for i = 1:obj.n_steps
                update_line();
                obj.ht.Matrix = makehgtform( ...
                    translate=[obj.x + dx*i, obj.y + dy*i, 0], ...
                    zrotate=deg2rad(obj.q));
                pause(norm(delta)/obj.speed/obj.speed_reg)
                drawnow limitrate
            end
            obj.x = obj.x + delta(1);
            obj.y = obj.y + delta(2);
        end
        
        function obj = turn(obj, q)
            for i = 1:obj.n_steps
                dq = q/obj.n_steps;
                obj.ht.Matrix = makehgtform( ...
                    translate=[obj.x, obj.y, 0], ...
                    zrotate=deg2rad(obj.q + dq*i));
                pause(1/obj.speed)
                drawnow limitrate
            end
            obj.q = mod(obj.q + q, 360);
        end

        function obj = fill(obj, delta)
            dx = delta(1)/obj.n_steps;
            dy = delta(2)/obj.n_steps;

            cur_p = obj.l(end);
            cur_p.Vertices = vertcat(cur_p.Vertices, [cur_p.Vertices(end,:)]);
            cur_p.Faces = 1:size(cur_p.Vertices, 1);
            for i = 1:obj.n_steps
                obj.update_end_point(cur_p, dx, dy);                
                obj.ht.Matrix = makehgtform( ...
                    translate=[obj.x + dx*i, obj.y + dy*i, 0], ...
                    zrotate=deg2rad(obj.q));
                pause(norm(delta)/obj.speed/obj.speed_reg)
                drawnow limitrate
            end
            obj.x = obj.x + delta(1);
            obj.y = obj.y + delta(2);
        end

    end

    methods (Static, Access = private)
        function update_end_point(l, dx, dy)
            l.XData(end) = l.XData(end) + dx;
            l.YData(end) = l.YData(end) + dy;
        end
    end
    
end