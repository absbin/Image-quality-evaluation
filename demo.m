
% ******************* Demo - Selective Keyframe Summary ******************* 

% -------------------------------------------------------------------------
% Please cite this paper if you use this code in your publication:
%   Paria Yousefi,and Ludmila I Kuncheva
%   Selective Keyframe Summarisation for Egocentric Videos Based on 
%   Semantic Concept Search
%   Third IEEE International Conference on Image Processing, Applications 
%   and Systems (IPAS 2018)
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------

clc; close all; clear;

%% a) Initialisation

% Add functions library
addpath([pwd '\Ego_Library\'])
addpath([pwd '\Vid_Library\'])
addpath([pwd '\Detection_Library\'])

%  Choose video number and the query/ concept
vid = '01'; 
query_object = 'phone';

%  Put the frame path here in a folder called Frames
% Alternatively, you can add the frame path here. 
frame_path =[pwd '\Frames\P' vid '\'];
files = dir(frame_path);
fn = (natsortfiles({files.name}))';
f = [pwd '\results\P' vid '\'];

mkdir(f,query_object);

%% b) Search object/ concept

dt_obj = [pwd '\detected_objects\P' vid '_resnet_Object.mat'];
feat = [pwd '\features\P' vid '_vgg.mat'];

% If you run this before, just load the mat files
load(dt_obj)
load(feat)

% find the query object through the frames of a video
sv_obj_img = [pwd '\results\P' vid '\' query_object];
[fr_num_obj, count_obj] = ego_find_object(objs,query_object,vid,...
    sv_obj_img,frame_path,fn);


%% c) Occurrence-led Event Segmentation and keyframe Selection 

% convert cell to array
nm = [];
for ic = 1:size(fr_num_obj,1) 
    m = cell2mat(fr_num_obj(ic,2)); 
    nm = [nm;m]; %#ok<AGROW>
end

mkdir(f,['kf_results\' query_object]);
obj_re_kf = [pwd '\results\P' vid '\kf_results\' query_object];

% Occurrence-led Event Clustering 
% clustering based on their distribution in time. mass_or_distance: 
% 1 : use mass - automatic detection of number of clusters 
% 2 : use distances of frames (we used this)
[labels,num_lbs] = ego_timetage_clustering(nm,2); %frames' distance

% Keyframe selection: Closest-to-Centroid 
KF =[]; LBS=[];

for nl = 1:num_lbs
    ind_cl = find(labels == nl);
    
    kf = ego_centroid_per_tt_cluster(data,nm',ind_cl);
    KF = [KF kf]; %#ok<AGROW>
    LBS = [LBS nl]; %#ok<AGROW>
end

[im_cntr,~] = vid_extract_chosen_frames(frame_path, KF, 0.5);
ego_store_key_frames(im_cntr,KF,LBS,vid,obj_re_kf)

% save results 
save([pwd '\results\P' vid '\kf_results\' query_object '\detected_' ...
     query_object '_P' vid '.mat'],'im_cntr','KF','LBS','labels',...
    'num_lbs','fr_num_obj','nm','data')


%% d) Video Compass Summary - visualisation 

frnum = size(data); % number of frames/labels frnum(1)
label_all_fr = zeros(frnum(1),1);
dlb = size(labels);

total_time_sec = frnum(1)*4; %seconds 
total_time_hour = (frnum(1)*4)/3600; % minutes 

for i=1:dlb(1)
    chosen_frames(i,1) = cell2mat(fr_num_obj(i,2)); 
    label_all_fr(chosen_frames(i)) = labels(i);
end

vid_compass_summary(frame_path,label_all_fr,total_time_hour,KF,...
    chosen_frames,[0.75 0.75 0.75])



