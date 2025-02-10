function [best_fitness,Convergence_curve,best_position,time ]=LO(lemurs_position,fitness_function,lb, ub, max_iterations )
% Lemurs Optimizer (LO) MATLAB Code
% Parameters
[num_lemurs,num_dimensions] = size(lemurs_position); % Number of dimensions in the search space
alpha = 0.5; % Exploration factor
beta = 0.5; % Exploitation factor
% Main Loop
for iteration = 1:max_iterations
    % Evaluate Fitness
    fitness_values = feval(fitness_function, lemurs_position);   
    % Sort Lemurs based on Fitness
    [~, sorted_indices] = sort(fitness_values);
    lemurs_position = lemurs_position(sorted_indices, :);   
    % Update Lemurs' Positions
    for i = 1:num_lemurs
        for j = 1:num_dimensions
            explore_term = alpha * rand() * (rand() - 0.5);
            exploit_term = beta * rand() * (lemurs_position(end, j) - lemurs_position(i, j));
            lemurs_position(i, j) = lemurs_position(i, j) + explore_term + exploit_term;
        end
    end
        % Get the Best Solution
    best_position = lemurs_position(1, :);
    best_fitness = fitness_function(best_position);
    Convergence_curve(iteration) = best_fitness;
time = toc;
end




