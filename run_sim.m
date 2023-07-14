function run_sim(size, p, x_start, y_start, name)
    filename = sprintf('%dx%dp%dplot%s', size-1, p, name);
    try
        % Load the array from the file if exist
        load(['data/', filename, '.mat'], 'temp_values');
    catch
        temp_values = simulate(size, p, x_start, y_start);
        save(['data/', filename, '.mat'], 'temp_values');
    end

    temp = temp_values(:, :, end);

    x = 1:size;
    y = 1:size;
    [X, Y] = meshgrid(x, y);

    fig = figure;
    ax = subplot(1, 2, 1);
    surf(X, Y, temp, 'EdgeColor', 'none');
    view(-120, 30);

    ax_top = subplot(1, 2, 2);
    contourf(X, Y, temp);
    view(-90, 90);
    set(ax_top, 'ztick', []);

    saveas(fig, [filename, '.png']);
    close(fig);
end
