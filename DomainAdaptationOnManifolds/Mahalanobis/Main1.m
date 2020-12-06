close all
clear

addpath('../')

%%
N   = 500;
mZx = rand(2, N);
mZy = rand(2, N);
mZ  = [mZx, mZy];

Fx = @(mZ) [mZ(1,:) + mZ(2,:).^3;
            mZ(2,:) - mZ(1,:).^3];

Jx = @(vZ) [1,          3*vZ(2)^2;
            -3*vZ(1)^2, 1];
% A  = randn(2);
% A  = A * A' + .1 * eye(2);
A  = [1,   1/5
      -1/5, 2/3];
Fy = @(mZ) A * Fx(mZ);

mX = Fx(mZx);
mY = Fy(mZy);

figure;
subplot(1,3,1); scatter(mZx(1,:), mZx(2,:), 25, 'g', 'Fill', 'MarkerEdgeColor', 'k'); axis equal; axis tight; hold on;
subplot(1,3,1); scatter(mZy(1,:), mZy(2,:), 25, 'r', 'Fill', 'MarkerEdgeColor', 'k'); axis equal; axis tight; title('$\left\{ z_{i}\right\} \cup\left\{ z_{j}\right\}$',        'Interpreter', 'latex'); set(gca, 'FontSize', 16);
subplot(1,3,2); scatter(mX(1,:),  mX(2,:),  25, 'g', 'Fill', 'MarkerEdgeColor', 'k'); axis equal; axis tight; title('$x_{i}=f\left(z_{i}\right)$', 'Interpreter', 'latex'); set(gca, 'FontSize', 16);
subplot(1,3,3); scatter(mY(1,:),  mY(2,:),  25, 'r', 'Fill', 'MarkerEdgeColor', 'k'); axis equal; axis tight; title('$y_{j}=f\left(z_{j}\right)$', 'Interpreter', 'latex'); set(gca, 'FontSize', 16);

%%
mY2  = Fy(mZx);
Cyy  = cov(mY2');
Cxy  = 1/N * (mX - mean(mX, 2)) * (mY2 - mean(mY2, 2))';
Ay   = Cxy / Cyy;

%%
mDz  = pdist2(mZx', mZy');
mDxy = pdist2(mX',  mY');

figure; hold on; grid on; set(gca, 'FontSize', 16);
scatter(mDz(:), mDxy(:), 25, 'b', 'Fill', 'MarkerEdgeColor', 'k'); axis equal; axis tight;
plot(xlim, xlim, ':k', 'LineWidth', 5);
xlabel('$\left\Vert z_{i}-z_{j}\right\Vert _{2}$', 'Interpreter', 'latex');
title('$\left\Vert x_{i}-y_{j}\right\Vert _{2}$', 'Interpreter', 'latex');

%%
CovsX{N} = [];
CovsY{N} = [];
for ii = 1 : N
    vZi       = mZx(:,ii);
    mJx       = Jx(vZi);
    CovsX{ii} = mJx * mJx';
    
    vZj       = mZy(:,ii);
    mJy       = A * Jx(vZj);
    CovsY{ii} = mJy * mJy';
end

%%
Cx = SpdMean(CovsX);
Cy = SpdMean(CovsY);

E  = sqrtm(Cx / Cy);

%%
mD1 = nan(N, N);
mD2 = nan(N, N);
mD3 = nan(N, N);
mD4 = nan(N, N);
for ii = 1 : N
    N - ii
    vXi = mX(:,ii);
    mJx = Jx(mZx(:,ii));
    mCx = mJx * mJx';
    for jj = 1 : N
        vYj = mY(:,jj);
        mJy = A * Jx(mZy(:,jj));
        mCy = mJy * mJy';
        
        mC         = 1/2 * (inv(mCx) + inv(mCy));
        vD         = vXi - vYj;
        mD1(ii,jj) = sqrt(vD' * mC * vD);
        
        mC         = inv(SMean(mCx, mCy));
        mD2(ii,jj) = sqrt(vD' * mC * vD);
        
        mC         = 1/2 * (inv(mCx) + inv(E * mCy * E'));
        vD         = vXi - Ay * vYj;
        mD3(ii,jj) = sqrt(vD' * mC * vD);
        
        mC         = inv(SMean(mCx, E * mCy * E'));
        mD4(ii,jj) = sqrt(vD' * mC * vD);
        
    end
end

%%
figure; hold on; grid on; set(gca, 'FontSize', 16);
scatter(mDz(:), mD1(:), 25, 'b', 'Fill', 'MarkerEdgeColor', 'k'); axis equal; axis tight;
plot(xlim, xlim, ':k', 'LineWidth', 5);
xlabel('$\left\Vert z_{i}-z_{j}\right\Vert _{2}$', 'Interpreter', 'latex');
title('$\frac{1}{2}\left(x_{i}-y_{j}\right)^{T}\left(C_{x_{i}}^{-1}+C_{y_{j}}^{-1}\right)\left(x_{i}-y_{j}\right)$', 'Interpreter', 'latex');

figure; hold on; grid on; set(gca, 'FontSize', 16);
scatter(mDz(:), mD2(:), 25, 'b', 'Fill', 'MarkerEdgeColor', 'k'); axis equal; axis tight;
plot(xlim, xlim, ':k', 'LineWidth', 5);
xlabel('$\left\Vert z_{i}-z_{j}\right\Vert _{2}$', 'Interpreter', 'latex');
title('$\left(x_{i}-y_{j}\right)^{T}\left(C_{x_{i}}^{-1}\#C_{y_{j}}^{-1}\right)\left(x_{i}-y_{j}\right)$', 'Interpreter', 'latex');

figure; hold on; grid on; set(gca, 'FontSize', 16);
scatter(mDz(:), mD3(:), 25, 'b', 'Fill', 'MarkerEdgeColor', 'k'); axis equal; axis tight;
plot(xlim, xlim, ':k', 'LineWidth', 5);
xlabel('$\left\Vert z_{i}-z_{j}\right\Vert _{2}$', 'Interpreter', 'latex');
title('$\frac{1}{2}\left(x_{i}-\hat{x}\left(y_{j}\right)\right)^{T}\left(C_{x_{i}}^{-1}+\Gamma_{y\rightarrow x}\left(C_{y_{j}}^{-1}\right)\right)\left(x_{i}-\hat{x}\left(y_{j}\right)\right)$', 'Interpreter', 'latex');

figure; hold on; grid on; set(gca, 'FontSize', 16);
scatter(mDz(:), mD4(:), 25, 'b', 'Fill', 'MarkerEdgeColor', 'k'); axis equal; axis tight;
plot(xlim, xlim, ':k', 'LineWidth', 5);
xlabel('$\left\Vert z_{i}-z_{j}\right\Vert _{2}$', 'Interpreter', 'latex');
title('$\left(x_{i}-\hat{x}\left(y_{j}\right)\right)^{T}\left(C_{x_{i}}^{-1}\#\Gamma_{y\rightarrow x}\left(C_{y_{j}}^{-1}\right)\right)\left(x_{i}-\hat{x}\left(y_{j}\right)\right)$', 'Interpreter', 'latex');

%%
function M = SMean(A, B)
    M = A * sqrtm(A \ B);
end