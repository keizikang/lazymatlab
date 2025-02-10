function set_xy_graph(ax)

arguments
    ax = gca
end

ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
axis equal