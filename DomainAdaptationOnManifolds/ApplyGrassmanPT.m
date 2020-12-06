function GG1PT = ApplyGrassmanPT(GG1, GG2, G1, G2)
    
    N1     = length(GG1);
    [d, r] = size(GG1{1});
    M      = grassmannfactory(d, r, 1);

    if (nargin < 3) || isempty(G1)
        G1 = GrassmanMean(GG1);
    end
    if nargin < 4
        G2 = GrassmanMean(GG2);
    end
   
    [O1, ~, O2] = svd(G1' * G2);
    G2          = G2 * O2 * O1';    
    
    GG1PT{N1} = [];
    Vecs{N1}  = [];
    for ii = 1 : N1
        Vecs{ii} = M.log(G1, GG1{ii});
    end
    VecsPT = GrassmanPT(G1, G2, Vecs);
    for ii = 1 : N1
        Gi        = GG1{ii};
        GPTi      = M.exp(G2, VecsPT{ii});
        vSign1    = sign(sum(Gi   .* G1));
        vSign2    = sign(sum(GPTi .* G2));
        vSign     = vSign1 .* vSign2;
        GPTi      = GPTi .* vSign;
        GG1PT{ii} = GPTi;
    end
end
