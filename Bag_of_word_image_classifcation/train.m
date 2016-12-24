% You can change anything you want in this script.
% It is provided just for your convenience.
clear; clc; close all;

img_path = './train/';
class_num = 30;
img_per_class = 60;
img_num = class_num .* img_per_class;


folder_dir = dir(img_path);

label_train = zeros(img_num,1);

%%
%%Extract Features
for i = 1:length(folder_dir)-2
    
    img_dir = dir([img_path,folder_dir(i+2).name,'/*.JPG']);
    if isempty(img_dir)
        img_dir = dir([img_path,folder_dir(i+2).name,'/*.BMP']);
    end
    
    label_train((i-1)*img_per_class+1:i*img_per_class) = i;
    
    for j = 1:length(img_dir)    
    
        img = imread([img_path,folder_dir(i+2).name,'/',img_dir(j).name]);
        img = rgb2gray(img);
        corners = detectSURFFeatures(img);
        [features, ~] = extractFeatures(img, corners);
           if(i==1 && j==1)
               image_feature = features;
           else
               image_feature = [image_feature;features];
           end
           
    end
    
end
%%Train Kmeans
k = 100;
image_feature = double(image_feature);
[idx, Centroids] = kmeans(image_feature,k);

save('Trained_model.mat','Centroids','image_feature');


%%

feat_dim = size(feature_extraction(imread('./val/Balloon/329060.JPG')),2);
feat_train = zeros(img_num,feat_dim);


for i = 1:length(folder_dir)-2
    
    img_dir = dir([img_path,folder_dir(i+2).name,'/*.JPG']);
    if isempty(img_dir)
        img_dir = dir([img_path,folder_dir(i+2).name,'/*.BMP']);
    end
    
    label_train((i-1)*img_per_class+1:i*img_per_class) = i;
    
    for j = 1:length(img_dir)
        
        img = imread([img_path,folder_dir(i+2).name,'/',img_dir(j).name]);
        feat_train((i-1)*img_per_class+j,:) = feature_extraction(img);
    end
    
end

%%Tf-idf calculation
%N is number of images
idf = zeros(size(Centroids,1),1);
N=1800;
for i=1:size(Centroids,1)
    d_f = nnz(feat_train(:,i)>0);
    idf(i) = log(N/d_f);
end

%%Weighting with the idf weights calculated above.
for i=1:size(feat_train,2)
    feat_train(:,i) = feat_train(:,i) * idf(i);
end

save('model.mat','feat_train','label_train','idf','Centroids');