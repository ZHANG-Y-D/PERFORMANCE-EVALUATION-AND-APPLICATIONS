function F = HypoExp_pdf(t,l1,l2)

    F = (l1*l2/(l1-l2))*(exp(-t*l2)-exp(-t*l1));
    
end