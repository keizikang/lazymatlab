classdef RR_robot < handle
    % Class for a single RR robot
    properties (Access = public)
        l1_cm; % arm1
        l2_cm; % arm2
        originx_cm = 0; % x coord. of origin
        originy_cm = 0; % y coord. of orogin
        q_deg = 0; % angle of arm1
        p_deg = 0; % angle of arm2
        arm1; % line object for arm1
        arm2; % line object for arm2
    end
    properties (Dependent)
        pos_ee_cm % position of end effector
        pos_me_cm % position of mid effector
    end

    methods

        function obj = RR_robot(l1_cm, l2_cm, options)
            arguments
                l1_cm (1,1) double = 5;
                l2_cm (1,1) double = 15;
                options.originx_cm (1,1) double = 0;
                options.originy_cm (1,1) double = 0;
                options.q_deg (1,1) double = 0;
                options.p_deg (1,1) double = 0;
                options.arm1 = plot(0, 0, 'b', LineWidth=2);
                options.arm2 = plot(0, 0, 'r', LineWidth=2);
            end
            obj.arm1 = options.arm1;
            obj.arm2 = options.arm2;
            obj.l1_cm = l1_cm;
            obj.l2_cm = l2_cm;
            obj.originx_cm = options.originx_cm;
            obj.originy_cm = options.originy_cm;
            obj.q_deg = options.q_deg;
            obj.p_deg = options.p_deg;
        end

        function pos_ee = get.pos_ee_cm(obj)
            mat2 = obj.fk_mat();
            pos_ee = mat2*[obj.l1_cm; obj.l2_cm] + ...
                [obj.originx_cm; obj.originy_cm];
        end

        function pos_me = get.pos_me_cm(obj)
            [~, mat1] = obj.fk_mat();
            pos_me = mat1*[obj.l1_cm; 0] + ...
                [obj.originx_cm; obj.originy_cm];
        end

        function set.q_deg(obj, q_deg)
            obj.q_deg = q_deg;
            update_arms(obj);
        end
    
        function set.p_deg(obj, p_deg)
            obj.p_deg = p_deg;
            update_arms(obj);
        end

        function set.originx_cm(obj, originx_cm)
            obj.originx_cm = originx_cm;
            update_arms(obj)
        end

        function set.originy_cm(obj, originy_cm)
            obj.originy_cm = originy_cm;
            update_arms(obj)
        end

        function [q_deg, p_deg, status] = ik(obj, target)
            % inverse kinematics: target -> theta and phi
            % ref: https://robotacademy.net.au/lesson/inverse-kinematics-for-a-2-joint-robot-arm-using-geometry/
            target = target - [obj.originx_cm, obj.originy_cm];
            try
                p_deg = rad2deg(acos(...
                    (dot(target, target)-obj.l1_cm^2-obj.l2_cm^2)/...
                    2/obj.l1_cm/obj.l2_cm));
                q_deg = rad2deg( ...
                    atan2(target(2), target(1)) - ...
                    atan2(obj.l2_cm*sind(p_deg),(obj.l1_cm+obj.l2_cm*cosd(p_deg))));
                status = 0; % no error
            catch ME
                if strcmp(ME.identifier, "MATLAB:atan2:complexArgument")
                    fprintf(2, 'pos_ee out of the workspace\n')
                else
                    keyboard
                end
                q_deg = obj.q_deg;
                p_deg = obj.p_deg;
                status = 1; % ik failed
            end
        end

        function update_arms(obj)
            obj.arm2.XData = [obj.pos_me_cm(1), obj.pos_ee_cm(1)];
            obj.arm2.YData = [obj.pos_me_cm(2), obj.pos_ee_cm(2)];
            obj.arm1.XData = [obj.originx_cm, obj.pos_me_cm(1)];
            obj.arm1.YData = [obj.originy_cm, obj.pos_me_cm(2)];
        end

        function [mat2, mat1] = fk_mat(obj)
            % matrices for forward kinematics
            % mat2: for end-effector
            % mat1: for mid-effector (end of arm1)
            mat2 = [
                cosd(obj.q_deg), cosd(obj.q_deg+obj.p_deg);
                sind(obj.q_deg), sind(obj.q_deg+obj.p_deg)
                ];
            mat1 = [
                cosd(obj.q_deg), -sind(obj.q_deg);
                sind(obj.q_deg), cosd(obj.q_deg)
                ];
        end

        function draw_workspace(obj, ax)
            if nargin<2
                ax = gca;
            end
            q = linspace(0, 2*pi);
            plot(ax, obj.originx_cm + (obj.l2_cm - obj.l1_cm)*cos(q), ...
                obj.originy_cm + (obj.l2_cm - obj.l1_cm)*sin(q))
            plot(ax, obj.originx_cm + (obj.l2_cm + obj.l1_cm)*cos(q), ...
                obj.originy_cm + (obj.l2_cm + obj.l1_cm)*sin(q))
        end

    end
end
