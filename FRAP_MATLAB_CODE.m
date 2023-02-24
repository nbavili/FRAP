
total_number_of_frames = 100; % To be entered by user
last_number_before_bleaching = 3; % To be entered by user
bleaching_number = 4; %just for user
first_number_after_bleach = 4; % To be entered by user

%%%%% import images 
% image1 for bleached region
% image2 for BG region
% image2 for ref region

for n=1:total_number_of_frames  
image1(:,:,n)=imread('Image_stack.tif',n);
end
for n=1:total_number_of_frames  
image2(:,:,n)=imread('Image_stack.tif',n);
end
for n=1:total_number_of_frames  
image3(:,:,n)=imread('Image_stack.tif',n);
end
figure;
imshow(image1(:,:,bleaching_number));
title('Select Bleached Region');
impixelinfo
h_main_region = imrect(gca,[255 212 14 14]);
wait(h_main_region);
% 
pos_1 = h_main_region.getPosition();
BW_main_region = createMask(h_main_region);
%%%%% Apply mask to image in order to select bleached (main) region

for n=1:total_number_of_frames
    for i=1:512
        for j=1:512
             if BW_main_region(i,j) == 0
                image1(i,j,n)=0;
             end
        end
    end
end

area_of_main_region = 196;
%%%%% Find area of main region if bigger
% for i=1:512
%      for j=1:512
%           if BW_main_region(i,j) == 1
%                area_of_main_region = area_of_main_region + 1
%           end
%      end
% end

%%%%% Find intensity of ROI main in each image
for n = 1:total_number_of_frames
    s(1,:,n)=sum(image1(:,:,n));
    I_FRAP(n,:)=sum(s(1,:,n),2);
end
I_FRAP = I_FRAP / area_of_main_region;

%--------------------------------------------%

%%%%% Background selection
figure;
imshow(image2(:,:,bleaching_number));
title('Select BG Region');
impixelinfo
h_BG_region = imrect(gca,[10 10 14 14]);
wait(h_BG_region);
BW_BG_region = createMask(h_BG_region);

for n=1:total_number_of_frames
    for i=1:512
        for j=1:512
             if BW_BG_region(i,j) == 0
                image2(i,j,n)=0;
             end
        end
    end
end

area_of_BG_region=196;

% for i=1:512
%         for j=1:512
%              if BW_BG_region(i,j) == 1
%                 area_of_BG_region = area_of_BG_region + 1;
%              end
%         end
% end

%%%%% Find intensity of ROI BG in each image
for n = 1:total_number_of_frames
    ss(1,:,n)=sum(image2(:,:,n));
    I_BG(n,:)=sum(ss(1,:,n),2);
end
I_BG = I_BG / area_of_BG_region;

%%%%% Reference selection

figure;
imshow(image3(:,:,bleaching_number));
title('select reference region');
h_ref_region = imfreehand;
BW_ref_region = createMask(h_ref_region);

for n=1:total_number_of_frames
    for i=1:512
        for j=1:512
             if BW_ref_region(i,j) == 0
               image3(i,j,n)=0;
             end
        end
    end
end
%%%%% Find area of ref region
 area_of_ref_region=0;
for i=1:512
        for j=1:512
             if BW_ref_region(i,j) == 1
               area_of_ref_region = area_of_ref_region + 1;
             end
        end
end
%%%%% Find intensity of ROI ref in each image
for n= 1:total_number_of_frames
    sss(1,:,n) = sum(image3(:,:,n));
    I_ref(n,:) = sum(sss(1,:,n),2);
end
I_ref = I_ref / area_of_ref_region;



% first_ratio = (I_ref(1,1)-I_BG(1,1))/(I_FRAP(1,1)-I_BG(1,1));
first_ratio = (I_ref(1,1))/(I_FRAP(1,1));
for t = 1:total_number_of_frames
%       NORMALIZED_AND_CORRECTED_VALUE (t,1) = ((I_FRAP(t,1)-I_BG(t,1))/(I_ref(t,1)-I_BG(t,1))).*first_ratio;
   NORMALIZED_AND_CORRECTED_VALUE (t,1) = ((I_FRAP(t,1))/(I_ref(t,1))).*first_ratio;
end

x_x=1:length(NORMALIZED_AND_CORRECTED_VALUE);
plot(x_x,NORMALIZED_AND_CORRECTED_VALUE)

%%%%%%%%%%%%%
