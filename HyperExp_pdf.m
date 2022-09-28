function F = HyperExp_pdf(t,l1,l2,p1)

    F = p1*l1*exp(-l1*t)+(1-p1)*l2*exp(-t*l2);
    
end
