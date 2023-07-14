function temp_values = simulate(size, p, x_start, y_start)
    temp_values = [];

    n = 4000; % Number of viruses
    nVirus = 1;

    % Food concentration array
    C = zeros(size);
    temp = zeros(size);

    % Setting omega parameter
    w = 1.89;

    % Grow array marks locations where the viruses grow
    grow = zeros(size);
    grow(x_start, y_start) = 1;

    % Setting default food
    for i = 2:size-1
        for j = 2:size-1
            C(i, j) = 1;
        end
    end

    C(x_start, y_start) = 0;

    while true
        candidate = zeros(size);
        sumOfChance = 0;

        % SOR method to calculate at step k+1
        for i = 2:size-1
            for j = 2:size-1
                if C(i, j) ~= 0
                    C(i, j) = (w/4) * (C(i+1, j) + C(i-1, j) + C(i, j+1) + C(i, j-1)) + (1-w) * C(i, j);
                end

                if C(i, j) < 0
                    temp(i, j) = 0;
                else
                    temp(i, j) = C(i, j);
                end
            end
        end

        % Find candidates
        for i = 2:size-1
            for j = 2:size-1
                if grow(i, j) == 1
                    C(i, j) = 0;
                    if grow(i-1, j) == 0 && candidate(i-1, j) == 0
                        candidate(i-1, j) = 1;
                    end
                    if grow(i+1, j) == 0 && candidate(i+1, j) == 0
                        candidate(i+1, j) = 1;
                    end
                    if grow(i, j-1) == 0 && candidate(i, j-1) == 0
                        candidate(i, j-1) = 1;
                    end
                    if grow(i, j+1) == 0 && candidate(i, j+1) == 0
                        candidate(i, j+1) = 1;
                    end
                end
            end
        end

        % Calculate the denominator of P
        for i = 2:size-1
            for j = 2:size-1
                if candidate(i, j) == 1
                    sumOfChance = sumOfChance + C(i, j)^p;
                end
            end
        end

        % Random grow
        for i = 2:size-1
            for j = 2:size-1
                if candidate(i, j) == 1
                    randPos = rand() / 10;
                    curChance = (C(i, j)^p) / sumOfChance;
                    if randPos < curChance
                        grow(i, j) = 1;
                        if nVirus < 4000
                            nVirus = nVirus + 1;
                        end
                    end
                end
            end
        end

        temp_values = cat(3, temp_values, temp);
        fprintf('%d', nVirus);

        if nVirus == 4000
            break;
        end
    end

    save('temp_values.mat', 'temp_values');
end
