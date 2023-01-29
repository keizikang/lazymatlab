ccc

l1_cm = 5;
l2_cm = 12;

figure, hold on, axis equal, box on
title('right click to terminate')
xlim([-25, 25])
ylim([-25, 25])

a = RR_robot(l1_cm, l2_cm);
a.draw_workspace;
ee = plot(a.pos_ee_cm(1), a.pos_ee_cm(2), 'go');

[
    txt_pos_x, ...
    txt_pos_y, ...
    txt_ang_q, ...
    txt_ang_p ...
    ] = create_layout(a);

while true
    [x, y, button] = ginput(1);
    if button==3
        break
    end
    ee.XData = x;
    ee.YData = y;
    [q, p] = a.ik([x, y]);
    a.q_deg = q;
    a.p_deg = p;
    txt_pos_x.String = "x: " + sprintf('%.2f', x);
    txt_pos_y.String = "y: " + sprintf('%.2f', y);
    txt_ang_q.String = "θ: " + sprintf('%.2f', q);
    txt_ang_p.String = "φ: " + sprintf('%.2f', p);  
end

function varargout = create_layout(a)
uicontrol(...
    'Parent', gcf, ...
    'Style', 'text', ...
    'String', 'EE pos.', ...
    'FontSize', 16, ...
    'units', 'normalized', ...
    'position', [0.84 0.87 0.16 0.06]);
text_pos_x = uicontrol(...
    'Parent', gcf, ...
    'Style', 'text', ...
    'String', "x: " + string(a.pos_ee_cm(1)), ...
    'HorizontalAlignment', 'left', ...
    'Tag', 'pos_ee_x', ...
    'FontSize', 10, ...
    'units', 'normalized', ...
    'position', [0.85 0.79 0.11 0.06]);
text_pos_y = uicontrol(...
    'Parent', gcf, ...
    'Style', 'text', ...
    'String', "y: " + string(a.pos_ee_cm(2)), ...
    'HorizontalAlignment', 'left', ...
    'Tag', 'pos_ee_y', ...
    'FontSize', 10, ...
    'units', 'normalized', ...
    'position', [0.85 0.73 0.11 0.06]);

uicontrol(...
    'Parent', gcf, ...
    'Style', 'text', ...
    'String', 'Angles', ...
    'FontSize', 16, ...
    'units', 'normalized', ...
    'position', [0.84 0.61 0.16 0.06]);
text_ang_q = uicontrol(...
    'Parent', gcf, ...
    'Style', 'text', ...
    'String', "θ: " + string(a.q_deg), ...
    'HorizontalAlignment', 'left', ...
    'Tag', 'pos_ee_x', ...
    'FontSize', 10, ...
    'units', 'normalized', ...
    'position', [0.85 0.52 0.11 0.06]);
text_ang_p = uicontrol(...
    'Parent', gcf, ...
    'Style', 'text', ...
    'String', "φ: " + string(a.p_deg), ...
    'HorizontalAlignment', 'left', ...
    'Tag', 'pos_ee_y', ...
    'FontSize', 10, ...
    'units', 'normalized', ...
    'position', [0.85 0.45 0.11 0.06]);

varargout = {text_pos_x, text_pos_y, text_ang_q, text_ang_p};
end
