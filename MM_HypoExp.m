function F = MM_HypoExp(p, M1, M2, traces_group)

    % p(1) -> lambda_1
    % p(2) -> lambda_2

    l1 = p(1);
    l2 = p(2);
    

    F(1) = ((1/(l1-l2))*(l1/l2 - l2/l1)) / M1(traces_group) - 1;
    F(2) = 2*(1/l1^2 + 1/l1*l2 + 1/l2^2) / M2(traces_group) - 1;
    
    
    
end