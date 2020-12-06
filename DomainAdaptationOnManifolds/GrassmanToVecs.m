function mX = GrassmanToVecs(XX, mMean)

    if nargin < 2
        mMean = GrassmanMean(XX);
    end
    
    [n, d]   = size(XX{1});
    Grass    = grassmannfactory(n, d, 1);
    N        = length(XX);
    VVesc{N} = [];
    
    for ii = 1 : N
        VVesc{ii} = Grass.log(mMean, XX{ii});
    end

    mX = reshape(cat(3, VVesc{:}), [], N);
   
end