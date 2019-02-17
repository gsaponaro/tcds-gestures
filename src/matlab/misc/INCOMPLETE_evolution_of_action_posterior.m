%% configure BNT and other paths
configurePaths;

%% user parameters
create_figures = true;
fontsize = 10;
interval = 5;

%% box experiment
fid_box = fopen('./human_data/norobotview_tap_notable_seated_2/data.log'); %ok
human_box = textscan(fid, '%d %f %f %f %f');
human_box{1,1} = [];
human_box{1,2} = [];
human_box = cell2mat(human_box);
human_box = human_box / 1000; % for compatibility with 2013 models
human_box_startframe = 230;
human_box_endframe = 375;
human_box_seglim = [human_box_startframe;
                human_box_endframe];
human_box_cell = separate_sequence(human_box, human_box_seglim);
human_box_BNT = transpose_cell_array(human_box_cell); % transpose to BNT format
human_box_data = human_box_BNT{1}; % get the matrix of coordinates
box_sequence_length = size(human_data, 2);
box_iteration_frames = interval:interval:box_sequence_length;
num_iterations_box = length(box_iteration_frames);
ev_box = cell(1,num_iterations_box); % will store HMM evidence in BNActionValue order: grasp,tap,touch


actpost_box = posterior_hmm(fid_box);


%% sphere

