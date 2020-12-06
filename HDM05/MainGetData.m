% This code belongs to the HDM05 mocap database which can be obtained
% from the website http://www.mpi-inf.mpg.de/resources/HDM05 .
%
% If you use and publish results based on this code and data, please
% cite the following technical report:
%
%   @techreport{MuellerRCEKW07_HDM05-Docu,
%     author = {Meinard M{\"u}ller and Tido R{\"o}der and Michael Clausen and Bernd Eberhardt and Bj{\"o}rn Kr{\"u}ger and Andreas Weber},
%     title = {Documentation: Mocap Database {HDM05}},
%     institution = {Universit{\"a}t Bonn},
%     number = {CG-2007-2},
%     year = {2007}
%   }
%
%
% THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
% KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
% PARTICULAR PURPOSE.

close all
clear

addpath(genpath('parser'))
addpath(genpath('animate'))
addpath('quaternions')

%% 
Dir     = dir('./data/HDM05_cut_amc');
Folders = Dir([Dir.isdir]);
Folders = Folders(3:end);
Nfolder = length(Folders);

%%
Data = struct();
kk   = 1;
for ff = 1 : Nfolder
    ff
    folderFullPath = [Folders(ff).folder, '/', Folders(ff).name];
    Files          = dir([folderFullPath, '/*.amc']);
    Nfiles         = length(Files);
    for ll = 1 : Nfiles
       fileName         = Files(ll).name;
       sSplit           = strsplit(fileName, '_');
       
       [skel, mot]      = readMocap([folderFullPath, '/HDM_', sSplit{2}, '.asf'], [folderFullPath, '/', fileName]);
       Data(kk).subject = sSplit{2};
       Data(kk).action  = sSplit{3};
       Data(kk).rep     = sSplit{4};
       Data(kk).skel    = skel;
       Data(kk).motion  = mot;
       kk               = kk + 1;
    end
end

%%
sAction    = unique({Data.action});
Naction    = length(sAction);
vNumAction = nan(Naction, 1);
for ii = 1 : Naction
    vNumAction(ii) = sum(strcmp({Data.action}, sAction{ii}));
end
save('Data.mat','Data');
% 
% %%
% vActionIdx = vNumAction > 30;
% vIdx       = ismember({Data.action}, sAction(vActionIdx));
% Data2      = Data(vIdx);
% 
% %%
% N       = length(Data2);
% Covs{N} = [];
% figure;
% for ii = 1 : N
%     mot = Data2(ii).motion;
%     mX  = permute(cat(3, mot.jointTrajectories{:}), [1, 3, 2]);
%     mX  = reshape(mX, 93, []);
%     mX  = diff(mX, [], 2);
%     mC  = cov(mX');
%     subplot(2,1,1); plot(mX');
%     subplot(2,1,2); stem(eig(mC));
%     drawnow; pause(.5);
% end
% 

