img_path = './train/';
img_dir = dir([img_path,'*CP*']);
img_num = length(img_dir);
k=0;
for i = 1:img_num 
    img = imread([img_path,img_dir(i).name]);
    name = img_dir(i).name;
    ul_idx = findstr(name,'_'); 
    ID_gt(i) = str2num(name(1:ul_idx(1)-1));
    % get ground truth annotation from image name
    [R, C, Z] = size(img);
    if Z==1
        continue;
    end
    start_row = round(0.15*R);
    end_row = round(0.45*R);
    start_col = round(C * 0.3);
    end_col = round(C * 0.7);
    patch = img(start_row:end_row,start_col:end_col,:);
    imwrite(patch,sprintf('./pokemon2/%s',name));
    %for j = 1:5
     %   imwrite(patch,sprintf('./pokemon2/%d_CP_%d.jpg',ID_gt(i),k));
      %  k = k+1;
    %end
end