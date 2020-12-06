close all
clear

addpath('../DomainAdaptationOnManifolds/');

%%
load('Data.mat');

%%
Data2 = Data;

%%
N        = length(Data2);
sSubject = unique({Data2.subject});
Ns       = length(sSubject);
vSubject = nan(N, 1);
for ss = 1 : Ns
    vIdx           = strcmp(sSubject{ss}, {Data2.subject});
    vSubject(vIdx) = ss;
end

vIdx      = ismember(vSubject, [1, 3]);
Data2     = Data2(vIdx);

%%
sAction    = unique({Data2.action});
Naction    = length(sAction);
vNumAction = nan(Naction, 1);
for ii = 1 : Naction
    vNumAction(ii) = sum(strcmp({Data2.action}, sAction{ii}));
end

%%
% vActionIdx = vNumAction > 15;
vActionIdx = vNumAction > 20;
vIdx       = ismember({Data2.action}, sAction(vActionIdx));
Data2      = Data2(vIdx);

% Data2(30) = [];

%%
r  = 4;
% k  = .1;
% vK = .1 * [0.01, 0.1, 1, 10, 100];
% Nk = length(vK);

%%
N       = length(Data2);
sAction = unique({Data2.action});
Na      = length(sAction);
vAction = nan(N, 1);
for aa = 1 : Na
    vIdx          = strcmp(sAction{aa}, {Data2.action});
    vAction(vIdx) = aa;
end

sSubject = unique({Data2.subject});
Ns       = length(sSubject);
vSubject = nan(N, 1);
for ss = 1 : Ns
    vIdx           = strcmp(sSubject{ss}, {Data2.subject});
    vSubject(vIdx) = ss;
end

tickStep = (Na - 1) / Na;
vTick    = 1 + tickStep/2 : tickStep : Na;

%%
Covs{N} = [];
for ii = 1 : N
    mot      = Data2(ii).motion;
    mX       = permute(cat(3, mot.jointTrajectories{:}), [1, 3, 2]);
    mX       = reshape(mX, 93, []);
    mC       = cov(mX');
    Covs{ii} = mC;
end

vIdx1 = vSubject == 1;
vIdx2 = vSubject == 2;

%%
[UU, RR] = SpsdDecomposition(Covs, r);
mXR      = SpdToVecs(RR);
mXU      = GrassmanToVecs(UU);

%%
k  = .1;
mX = [1 * mXU;
      k * mXR]; 

%%
% vShape = 'o*';
% mZ     = tsne(mX')';
% figure; hold on; 
% for ss = 1 : 2
%     vIdx = vSubject == ss;
% %     scatter3(mZ1(1,vIdx), mZ1(2,vIdx), mZ1(3,vIdx), 50, vAction(vIdx),  'Fill', 'MarkerEdgeColor', 'k', 'Marker', vShape(ss)); axis equal;
%     if ss == 1
%         scatter(mZ(1,vIdx), mZ(2,vIdx), 100, 'r', 'Fill', 'MarkerEdgeColor', 'k', 'Marker', vShape(ss)); axis equal;
%     else
%         scatter(mZ(1,vIdx), mZ(2,vIdx), 100, 'b', 'LineWidth', 2, 'Marker', vShape(ss)); axis equal;
%     end
% end
% colormap(lines(Na));
% colorbar('Ticks', vTick, 'TickLabels', sAction);
% title('No PT');
% axis tight
        
%%
sAction2 = {'hop both legs', 'hop right leg', 'jumping jacks', 'squat'}

%%
rng(2);
mZ     = tsne(mX')';

vShape = 'o*';
figure; hold on; set(gca, 'FontSize', 16);
for ss = 1 : 2
    vIdx = vSubject == ss;
%     scatter3(mZ1(1,vIdx), mZ1(2,vIdx), mZ1(3,vIdx), 50, vAction(vIdx),  'Fill', 'MarkerEdgeColor', 'k', 'Marker', vShape(ss)); axis equal;
    if ss == 1
        scatter(mZ(1,vIdx), mZ(2,vIdx), 100, vAction(vIdx), 'Fill', 'MarkerEdgeColor', 'k', 'Marker', vShape(ss));
    else
        scatter(mZ(1,vIdx), mZ(2,vIdx), 100, vAction(vIdx), 'LineWidth', 2, 'Marker', vShape(ss));
    end
end
axis tight
vAxis = axis;
axis(vAxis)

h(1) = plot(NaN, NaN, 'O', 'MarkerSize', 200, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r');
h(2) = plot(NaN, NaN, 'r*', 'MarkerSize', 200, 'LineStyle', 'None', 'LineWidth', 1.5);
colormap(lines(Na));
colorbar('Ticks', vTick, 'TickLabels', sAction2);
legend(h, 'Actor \#1', 'Actor \#3', 'Interpreter', 'Latex', 'Location', 'best');
% colormap(lines(Na));
% colorbar('Ticks', vTick, 'TickLabels', sAction);
% title('No PT');
% axis tight

%%
Covs1         = Covs(vIdx1);
Covs2         = Covs(vIdx2);
CovsPT        = Covs;
Covs2PT       = ApplySpsdPT2(Covs2, Covs1, r);
CovsPT(vIdx2) = Covs2PT;

%%
k        = 1;
[UU, RR] = SpsdDecomposition(CovsPT, r);
mXRPT    = SpdToVecs(RR);
mXUPT    = GrassmanToVecs(UU);
mXPT     = [1 * mXUPT;
            k * mXRPT]; 


%%
rng(4)
mZPT = tsne(mXPT')';

figure; hold on; set(gca, 'FontSize', 16);
for ss = 1 : 2
    vIdx = vSubject == ss;
%     scatter3(mZ2(1,vIdx), mZ2(2,vIdx), mZ2(3,vIdx), 50, vAction(vIdx),  'Fill', 'MarkerEdgeColor', 'k', 'Marker', vShape(ss)); axis equal;
    if ss == 1
        scatter(mZPT(1,vIdx), mZPT(2,vIdx), 100, vAction(vIdx), 'Fill', 'MarkerEdgeColor', 'k', 'Marker', vShape(ss));
    else
        scatter(mZPT(1,vIdx), mZPT(2,vIdx), 100, vAction(vIdx), 'LineWidth', 2, 'Marker', vShape(ss));
    end
end
axis tight
vAxis = axis;
axis(vAxis)

h(1) = plot(NaN, NaN, 'O', 'MarkerSize', 200, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r');
h(2) = plot(NaN, NaN, 'r*', 'MarkerSize', 200, 'LineStyle', 'None', 'LineWidth', 1.5);
colormap(lines(Na));
colorbar('Ticks', vTick, 'TickLabels', sAction2);
legend(h, 'Actor \#1', 'Actor \#3', 'Interpreter', 'Latex', 'Location', 'best');
% title('PT');


%%
