function [R] = Rcomp(lambda,T,k,c) %
    lamT = lambda*T;
    R = zeros(k,1);
    p = exp(-lamT);
    R(1) = 1 - p;
    for s=1:k-1
        s1=s+1;
        p = p*lamT/s1;
        R(s1) = R(s) - p;
        disp("iteration " + s + " R s+1 " + R(s1) + " p s+1 " + p + " R s " + R(s)  +  " table value  s + 1 " + R(s1)/c + " table value s " + R(s)/c); 
    end
end
