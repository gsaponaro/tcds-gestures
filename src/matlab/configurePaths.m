% configure relevant paths
addpath(genpath('~/matlab/toolbox/FullBNT-1.0.4'));
addpath('.');
addpath('./robot_data'); % robot self-exploration data, words-affordances BN
addpath('./human_data'); % external agent data, gestures, object features(?)

LanguageBoostrapping_root = ('~/NOBACKUP/AffordancesAndSpeech/bayesian_net');
if exist(LanguageBoostrapping_root, 'file')==0
    LanguageBoostrapping_root = ('~/Documents/AffordancesAndSpeech/bayesian_net');
end

addpath(genpath([LanguageBoostrapping_root '/matlab']));
