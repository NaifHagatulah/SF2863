function [r, c] = indexMax(table)
    [M,I] = max(table,[],"all","linear");
    [r,c] = ind2sub(size(table), I);
end