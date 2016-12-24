function feat = feature_extraction(img)
% Output should be a fixed length vector [1*dimension] for a single image. 
% Please do NOT change the interface.

load('Trained_model.mat','Centroids', 'image_feature');
img = rgb2gray(img);
corners = detectSURFFeatures(img);
[features, ~] = extractFeatures(img, corners);
%idxRegion = kmeans(double(features.Features),size(Centroids,1),'MaxIter',1,'Start',Centroids);
idxRegion = zeros(size(features,1),1);
for i=1:size(features,1)
    Distance = zeros(size(Centroids,1),1);
    for j=1:size(Centroids,1)
        Distance(j) = sum(( double(features(i,:)) - Centroids(j,:)).^2);
    end
    [~,idxRegion(i)] = min(Distance);
end

%Frequency of word
feat = zeros(size(Centroids,1),1);
for i=1:size(Centroids,1)
    feat(i) =  nnz(idxRegion==i);
end
feat = feat';


end