function [ct] = how_many ( prefix, ct_f, num_f )
%prefix - name of video folder
%ct_f - vector of frames used for grading
%num_f - number of frames

%i is an array of integers from 1 to the number of frames
i = [1:num_f];

%load an image

for i=1:num_f
    fn = sprintf ( '%sFRM_%05d.png%', prefix, i);
    double_image = im2double(imread(fn));
    if i == 1
    sumImage = double_image;
    else
    sumImage = sumImage + double_image;
    end
end
sumImage = sumImage/num_f;
background = sumImage;
%ct = zeros(size(ct_f,2),1);
%Some random numbers get returned
for i=1:numel(ct_f)
    fn = sprintf ( '%sFRM_%05d.png%', prefix, ct_f(i));
    img = imread ( fn );
    foregroung = im2double(img);
    difference = rgb2gray(abs((foregroung - background)));
   % difference = abs(rgb2gray(foregroung) - imgaussfilt( rgb2gray(background) ,5));
    %difference = difference *4;
    threshold = 0.1;
    B = strel('disk',5,0);
    false = difference > threshold;
    false = imclose(false,B);
    connected_label = bwlabel(false);
    [stats] = regionprops(connected_label,'Area');
    x = [stats.Area];
    true = connected_label;
    %true = zeros(size(connected_label));
    for j=1:numel(x)
        if(x(j)<100)
            true(connected_label==j) = 0;
        end
    end
    %true = imdilate(true,B);
    connected_label = bwlabel(true);
    for col = 1:size(connected_label,2)
         if(connected_label(1,col)~=0 && x(connected_label(1,col))<100)
            true(connected_label==connected_label(1,col)) = 0;
        end
        if(connected_label(end,col)~=0 && x(connected_label(end,col))<100)
            true(connected_label==connected_label(1,col)) = 0;
        end
    end
    for row = 1:size(connected_label,1)
    
        if(connected_label(row,1)~=0 && x(connected_label(row,1))<100 )
            true(connected_label==connected_label(row,1)) = 0;
        end
        if(connected_label(row,end)~=0 && x(connected_label(row,end))<100 )
            true(connected_label==connected_label(row,1)) = 0;
        end
    end
    % true = imopen(true,B);
    connected_label = bwlabel(true);
    [stats] = regionprops(connected_label,'Area');
    x = [stats.Area];
    ct(i) = size(x,2);
end
