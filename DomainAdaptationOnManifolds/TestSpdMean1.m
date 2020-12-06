close all
clear

d     = 10;
N     = 4;
PP{N} = [];
for ii = 1 : N
    PP{ii} = RandP(d);
end

%%
M = SpdMean(PP);

%%
M1 = SpdMean(PP(1:2));
M2 = SpdMean(PP(3:4));
M3 = SpdMean({M1, M2});


norm(M - M3, 'inf')
SpdDist(M, M3)

figure; 
subplot(2,1,1); imagesc(M);  colorbar;
subplot(2,1,2); imagesc(M3); colorbar;

figure; imagesc(abs(M - M3)); colorbar;

%%
function P = RandP(d)
    P = randn(d);
    P = P * P';
end
