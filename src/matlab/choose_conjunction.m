%% configure BNT and other paths
clear;
configurePaths;

%% load data
load('BN_lab.mat');

%% user parameters
word_threshold = 0.2;
create_figures = true;
fontsize = 16;

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
pand_evidenceand = pw_evidenceand(strcmp(netobj_lab.nodeNames(netobj_lab.WORDNODES), 'and'));
pand_evidencebut = pw_evidencebut(strcmp(netobj_lab.nodeNames(netobj_lab.WORDNODES), 'and'));
pbut_evidenceand = pw_evidenceand(strcmp(netobj_lab.nodeNames(netobj_lab.WORDNODES), 'but'));
pbut_evidencebut = pw_evidencebut(strcmp(netobj_lab.nodeNames(netobj_lab.WORDNODES), 'but'));
pand_pbut = [pand_evidenceand pand_evidencebut; pbut_evidenceand pbut_evidencebut];

if create_figures
    figure;
    barh([pand_evidenceand, pbut_evidenceand])
    set(gca, 'YTickLabel', {'"and"', '"but"'}, 'FontSize',fontsize)%, 'xlim', [0.2, 2.8])
    set(gca, 'Position', [0.1300 0.1298 0.7750 0.2], 'ylim', [0.2 2.8]);
    title('$P_{\rm{comb}}(w_i\mid X_{\rm{obs}}, G_1^T)$', 'Interpreter','latex', 'FontSize',fontsize);
    print('-depsc', 'p_conjunctions_and_evidence.eps');

    figure;
    barh([pand_evidencebut, pbut_evidencebut])
    set(gca, 'YTickLabel', {'"and"', '"but"'}, 'FontSize',fontsize)%, 'xlim', [0.2, 2.8])
    set(gca, 'Position', [0.1300 0.1298 0.7750 0.2], 'ylim', [0.2 2.8]);
    title('$P_{\rm{comb}}(w_i\mid X_{\rm{obs}}, G_1^T)$', 'Interpreter','latex', 'FontSize',fontsize);
    print('-depsc', 'p_conjunctions_but_evidence.eps');
end