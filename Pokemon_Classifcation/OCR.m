function num = OCR(img)
num = 0;
kl = 1;
if ~islogical(img)
    BW = im2bw(img, 0.9);
else
    BW = img;
end
stats = regionprops(BW);
for index=1:length(stats)
    if stats(index).Area > 200 && stats(index).BoundingBox(3)*stats(index).BoundingBox(4) < 30000
    x = ceil(stats(index).BoundingBox(1));
    y= ceil(stats(index).BoundingBox(2));
    widthX = floor(stats(index).BoundingBox(3)-1);
    widthY = floor(stats(index).BoundingBox(4)-1);
    subimage(index) = {BW(y:y+widthY,x:x+widthX,:)}; 
    patch = subimage{index};
     for k=0:12
            T = imread(sprintf('./digits/%d.jpg',k));
            T = imresize(T,size(patch));
            coreelation(k+1) = corr2(patch,T);
     end
        [~,idx] = max(coreelation);
        if idx<11
            num = num + kl*(idx-1);
            kl = kl*10;
        end
    end
end
num=str2double(fliplr(num2str(num)));
end
