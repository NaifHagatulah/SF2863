function [optimal_allocation, min_ebo, V, policy] = dp_spare_parts(C_budget, cost_vec, lambda_vec, T_vec)
    % Inputs:
    % C_budget: Total budget available
    % cost_vec: Vector of costs for each LRU
    % lambda_vec: Vector of failure rates (λ_j) for each LRU
    % T_vec: Vector of average repair times (T_j) for each LRU
    % EBO_calc: External function calculating EBO for a given setup
    
    % Outputs:
    % optimal_allocation: Optimal number of spares for each LRU
    % min_ebo: Minimum EBO achieved with the optimal allocation
    
    % Number of LRUs
    num_LRUs = length(cost_vec);
    
    % Initialize value function table
    V = inf(num_LRUs + 1, C_budget + 1); % Rows = LRUs, Columns = budget levels
    policy = zeros(num_LRUs, C_budget + 1); % Store decisions (spares allocated)
    
    % Base case: No EBO if no LRUs are left to allocate (last stage)
    V(num_LRUs + 1, :) = 0; 
    
    % Backward recursion
    for i = num_LRUs:-1:1 % For each LRU
        for R = 0:C_budget % For each budget level
            % Explore all possible allocations for the current LRU
            max_possible_spares = floor(R / cost_vec(i));
            for s_i = 0:max_possible_spares
                remaining_budget = R - cost_vec(i) * s_i;
                
                ebo_i = EBO_calc(s_i, lambda_vec(i), T_vec(i)); % EBO for current LRU
                % Compute total cost (current + future)
                total_cost = ebo_i + V(i + 1, remaining_budget + 1);
                
                % Update value function if a better policy is found
                if total_cost < V(i, R + 1)
                    V(i, R + 1) = total_cost;
                    policy(i, R + 1) = s_i; % Store the optimal decision
                end
            end
        end
    end
    
    % Reconstruction of the optimal policy
    optimal_allocation = zeros(1, num_LRUs);
    remaining_budget = C_budget;
    for i = 1:num_LRUs
        optimal_allocation(i) = policy(i, remaining_budget + 1);
        remaining_budget = remaining_budget - cost_vec(i) * optimal_allocation(i);
    end
    % Minimum EBO
    min_ebo = V(1, C_budget + 1);
end
