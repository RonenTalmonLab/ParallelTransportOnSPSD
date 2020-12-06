function VecsPT = GrassmanPT(G1, G2, Vecs)
    [D, d] = size(G1);
    if D == d
        VecsPT = Vecs;
        return;
    end
    
    N         = length(Vecs);
    M         = (eye(D) - G1 * G1') * G2 / (G1' * G2);
    [A, S, B] = svd(M, 'econ');
    vS        = atan(diag(S));
    E         = (-G1 * B  * diag(sin(vS)) * A' + ...
                 A        * diag(cos(vS)) * A' + ...
                 (eye(D) - A * A'));

    if ~iscell(Vecs)
        VecsPT = E * Vecs;
    else
        VecsPT{N} = [];
        for ii = 1 : N
            VecsPT{ii} = E * Vecs{ii};
        end
    end
end