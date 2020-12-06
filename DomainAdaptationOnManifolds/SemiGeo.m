function [P, params] = SemiGeo(A1, A2, R, vT, params)

Symm = @(M) (M + M') / 2;

D = size(A1, 1);
d = R;

A1 = Symm(A1);
A2 = Symm(A2);

if (nargin < 5) || isempty(params)
    
    [V1, ~, ~] = svds(A1, d);
    [V2, ~, ~] = svds(A2, d);
    % V1          = V1(:,1:d);
    % V2          = V2(:,1:d);
    
    [O1, S, O2] = svd(V1' * V2);
    vTheta      = acos(diag(S));
    
    U1 = V1 * O1;
    U2 = V2 * O2;
    
    % F  = pinv(diag(sin(vTheta)));
    
    vF          = sin(vTheta);
    vF(vF ~= 0) = 1 ./ vF(vF ~= 0);
    F           = diag(vF);
    
    X  = (eye(D) - U1 * U1') * U2 * F;
    
    R12 = U1' * A1 * U1;
    R22 = U2' * A2 * U2;
    
    R1  = sqrtm(R12);
    
    %--
    B       = R1 \ R22 / R1;
    B       = 0.5 * (B + B');
    [E, vV] = eig(B, 'vector');
    RE      = R1 * E;
    
    params.U1     = U1;
    params.vTheta = vTheta;
    params.X      = X;
    params.vV     = vV;
    params.RE     = RE;
else
    U1     = params.U1;
    vTheta = params.vTheta;
    X      = params.X;
    vV     = params.vV;
    RE     = params.RE;
end

N    = length(vT);
P{N} = [];
% fprintf('Semi Geo:    ');
for ii = 1 : N
%     fprintf('\b\b\b'); fprintf('%03d', N - ii);
    t  = vT(ii);
    Ut = U1 * diag(sparse(cos(t * vTheta))) + X * diag(sparse(sin(t * vTheta)));
    Rt = RE * diag(sparse(vV.^vT(ii))) * RE';
%     eig(Rt)
%     Rt = R1 * E * diag(sparse(vV.^vT(ii))) * E' * R1;
%     Rt = R1 * (R1 \ R22 / R1)^(t) * R1;
    M  = Ut * Rt * Ut';
    
    P{ii} = Symm(M);
end
% fprintf('\n');

if N == 1
    P = P{1};
end

end