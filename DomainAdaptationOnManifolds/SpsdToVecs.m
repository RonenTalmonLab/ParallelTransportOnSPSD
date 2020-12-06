function [mXD, mXS] = SpsdToVecs(CC, r)

    Symm  = @(M) (M + M') / 2;
    N     = length(CC);
    d     = size(CC{1}, 1);
    Grass = grassmannfactory(d, r, 1);
    
    [~, mW, mT] = SpsdMean(CC, r);
    mInvT       = sqrtm(inv(mT));
    
    mWW   = sqrt(2) * ones(r) + (1 - sqrt(2)) * eye(r);
    DD{N} = [];
    SS{N} = [];
    for ii = 1 : N
        Xi      = Symm(CC{ii});
        [Gi, ~] = eigs(Xi, r);
        
        [Oi, ~, OWi] = svd(Gi' * mW);
        GOi          = Gi * Oi * OWi';
        mPi          = GOi' * Xi * GOi;
        DD{ii}       = Grass.log(mW, GOi);
        mSi          = logm(mInvT * mPi * mInvT) .* mWW;
        SS{ii}       = mSi(triu(true(size(mSi))));
    end
    
    mXD = reshape(cat(3, DD{:}), [], N);
    mXS = reshape(cat(3, SS{:}), [], N);
end