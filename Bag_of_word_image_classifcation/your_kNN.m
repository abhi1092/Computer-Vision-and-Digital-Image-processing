function predict_label = your_kNN(feat)
% Output should be a fixed length vector [num of img, 1]. 
% Please do NOT change the interface.
load('model.mat','feat_train','label_train','idf','Centroids');
predict_label = zeros(size(feat,1),1);
knn = 4;

%%
%%Apply tf idf weighting

for i=1:size(feat,2)
    feat(:,i) = feat(:,i)*idf(i);
end


%%Calculate distance to every train image vector

for i=1:size(feat,1)
     distances = zeros(size(feat_train,1),1);
   
     
    for j=1:size(feat_train,1)
        distance1 = feat_train(j,:)-feat(i,:);
        distance1 = sqrt(distance1*distance1');  
        distances(j) = distance1;
    end

    
    %%KNN
    vote = zeros(30,1);
    max1 = max(distance1);
    for j=1:knn
       [~,I] = min(distances);
       distances(I) = max1;
       vote(label_train(I)) = vote(label_train(I))+1;
      
    end
   
        [~,predict_label(i)] = max(vote);
end
 

end