function VecsPT = GrassmanPtH(G, H, Vecs)
    [D, d] = size(G);
    if D == d
        VecsPT = Vecs;
        return;
    end
    
    [U, S, V] = svd(H, 'econ');
    vTh       = diag(S)
    
    E = -G * V * diag(sin(vTh)) * U' + ...
             U * diag(cos(vTh)) * U' + ...
        eye(D) - U * U';
    
    if ~iscell(Vecs)
        VecsPT = E * Vecs;
    else
        VecsPT{N} = [];
        for ii = 1 : N
            VecsPT{ii} = E * Vecs{ii};
        end
    end
end