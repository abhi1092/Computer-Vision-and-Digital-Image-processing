function feat = bog_extraction(img)
% Output should be a fixed length vector [1*dimension] for a single image. 
% Please do NOT change the interface.

load('kmeans.mat','Centroids','Centroids2');
[~, ~, Z] = size(img);
    patch = img;
    if Z~=1
        Red = patch(:,:,1);
        Green = patch(:,:,2);
        Blue = patch(:,:,3);
        [yRed, ~] = imhist(Red);
        yRed = yRed / numel(Red);
        [yGreen, ~] = imhist(Green);
        yGreen = yGreen / numel(Green);
        [yBlue, ~] = imhist(Blue);
        yBlue = yBlue / numel(Blue);
        patch = rgb2gray(patch);
    end
    
        patch = imresize(patch,[100 80]);
        image_feature = double(patch);
        image_feature2 = [yRed';yGreen';yBlue'];
        
        
    idxRegion = zeros(size(image_feature,1),1);
for i=1:size(image_feature,1)
    Distance = zeros(size(Centroids,1),1);
    for j=1:size(Centroids,1)
        Distance(j) = sum(( image_feature(i,:) - Centroids(j,:)).^2);
    end
    [~,idxRegion(i)] = min(Distance);
end

%Frequency of word
feat1 = zeros(size(Centroids,1),1);
for i=1:size(Centroids,1)
    feat1(i) =  nnz(idxRegion==i);
end
feat1 = feat1';


idxRegion = zeros(size(image_feature2,1),1);
for i=1:size(image_feature2,1)
    Distance = zeros(size(Centroids2,1),1);
    for j=1:size(Centroids2,1)
        Distance(j) = sum(( double(image_feature2(i,:)) - Centroids2(j,:)).^2);
    end
    [~,idxRegion(i)] = min(Distance);
end

%Frequency of word
feat2 = zeros(size(Centroids2,1),1);
for i=1:size(Centroids2,1)
    feat2(i) =  nnz(idxRegion==i);
end
feat2 = feat2';
feat = [feat1 feat2];

end