function [sx, sy, sWidth, sHeight] = auto_crop ( f )
% Find the least dominant color channel and select that
if(f(10,10,3)<f(10,10,1))
    
        if(f(10,10,3)<f(10,10,2))
            f = (f(:,:,3));
        else
            f = (f(:,:,2));
        end
elseif (f(10,10,1)<f(10,10,2))
    f = (f(:,:,1));
else
    f = (f(:,:,2));
end

%getting size of the input image
ro = size(f,1);
co = size(f,2);
h = imhist(f);
thres_per = 0.12;
max1 = max(h);
r_start=0;
r_end=0;
%Find the first local maxima in histogram. We start from 255 as many have noise at 256 
flag=0;
for i=255:-1:1
    if(h(i)>thres_per*max1&&flag==0)
            
            flag=1;
            r_start = i;
    end
    if(h(i)<thres_per*max1&&flag==1)
        r_end = i;
        break;
    end
end

%Set all pixel found in above range as 255 and others 0(Thresholding)
f = (f + 255).*uint8((f<r_start&f>r_end));


max_percentage = 0.7;
%Find row start and end of cropping area
max_i = max(sum(f,2));
row_x=1;

for i=1:ro/2
    
    if( sum(f(i,:)) > max_i*max_percentage )
        row_x = i;
        
           break;
    end
end
row_y=1;

for i=uint16(0.935*ro):-1:ro/2
    
    if( sum(f(i,:)) > max_i*max_percentage )
        row_y = i;
       
           break;
    end
end


%find row start and end of column area
max_i = max(sum(f(:,1:end/2)));
col_x=1;

for i=1:co/2
    
    if( sum(f(:,i)) > max_i*max_percentage )
        col_x = i;
        
           break;
    end
end
max_i = max(sum(f));
col_y=1;

for i=co:-1:co/2
    
    if( sum(f(:,i)) > max_i*max_percentage )
        col_y = i;
        
           break;
    end
end


if( (col_y >= 0.9*size(f,2)|| col_y==1) )
    col_y = 0.9*size(f,2);
end

if( (col_x<0.1*size(f,2)||col_x==1) )
    col_x = 0.1*size(f,2);
end


if( (row_y >= uint16(0.94*size(f,1))|| row_y==1) )
    row_y = 0.8*size(f,1);
end

if( (row_x<0.04*size(f,1)||row_x==1) )
    row_x = 0.2*size(f,1);
end


%Some random numbers come out of here
% sx, sy are the row, column coordinates of the top left corner of image
% sWidth, sHeight are the the dimensions of the document
sx = col_x;
sy = row_x;
sWidth = col_y-col_x;
sHeight = row_y-row_x;



