%% configure BNT and other paths
configurePaths;

%% user parameters
create_figures = true;
%barwidth = 0.4;
fontsize = 14;

%% soft evidence over Action, for various experiments to visualize together
% BNActionValue order: grasp,tap,touch
ev1 = [0 0 1];
ev2 = [0 0.25 0.75];
ev3 = [0 0.5 0.5];
ev4 = [0 0.75 0.25];
ev5 = [0 1 0];

%% load data
load('BN_lab.mat');

%% give some initial evidence to the Bayesian Network
obs_box = {'Shape', 'box'};
netobj_lab = BNEnterNodeEvidence(netobj_lab, obs_box);

%% experiment 1, extract predictions (posteriors)
inferred = {'ObjVel'};
[netobj_lab,p1] = fusion(netobj_lab, inferred, obs_box, ev1);

%% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, obs_box);

%% experiment 2, extract predictions (posteriors)
[netobj_lab,p2] = fusion(netobj_lab, inferred, obs_box, ev2);

%% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, obs_box);

%% experiment 3, extract predictions (posteriors)
[netobj_lab,p3] = fusion(netobj_lab, inferred, obs_box, ev3);

%% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, obs_box);

%% experiment 4, extract predictions (posteriors)
[netobj_lab,p4] = fusion(netobj_lab, inferred, obs_box, ev4);

%% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, obs_box);

%% experiment 5, extract predictions (posteriors)
[netobj_lab,p5] = fusion(netobj_lab, inferred, obs_box, ev5);

if create_figures
    figure;
    b = bar([p1 p2 p3 p4 p5]');
    xlabel('Action Evidence [grasp tap touch]', 'FontSize',fontsize);
    set(gca, 'xticklabels', {mat2str(ev1), mat2str(ev2), mat2str(ev3), ...
        mat2str(ev4), mat2str(ev5)});
    xtickangle(45);
    ylabel('$P_{\rm{comb}}(\rm{ObjVel} \mid \rm{Shape=box})$', 'Interpreter','latex', 'FontSize',fontsize);
    l = legend(b, 'slow', 'medium', 'fast');
    set(l, 'Location','north');
    print('-depsc', 'impact_of_evidence_on_ObjVel_box.eps');
end;