function F = MM_HyperExp(p, M1, M2, M3, traces_group)

    % p(1) -> lambda_1
    % p(2) -> lambda_2
    % p(3) -> P_1

    l1 = p(1);
    l2 = p(2);
    p1 = p(3);

    F(1) = (p1 / l1 + (1-p1)/ l2) / M1(traces_group) - 1;
    F(2) = 2*(p1 / l1^2 +(1-p1) / l2^2) / M2(traces_group) - 1;
    F(3) = 6*(p1 / l1^3 +(1-p1) / l2^3) / M3(traces_group) - 1;
    
    
end


% function F = MM_HyperExp(M1, M2, M3, traces_group,p)
% 
%     F = fsolve(@MM_HyperExp,p);
%     function F = MM_HyperExp(p)
%         % p(1) -> lambda_1
%         % p(2) -> lambda_2
%         % p(3) -> P_1
%         l1 = p(1);
%         l2 = p(2);
%         p1 = p(3);
%     
%         F(1) = (p1 / l1 + (1-p1)/ l2) / M1(traces_group) - 1;
%         F(2) = 2*(p1 / l1^2 +(1-p1) / l2^2) / M2(traces_group) - 1;
%         F(3) = 6*(p1 / l1^3 +(1-p1) / l2^3) / M3(traces_group) - 1;     
%     end
%     
% end

% 
% function F = MM_HyperExp(p)
% 
%     global M1 M2 M3 traces_group
%     % p(1) -> lambda_1
%     % p(2) -> lambda_2
%     % p(3) -> P_1
% 
%     l1 = p(1);
%     l2 = p(2);
%     p1 = p(3);
% 
%     F(1) = (p1 / l1 + (1-p1)/ l2) / M1 - 1;
%     F(2) = 2*(p1 / l1^2 +(1-p1) / l2^2) / M2 - 1;
%     F(3) = 6*(p1 / l1^3 +(1-p1) / l2^3) / M3 - 1;
%     
%     
% end