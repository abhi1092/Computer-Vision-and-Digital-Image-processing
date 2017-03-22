clear all
img_path = './pokemon2/';
img_dir = dir([img_path,'*CP*']);
img_num = length(img_dir);
for i = 1:img_num 
    img = imread([img_path,img_dir(i).name]);
    
    [R, C, Z] = size(img);
    if Z==1
        continue;
    end
    patch = img;
     Red = patch(:,:,1);
    Green = patch(:,:,2);
    Blue = patch(:,:,3);
    %Get histValues for each channel
    [yRed, ~] = imhist(Red);
    yRed = yRed / numel(Red);
    [yGreen, ~] = imhist(Green);
    yGreen = yGreen / numel(Green);
    [yBlue, ~] = imhist(Blue);
    yBlue = yBlue / numel(Blue);
    patch1 = rgb2gray(patch);
   
    patch1 = imresize(patch1,[100 80]);
    if i==1
        image_feature = double(patch1);
    else
        image_feature = [image_feature;double(patch1)];
    end
    
    if i==1
        image_feature2 = [yRed';yGreen';yBlue'];
    else
        image_feature2 = [image_feature2;yRed';yGreen';yBlue'];
    end
end
k = 60;

[~, Centroids] = kmeans(image_feature,k,'MaxIter',1000);
image_feature2 = double(image_feature2);
[~, Centroids2] = kmeans(image_feature2,k,'MaxIter',1000);
save('kmeans.mat','Centroids','Centroids2');
%% Get Bag of words
for i = 1:img_num
    img = imread([img_path,img_dir(i).name]);
    [R, C, Z] = size(img);
    if Z==1
        continue;
    end
    name = img_dir(i).name;
    ul_idx = findstr(name,'_'); 
    ID_gt(i) = str2num(name(1:ul_idx(1)-1));
    feat(i,:) = bog_extraction(img);
end

model = fitcecoc(feat,ID_gt);

save('model.mat','model');