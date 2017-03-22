function [left_x, right_x, left_y, right_y] = eye_detection(img)
% INPUT: RGB image
% OUTPUT: x and y coordinates of left and right eye.

currentimg=img; %capture the image of interest

%Read the image
VidImage = currentimg;
height = size(VidImage,1);
width = size(VidImage,2);

out = VidImage;
bin = zeros(height,width);
%Convert the image from RGB to YCbCr
img_ycbcr = rgb2ycbcr(VidImage);
Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);
%Detect Skin
[r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);
numind = size(r,1);
%Output Skin Pixels
for i=1:numind
    out(r(i),c(i),:) = [0 0 255];
    bin(r(i),c(i)) = 1;
end
binaryImage=im2bw(bin,graythresh(bin));

%Eye Localization
l = binaryImage(1:round(end*0.5),:);
diff = size(l,1);
diff = diff * 0.4;
l = l(round(end*0.4):end,:);

%Crop the low intensity areas
for i = 1:size(l,2)/2
    if sum(l(:,i)) < 0.85*max(sum(l))
        l(:,i) = 255;
    end
end

for i = size(l,2):-1:size(l,2)/2
    if sum(l(:,i)) < 0.85*max(sum(l))
        l(:,i) = 255;
    end
end

%invert the image
for i = 1:size(l,1)
    for j = 1:size(l,2)
        if l(i,j) > 0
            l(i,j) = 0;
        else
            l(i,j) = 1;
        end
    end
end

%Calculate intensity
col = sum(l);

row = sum(l');

[el, x] = max(row);
x = x+round(diff);
f = 0;
y = [0 0];

for i = round(size(col,2)/2):-1:1
    if f == 0 && col(i) > 0
        y(1) = i;
        f = 1;
    end
    if f==1 && col(i) == 0
        y(2) = i;
        f = 2;
    end   
end

y1 = (y(1)+y(2))/2;
f = 0;
for i = round(size(col,2)/2):1:size(col,2)
    if f == 0 && col(i) > 0
        y(1) = i;
        f = 1;
    end
    if f == 1 && col(i) == 0
        y(2) = i;
        f = 2;
    end    
end

y2 = (y(1)+y(2))/2;

%Output the co-ordinates
left_x = y1;
right_x = y2;
left_y = x;
right_y = x;

end
