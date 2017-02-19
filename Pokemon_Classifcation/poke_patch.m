function patch = poke_patch(img)
[R, C, ~] = size(img);
   
    start_row = ceil(0.15*R);
    end_row = ceil(0.45*R);
    start_col = ceil(C * 0.3);
    end_col = ceil(C * 0.7);
    patch = img(start_row:end_row,start_col:end_col,:);
end