function [R] = Rcomp(lambda,T,k) %
    lamT = lambda*T;
    R = zeros(k,1);
    p = zeros(k,1);
    p(1) = exp(-lamT);
    R(1) = 1 - p(1);
    for s=1:k-1
        s1=s+1;
        p(s1) = lamT*p(s)/s;
        R(s1) = R(s) - p(s1);
    end
end