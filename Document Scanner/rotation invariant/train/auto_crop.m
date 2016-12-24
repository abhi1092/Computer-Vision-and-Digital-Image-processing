function [x0, y0, x1, y1, x2, y2, x3, y3] = auto_crop ( f )

%%%IMPORTANT%%%
% x0,y0 are the x, y coordinates of the top left corner of image
% x1,y1 are the x, y coordinates of the top right corner of image
% x2,y2 are the x, y coordinates of the bottom right corner of image
% x3,y3 are the x, y coordinates of the bottom left corner of image

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

for i=floor(0.935*ro):-1:ro/2
    
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

x0 = col_x;
y0 = row_x;
x1 = col_y;
y1 = row_x;
x2 = col_y;
y2 = row_y;
x3 = col_x;
y3 = col_y;









