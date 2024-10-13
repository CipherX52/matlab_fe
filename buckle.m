function [pb,ub]=buckle(Ks,Ksigmas,nnode,node_z);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve beam buckling equation
% File name: buckle.m
% 
% Ks		Structural stiffness matrix
% Ksigmas	Structural inital stiffness matrix
% nnode		Number of nodes
% node_z	Nodal x-coordinates
%
% pb		Matrix with eigenvalues (load factors) in diagonal
% ub		Corresponding matrix of eigenvectors (buckling modes)
% 	(Column i of ub shows the buckling mode for buckling load (i,i) in pb)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate eigenvalues and eigenvectors
[ub,pb] = eig(Ks,-Ksigmas);

% Split bending and twist modes into separate vectors
bending = zeros(3*(nnode-1),3*(nnode-1));
twist = zeros(3*(nnode-1),3*(nnode-1));

for i = 1:3*(nnode-1)
    a = ub(:,i);
    if abs(a(1))> 0.0001
        bending(:,i) = a;
        continue;
    end
    if abs(a(1)) < 0.0001
        if abs(a(2)) < 0.0001
            for k = 1:3*(nnode-1)
                if abs(a(k))< 0.0001
                    twist(:,i) = a;
                    continue;
                end
            end
        end
    end
end

bending(:,all(bending == 0))=[];
twist(:,all(twist == 0))=[];

% Normalise deflections, rotations and twist for plotting purposes (without risking to mix up signs or divide by zero)
k = 1;
bend = [[0 0 0], bending(:,k)']';
disp = bend(1:3:3*nnode);
rot = bend(2:3:3*nnode);
t = [[0 0 0] ,twist(:,k)']';
twi = t(3:3:3*nnode);

tmax = max(abs(twi));
dispmax = max(abs(disp));
rot_max = max(abs(rot));

disp_norm = disp./dispmax;
rot_norm = rot./rot_max;
t_norm = twi./tmax;
% Plot buckling modes
figure();
tcl = tiledlayout(3,1);

nexttile;
title('Displacement');
plot(node_z,disp_norm);
xlabel('Node');
ylabel('Displacement');

nexttile;
title('Rotation');
plot(node_z, rot_norm);
xlabel('Node');
ylabel('Rotation');

nexttile;
title('Twist');
plot(node_z,t_norm);
xlabel('Node');
ylabel('Twist');

title(tcl,'Buckling modes');

% Present the buckling loads
[~,ind] = min(diag(pb));
buckling_load = (2*ind-1)^2*pi^2*EI/4/le^2;
disp(buckling_load);
