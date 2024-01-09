clc;
clear all;


prompt = {'Number of nodes:', 'Network length:', 'Network width:', 'Number of obstacles:', 'Number of source-destination pairs:', 'Number of iterations:'};
dlgtitle = 'User Input';
dims = [1 50];
definput = {'10', '1000', '1000', '5', '3', '10'};
user_input = inputdlg(prompt, dlgtitle, dims, definput);

no_nodes = str2double(user_input{1});
net_length = str2double(user_input{2});
net_width = str2double(user_input{3});
num_obstacles = str2double(user_input{4});
num_pairs = str2double(user_input{5});
num_iterations = str2double(user_input{6});


x_loc = net_length * rand(1, no_nodes);
y_loc = net_width * rand(1, no_nodes);

% Number of obstacles
num_obstacles = 5;


obstacle_x = net_length * rand(1, num_obstacles);
obstacle_y = net_width * rand(1, num_obstacles);

% Number of source-destination pairs
num_pairs = 3;


sources = round(no_nodes * rand(1, num_pairs));
destinations = round(no_nodes * rand(1, num_pairs));


while any(sources == destinations)
    destinations = round(no_nodes * rand(1, num_pairs));
end

% Number of iterations for dynamic movement
num_iterations = 10;

% Initial energy level
initial_energy_level = 100 * ones(1, no_nodes); 

% Initial communication range
initial_communication_range = 50;


communication_energy_rate = 1;
movement_energy_rate = 0.5;

% Generate random nodes
for iter = 1:num_iterations
    x_loc = x_loc + 10 * randn(1, no_nodes);  
    y_loc = y_loc + 10 * randn(1, no_nodes);  
    
   
    for pair = 1:num_pairs
        node_distances{pair} = sqrt((x_loc - x_loc(sources(pair))).^2 + (y_loc - y_loc(sources(pair))).^2);
    end
    
    % Adaptive communication range based on distance for each pair
    for pair = 1:num_pairs
        communication_range{pair} = initial_communication_range - 0.2 * node_distances{pair};
        communication_range{pair}(communication_range{pair} < 5) = 5;  % Minimum communication range
    end
    
    % Plot nodes with adaptive communication range for each pair
    figure;
    for pair = 1:num_pairs
        subplot(1, num_pairs, pair);
        scatter(x_loc, y_loc, 50, 'filled', 'Marker', 'o');  
        hold on;
        
        % Highlight source and destination nodes for each pair
        plot(x_loc(sources(pair)), y_loc(sources(pair)), 'r^', 'LineWidth', 3);
        text(x_loc(sources(pair)), y_loc(sources(pair)), ['SRC' num2str(pair)]);
        plot(x_loc(destinations(pair)), y_loc(destinations(pair)), 'm^', 'LineWidth', 3);
        text(x_loc(destinations(pair)), y_loc(destinations(pair)), ['DEST' num2str(pair)]);
        
        % Add obstacles to the plot
        scatter(obstacle_x, obstacle_y, 'k', 'filled', 'Marker', 's');
        
        xlabel('Network length');
        ylabel('Network Width');
        grid on;
        title(['Pair ' num2str(pair)]);
    end
    
    % Simulate energy consumption during communication and movement
    for pair = 1:num_pairs
        for i = 1:no_nodes
            % Check for obstacles
            obstacle_distances = sqrt((x_loc(i) - obstacle_x).^2 + (y_loc(i) - obstacle_y).^2);
            if any(obstacle_distances < 20)  % Assume a minimum distance from obstacles
                
                x_loc(i) = x_loc(i) - 5;  % Move 5 units in the opposite direction
                y_loc(i) = y_loc(i) - 5;
            end
            
            % Energy consumption for communication
            energy_consumed_communication = communication_energy_rate * communication_range{pair}(i);
            initial_energy_level(i) = initial_energy_level(i) - energy_consumed_communication;
            
            % Energy consumption for movement
            energy_consumed_movement = movement_energy_rate * norm([10, 10]);  % Assuming a fixed movement distance
            initial_energy_level(i) = initial_energy_level(i) - energy_consumed_movement;
        end
    end
    
    
    nodes_low_energy = find(initial_energy_level < 20);
    if ~isempty(nodes_low_energy)
        disp(['Nodes with low energy: ' num2str(nodes_low_energy)]);
        
    end
    
    % Pause for visualization
    pause(0.5);
end







