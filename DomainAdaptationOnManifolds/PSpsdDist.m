function [mW, mWU, mWR] = PSpsdDist(PP, r, k)

    if nargin < 3
        k = 1;
    end

    L   = numel(PP);
    mW  = zeros(L, L);
    mWU = zeros(L, L);
    mWR = zeros(L, L);
    for ii = 1 : L
%         ii
        Pi = PP{ii};
        for jj = ii + 1 : L
            Pj                = PP{jj};
            [mWi, mWUi, mWRi] = SpsdDist(Pi, Pj, r, k);
            mW(ii,jj)         = mWi;
            mWU(ii,jj)        = mWUi;
            mWR(ii,jj)        = mWRi;
        end
    end
    mW  = mW  + mW';
    mWU = mWU + mWU';
    mWR = mWR + mWR';
end