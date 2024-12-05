function [p,R,EBO] = EBOcomp(lambda,T, smax)
    lamT = lambda*T;
    p(1) = exp(-lamT);
    R(1) = 1 - p(1);
    EBO(1) = lamT;
    for s=1:smax
        s1=s+1;
        p(s1) = lamT*p(s)/s;
        R(s1) = R(s) - p(s1);
        EBO(s1) = EBO(s) - R(s);
    end
end