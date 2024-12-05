function [EBO] = EBO_calc(S, lambdavec, Tvec)
    EBO = 0;
    for i = 1:size(S,2)
        [~,~, EBO_part] = EBOcomp(lambdavec(i),Tvec(i), S(i));
        EBO = EBO + EBO_part(S(i) + 1);
    end
end