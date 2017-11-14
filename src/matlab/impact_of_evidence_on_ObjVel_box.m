%% configure BNT and other paths
clear;
configurePaths;

%% user parameters
create_figures = true;
%barwidth = 0.4;
fontsize = 14;

%% soft evidence over Action, for various experiments to visualize together
% BNActionValue order: grasp,tap,touch
ev = [0 0 1
    0 0.25 0.75
    0 0.5 0.5
    0 0.75 0.25
    0 1 0];

%% load data
load('BN_lab.mat');

%% give some initial evidence to the Bayesian Network
obs_box = {'Shape', 'box'};
netobj_lab = BNEnterNodeEvidence(netobj_lab, obs_box);

%% experiment 1, extract predictions (posteriors)
inferred = {'ObjVel'};
nexamples = size(ev, 1);
% this only works for single inference node
node_size = netobj_lab.node_sizes(BNWhichNode(netobj_lab, inferred{1}));
p = zeros(node_size, nexamples+1);
% posterior without evidence on action
p(:, 1) = BNMarginalProb(netobj_lab, inferred);

for ex = 1:nexamples
    netobj_lab = BNResetEvidence(netobj_lab);
    netobj_lab = BNEnterNodeEvidence(netobj_lab, obs_box, true, {'Action', ev(ex,:)});
    p(:, ex+1) = BNMarginalProb(netobj_lab, inferred);
end

%% create figure
if create_figures
    figure;
    b = bar(p');
    %xlabel('Action Evidence [grasp tap touch]', 'FontSize',fontsize);
    xlabel('$P_{\rm{HMM}}(A \mid G_1^T)$ [grasp tap touch]', 'Interpreter','latex', 'FontSize',fontsize);
    set(gca, 'xticklabels', {'none', mat2str(ev(1,:)), mat2str(ev(2,:)), mat2str(ev(3,:)), mat2str(ev(4,:)), ...
        mat2str(ev(5,:))});
    xtickangle(45);
    ylabel('$P_{\rm{comb}}(\rm{ObjVel} \mid \rm{Shape=box}, G_1^T)$', 'Interpreter','latex', 'FontSize',fontsize);
    ylim([0, 1.0]);
    l = legend(b, 'slow', 'medium', 'fast');
    set(l, 'Location','best');
    print('-depsc', 'impact_of_evidence_on_ObjVel_box.eps');
end;