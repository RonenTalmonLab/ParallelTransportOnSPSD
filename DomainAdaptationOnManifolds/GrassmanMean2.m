% function mG = GrassmanMean2(GG, vW)
%     N       = length(GG);
%     if nargin < 2
%         vW = ones(N, 1) / N;
%     end
%     vW      = vW / sum(vW);
%     [D, d]  = size(GG{1});
%     M       = grassmannfactory(D, d, 1);
%     
%     mG  = GG{1};
%     maxIter = 200;
%     vNorm   = nan(maxIter, 1);
%     for ii = 1 : maxIter
%         mDG = 0 * mG;
%         PiGperp  = eye(D) - mG * mG';
%         for nn = 1 : N
%             Gi   = GG{nn};
%             PiGn = Gi * Gi';
%             mDG  = mDG + vW(nn) * PiGperp * PiGn * mG;
%         end
%         mG = M.exp(mG, mDG);
%         
%         vNorm(ii) = norm(mDG, 'fro');
%         if vNorm(ii) < 1e-10
%             break
%         end
%     end
% 
%     figure; plot(log(vNorm)); title('Norm of mean - should be zero at the end');
% end