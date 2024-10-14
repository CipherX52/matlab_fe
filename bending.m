function [defl,teta,fi,umax,tmax,fimax]=bending(Ks,Qs,K,Q,nnode,node_z);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate deformed beam bending and torsion shape and plot results
% File name: bending.m
%
% Ks		Structural stiffness matrix
% Qs		Structural load vector
% K		System stiffness matrix 
% Q		System load vector
% nnode		Number of nodes
% node_z	Nodal z-coordinates
%
% defl		Deflection vector of size nnodes
% teta		Rotation vector of size nnodes
% fi		Twist vector of size nnodes
% umax		Maximum deflection
% tetamax	Maximum rotation
% fimax		Maximum twist
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ndof = 3*(nnode);
% Solve system of equations
ws = Ks\Qs;
% Present displacements at the free end
fprintf('Displacement at the free end: %.3fm \n',ws(end-2));
fprintf('Rotation at the free end: %.3f \n',ws(end-1));
fprintf('Twist at the free end: %.3f \n',ws(end));
% Present reaction forces
Fr = K(1:3,4:ndof)*ws - Q(1:3)
% fprintf('Reaction Forces: %.3f \n', Fr);
% Create result vector containing deflections, rotations and twist
w = [[0,0,0],ws']';
% Fr = K*w - Q
% Split deflections, rotations and twist into separate vectors

defl = w(1:3:ndof);
teta = w(2:3:ndof);
fi = w(3:3:ndof);

% Normalise deflections, rotations and twist and plot results
umax = max(abs(defl));
tmax = max(abs(teta));
fimax = max(abs(fi));
defl_norm = defl./umax;
teta_norm = teta./tmax;
fi_norm = fi./fimax;

figure();
tcl = tiledlayout(3,1);

nexttile;
title('Displacement');
plot(node_z,defl_norm);
xlabel('Node');
ylabel('Displacement');

nexttile;
title('Rotation');
plot(node_z, teta_norm);
xlabel('Node');
ylabel('Rotation');

nexttile;
title('Twist');
plot(node_z,fi_norm);
xlabel('Node');
ylabel('Twist');

title(tcl,'Bending Plots');