%Inclass 13

%Part 1. In this directory, you will find an image of some cells expressing a 
% fluorescent protein in the nucleus. 
% A. Create a new image with intensity normalization so that all the cell
% nuclei appear approximately eqully bright.
%XiaotongLu
 img_ori=imread('Dish1Well8Hyb1Before_w0001_m0006.tif');
 imshow(img_ori);
 img_double=im2double(img_ori);
 img_dilate=imdilate(img_double,strel('disk',5));
 imshow(img_dilate);
 img_norm=img_double./img_dilate;
 img_mask=img_norm>0.6;
 imshow(img_mask)
% B. Threshold this normalized image to produce a binary mask where the nuclei are marked true.
%XiaotongLu
img_filter=imfilter(img_norm,fspecial('gaussian',4,2));
img_bg=imopen(img_filter,strel('disk',100));
img_bgsub=imsubtract(img_filter,img_bg);
img_thre=img_bgsub>0.15;
imshow(img_thre);

%OR: without background subtraction

img_thre=img_norm>0.5;
imshow(img_thre,[]);

% C. Run an edge detection algorithm and make a binary mask where the edges
% are marked true.
%XiaotongLu
edge_img=edge(img_ori,'canny');
imshow(edge_img,[0.01 0.05])

% D. Display a three color image where the orignal image is red, the
% nuclear mask is green, and the edge mask is blue. 
%XiaotongLu
img_smooth=imfilter(img_ori,fspecial('gaussian',5,2));
edge_img2=edge(img_smooth,'canny',[0.01 0.05]);
toshow=cat(3,edge_img2,im2double(imadjust(img_ori)),zeros(size(img_ori)));
imshow(toshow)
edge_img3=imdilate(edge_img2,strel('disk',3));
img_mark3=imerode(imfill(edge_img3,'holes'),strel('disk',3));
toshow2=cat(3,im2double(imadjust(img_norm)),img_mark3,edge_img3);
imshow(toshow2)


%Part 2. Continue with your nuclear mask from part 1. 
%A. Use regionprops to find the centers of the objects
%XiaotongLu
cell_property=regionprops(img_mark3,'Area','Centroid','Image','PixelIdxList');
center=cat(1,cell_property.Centroid);


%B. display the mask and plot the centers of the objects on top of the
%objects
%XiaotongLu
imshow(img_mark3);
hold on;
plot(center(:,1),center(:,2),'r*','MarkerSize','5')

%C. Make a new figure without the image and plot the centers of the objects
%so they appear in the same positions as when you plot on the image (Hint: remember
%Image coordinates). 
%XiaotongLu
figure;
M=center(:,1);
N=center(:,2)*-1;
plot(M,N,'r*','MarkerSize',5)
axis([1 1024 -1024 -1]);


