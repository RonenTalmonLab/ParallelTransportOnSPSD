function [GG, TT, mG] = SpsdDecomposition(CC, r)

    Symm  = @(M) (M + M') / 2;
    N     = length(CC);
    UU{N} = [];
    for ii = 1 : N
        Xi          = Symm(CC{ii});
        [UU{ii}, ~] = eigs(Xi, r);
    end

    mG = GrassmanMean(UU);
    
    TT{N} = [];
    GG{N} = [];
    for ii = 1 : N
        Xi = Symm(CC{ii});
        Ui = UU{ii};
        
        [Oi, ~, OWi] = svd(Ui' * mG);
        Yi           = Ui  * Oi;
        Si           = Yi' * Xi * Yi;
        Ti           = OWi * Si * OWi';
        GG{ii}       = Yi * OWi';
        TT{ii}       = Symm(Ti);
    end
    
end