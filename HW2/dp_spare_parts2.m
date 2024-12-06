function [x_optimal, EBO_optimal] = dp_spare_parts2(budget, cost_vec, lambda_vec, T_vec)
    number_of_parts = length(cost_vec);
    allocations = zeros(budget + 1, number_of_parts, 3);
    EBO = inf(budget + 1, number_of_parts + 1);
    EBO(:, number_of_parts + 1) = 0;
    for i = number_of_parts:-1:1
        for b = 0:budget
            %{
            [allocation, EBO_min] = find_allocation_that_minimizes_EBO();
            allocations(b, i) = allocation;
            EBO(b,i) = EBO_min;
            %}
            
            max_possible_spares = floor(b / cost_vec(i));
            for spare = 0 : max_possible_spares
                remaining_budget = b - cost_vec(i) * spare; % remaining budget after allocating spare parts
                EBO_i = EBO_calc(spare, lambda_vec(i), T_vec(i)); % EBO for current LRU
                total_EBO = EBO_i + EBO(remaining_budget + 1, i + 1); % Compute total EBO (current + future)

                if total_EBO < EBO(b + 1, i)
                    EBO(b + 1, i) = total_EBO;
                    allocations(b + 1, i, 1) = spare;
                    allocations(b + 1, i, 2) = remaining_budget + 1;
                    allocations(b + 1, i, 3) = total_EBO;
                end
            end
        end
    end
    
    x_opt = zeros(1,number_of_parts);
    [ebo, index] = min(allocations(:,1,3));
    I = allocations(index, 1 ,2);
    x_opt(1) = allocations(index, 1, 1);
    for i = 2:number_of_parts
        x_opt(i) = allocations(I, i, 1);
        I = allocations(I, i, 2);
    end

    x_optimal = x_opt;
    EBO_optimal = ebo;
end