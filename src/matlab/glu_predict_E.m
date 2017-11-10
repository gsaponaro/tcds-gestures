%% configure BNT and other paths
configurePaths;

%% load data
load('BN_lab.mat');

%% experiment 1: small sphere
% enter node evidence for Action and Features (object) nodes
nodevaluepairs = {'Action', 'tap', 'Shape', 'circle', 'Size', 'small'};
%netobj_lab = BNEnterNodeEvidence(netobj_lab, nodevaluepairs, 0);
netobj_lab = BNEnterNodeEvidence(netobj_lab, nodevaluepairs);

% extract predictions (posteriors)
posteriornodes = {'ObjVel'};
pred_lab_circle = marginal_prob(netobj_lab, posteriornodes);
figure;
bar(pred_lab_circle.T);
set(gca, 'FontSize', 20); % in order to have the desired yticks
set(gca, 'xticklabel', {'slow','medium','fast'});
xtickangle(45);
%ylabel('$p(E \mid A=\mathrm{tap}, F=\mathrm{sphere, small})$', 'Interpreter', 'latex');
yl = ylabel({'$P(\rm{ObjVel} \mid \rm{Action=tap},$','$\rm{Shape=sphere, Size=small})$'});
set(yl, 'Interpreter','latex');
ylim([0 1]);
print('-depsc', 'effectpred_sphere.eps');

netobj_lab = BNResetEvidence(netobj_lab);

%% experiment 2: big box
% enter node evidence for Action and Features (object) nodes
nodevaluepairs = {'Action', 'tap', 'Shape', 'box', 'Size', 'big'};
%netobj_lab = BNEnterNodeEvidence(netobj_lab, nodevaluepairs, 0);
netobj_lab = BNEnterNodeEvidence(netobj_lab, nodevaluepairs);

% extract predictions (posteriors)
pred_lab_box = marginal_prob(netobj_lab, posteriornodes);
figure;
bar(pred_lab_box.T);
set(gca, 'FontSize', 20);
set(gca, 'xticklabel', {'slow','medium','fast'});
xtickangle(45);
%ylabel('$p(E \mid A=\mathrm{tap}, F=\mathrm{box, big})$', 'Interpreter', 'latex');
yl = ylabel({'$P(\rm{ObjVel} \mid \rm{Action=tap},$','$\rm{Shape=box, Size=small})$'});
set(yl, 'Interpreter','latex');
print('-depsc', 'effectpred_box.eps');