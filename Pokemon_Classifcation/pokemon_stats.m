function [ID, CP, HP, stardust, level, cir_center] = pokemon_stats (img, model)
% Please DO NOT change the interface
% INPUT: image; model(a struct that contains your classification model, detector, template, etc.)
% OUTPUT: ID(pokemon id, 1-201); level(the position(x,y) of the white dot in the semi circle); cir_center(the position(x,y) of the center of the semi circle)

load('model.mat','model');
img1 = img;
ID = 1;
CP = 0;
HP = 0;
stardust = 0;
level = [327,165];
[R, C, Z] = size(img);
cir_center = [round(0.33*R),round(0.5*C)];
    if Z~=1
        img = rgb2gray(img);
    end
    start_row = round(0.026*R);
    end_row = round(0.115*R);
    start_col = round(C * 0.43);
    end_col = round(C * 0.58);
    patch = img(start_row:end_row,start_col:end_col);
   CP = OCR(patch);
   %%Detect Stardust
  start_row = round(0.73*R);
    end_row = round(0.8*R);
    start_col = round(C * 0.5);
    end_col = round(C * 0.55);
    patch = img(start_row:end_row,start_col:end_col);
   stardust = OCR(~im2bw(patch, 0.9));
    
 start_row = round(0.78*R);
 end_row = round(0.82*R);
 start_col = round(C * 0.55);
 end_col = round(C * 0.67);
 patch = img(start_row:end_row,start_col:end_col);
 HP = OCR(~im2bw(patch, 0.9));
    
[~,~,Z] = size(img1);
if Z~=1
    ID = predict(model,bog_extraction(poke_patch(img1)));
else
    ID = 200;
end
end
