%% configure BNT and other paths
configurePaths;

%% load data
load('BN_lab.mat');

%% user parameters
word_threshold = 0.2;
create_figures = true;
fontsize = 20;

% 10000 sentences generated randomly accroding to the grammar in
% AffordanceAndSpeech/word2sent/grammar.grm (see Makefile for more
% information)
% if needed we can generate many more
sentenceFilename = 'sentence_data/sentence_10000samples_uniq.txt';

%% example counter
e = 1;

%% Example in which the generated conjunction is ``and''

fprintf('%d.\n', e);

%% enter some evidence
netobj_lab = BNEnterNodeEvidence(netobj_lab, ...
    {'Action', 'grasp', 'ObjVel', 'medium'});

%% extract word probabilities
pw_evidenceand = BNGetWordProbs(netobj_lab);

% toplot = pw>word_threshold;
% if create_figures
%     figure;
%     bar(pw(toplot));
%     set(gca, 'xtick', 1:length(netobj_lab.WORDNODES(toplot)));
%     wordnameswithquotes = strcat('"', netobj_lab.nodeNames(netobj_lab.WORDNODES(toplot)), '"');
%     set(gca, 'xticklabel', wordnameswithquotes);
%     set(gca,'XTickLabelRotation',45);
%     ylabel('$p(w_i)$', 'Interpreter','latex', 'FontSize', 20);
%     print('-depsc', 'and_pw.eps');
% end;

%% rescore sentences with word probabilities and pick best sentence
[sentences, normlogprobs] = BNScoreSentences(netobj_lab, sentenceFilename);

% find the best sentence
[bestprob, bestsentidx] = max(normlogprobs);
% ...and display it
sentences{bestsentidx}

% sort sentences:
[sortedprobs, sortedidxs] = sort(normlogprobs, 'descend');

% display n-best list
nbest = 10;
for h=1:nbest
    disp([sentences{sortedidxs(h)} ' ' num2str(normlogprobs(sortedidxs(h)))]);
end

netobj_lab = BNResetEvidence(netobj_lab);
e = e+1;
fprintf('\n');

%% Example in which the generated conjunction is ``but''

fprintf('%d.\n', e);

netobj_lab = BNEnterNodeEvidence(netobj_lab, ...
    {'Action', 'grasp', 'ObjVel', 'slow'});

pw_evidencebut = BNGetWordProbs(netobj_lab);
% toplot = pw>word_threshold;
% if create_figures
%     figure;
%     bar(pw(toplot));
%     set(gca, 'xtick', 1:length(netobj_lab.WORDNODES(toplot)));
%     wordnameswithquotes = strcat('"', netobj_lab.nodeNames(netobj_lab.WORDNODES(toplot)), '"');
%     set(gca, 'xticklabel', wordnameswithquotes);
%     set(gca,'XTickLabelRotation',45);
%     ylabel('$p(w_i)$', 'Interpreter','latex', 'FontSize', 20);
%     print('-depsc', 'but_pw.eps');
% end;

[sentences, normlogprobs] = BNScoreSentences(netobj_lab, sentenceFilename);

[bestprob, bestsentidx] = max(normlogprobs);
sentences{bestsentidx}

[sortedprobs, sortedidxs] = sort(normlogprobs, 'descend');

nbest = 10;
for h=1:nbest
    disp([sentences{sortedidxs(h)} ' ' num2str(normlogprobs(sortedidxs(h)))]);
end

%%

if create_figures
    figure;
    pand_evidenceand = pw_evidenceand(strcmp(netobj_lab.nodeNames(netobj_lab.WORDNODES), 'and'));
    pand_evidencebut = pw_evidencebut(strcmp(netobj_lab.nodeNames(netobj_lab.WORDNODES), 'and'));
    pbut_evidenceand = pw_evidenceand(strcmp(netobj_lab.nodeNames(netobj_lab.WORDNODES), 'but'));
    pbut_evidencebut = pw_evidencebut(strcmp(netobj_lab.nodeNames(netobj_lab.WORDNODES), 'but'));
    pand_pbut = [pand_evidenceand pand_evidencebut; pbut_evidenceand pbut_evidencebut];
    bar(pand_pbut);
    set(gca, 'XTickLabel', {'"and"','"but"'}, 'FontSize',fontsize);
    set(gca, 'Position', [0.1600 0.1100 0.7750 0.6150]);
    ylabel('$P(w_i)$', 'Interpreter','latex', 'FontSize',fontsize);
    l = legend('$X_{\rm{obs}}^\prime$', '$X_{\rm{obs}}^{\prime\prime}$');
    set(l, 'Location','north');
    set(l, 'Interpreter','latex');
    set(l, 'FontSize',fontsize);
    print('-depsc', 'p_conjunctions.eps');
end;