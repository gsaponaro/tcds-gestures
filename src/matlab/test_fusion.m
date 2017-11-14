%% configure BNT and other paths
clear;
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

%% test 1: give hard evidence at different times
netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Shape', 'box'});
marg0 = marginal_nodes(netobj_lab.engine, BNWhichNode(netobj_lab, 'ObjVel'));

netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Action', 'touch'}, true);
marg1 = marginal_nodes(netobj_lab.engine, BNWhichNode(netobj_lab, 'ObjVel'));

%% test 2: give hard evidence at the same time
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Action', 'touch', 'Shape', 'box'});

marg2 = marginal_nodes(netobj_lab.engine, BNWhichNode(netobj_lab, 'ObjVel'));

%% test 3: give hard evidence through distribution
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Shape', 'box'}, true, {'Action', [0, 0, 1]});

marg3 = marginal_nodes(netobj_lab.engine, BNWhichNode(netobj_lab, 'ObjVel'));

%% test 4: give hard evidence through distribution (fusion)
netobj_lab = BNResetEvidence(netobj_lab);
[netobj_lab, marg4T] = fusion(netobj_lab, {'ObjVel'}, {'Shape', 'box'}, [0, 0, 1]);
