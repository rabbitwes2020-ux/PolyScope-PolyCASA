function errorbar3(x, y, z, ex, ey, ez, color)
    % Function to plot 3D error bars
    hold on;
    for i = 1:length(x)
        % Plot error bars in x direction
        plot3([x(i) - ex(i), x(i) + ex(i)], [y(i), y(i)], [z(i), z(i)], 'Color', color);
        % Plot error bars in y direction
        plot3([x(i), x(i)], [y(i) - ey(i), y(i) + ey(i)], [z(i), z(i)], 'Color', color);
        % Plot error bars in z direction
        plot3([x(i), x(i)], [y(i), y(i)], [z(i) - ez(i), z(i) + ez(i)], 'Color', color);
    end
end