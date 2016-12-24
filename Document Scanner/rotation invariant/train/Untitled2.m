f1 = imread('./data/input_12.jpg');

for j=1:3
    f = f1(:,:,j);
    patch_size = 5;
    [R,C] = size(f);
    mid_row = round(R/2);
    mid_colun = round(C/2);
    patch = f(mid_row-patch_size:mid_row+patch_size,mid_colun-patch_size:mid_colun+patch_size);
    max_threshold = mean(mean(patch));
    for i=mid_colun-100:mid_colun+100
        patch = f(mid_row-patch_size:mid_row+patch_size,i-patch_size:i+patch_size);
        threshold = mean(mean(patch));
        if(threshold>max_threshold)
            patch2 = patch;
            max_threshold = threshold;
        end
    end
    img1 = f < (max_threshold+30) & f > (max_threshold-30);
    connected_label = bwlabel(img1);
    [stats] = regionprops(connected_label,'Area');
    x = [stats.Area];
    [~,idx] = max(x);
    img2 = zeros(size(img1));
    img2(connected_label==idx)=1;
    if(j==1)
        img3 = img2;
    else
        img3 = cat(3,img3,img2);
    end
end
final_image = img3(:,:,1)&img3(:,:,2)&img3(:,:,3);
figure;
imshow(final_image);
corner_patch = final_image(1:end/2,1:end/2);
figure;
max_sum = max(sum(corner_patch'));
per = 1.0;
for i=1:size(corner_patch,1)
    if(sum(corner_patch(i,:)')>per*max_sum)
        x0 = i;
        break;
    end
end
max_sum = max(sum(corner_patch));
per = 1.0;
for i=1:size(corner_patch,2)
    if(sum(corner_patch(:,i))>per*max_sum)
        y0 = i;
        break;
    end
end

corner_patch(x0,:) = 0;
corner_patch(:,y0) = 0;
imshow(corner_patch);


corner_patch = final_image(end/2:end,1:end/2);
figure;

max_sum = max(sum(corner_patch'));
per = 1.0;
x3=1;
for i=1:size(corner_patch,1)
    if(sum(corner_patch(i,:)')>per*max_sum)
        x3 = i;
        break;
    end
end
max_sum = max(sum(corner_patch));
per = 1.0;
y3=1;
for i=1:size(corner_patch,2)
    if(sum(corner_patch(:,i))>per*max_sum)
        y3 = i;
        break;
    end
end

corner_patch(x3,:) = 0;
corner_patch(:,y3) = 0;
imshow(corner_patch);

corner_patch = final_image(1:end/2,end/2:end);
figure;

max_sum = max(sum(corner_patch'));
per = 1.0;
for i=1:size(corner_patch,1)
    if(sum(corner_patch(i,:)')>per*max_sum)
        x1 = i;
        break;
    end
end
max_sum = max(sum(corner_patch));
per = 1.0;
for i=1:size(corner_patch,2)
    if(sum(corner_patch(:,i))>per*max_sum)
        y1 = i;
        break;
    end
end

corner_patch(x1,:) = 0;
corner_patch(:,y1) = 0;
imshow(corner_patch);

corner_patch = final_image(end/2:end,end/2:end);
figure;



max_sum = max(sum(corner_patch'));
per = 1.0;
for i=1:size(corner_patch,1)
    if(sum(corner_patch(i,:)')>per*max_sum)
        x2 = i;
        break;
    end
end
max_sum = max(sum(corner_patch));
per = 1.0;
for i=1:size(corner_patch,2)
    if(sum(corner_patch(:,i))>per*max_sum)
        y2 = i;
        break;
    end
end

corner_patch(x2,:) = 0;
corner_patch(:,y2) = 0;
imshow(corner_patch);
