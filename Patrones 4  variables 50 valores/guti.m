img=imread('banano.jpg');
im_g=rgb2gray(img);
umb=graythresh(im_g);
bw=imbinarize(im_g,umb);
cuadrado=strel('square',50);
bw=imerode(bw,cuadrado);
% bw=bw-1;
% bw=abs(bw);
imshow(bw)
[L Ne]=bwlabel(bw);
propied=regionprops(L);
hold on
for n=1:size(propied,1)
    rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2);
end
pause(3)
s=find([propied.Area]<5000);
for n= 1:size(s,2)
    rectangle('Position',propied(s(n)).BoundingBox,'EdgeColor','r','LineWidth',2);
end 
pause(2)

for n=1:size(s,2)
    d=round(propied(s(n)).BoundingBox);
    bw(d(2):d(2)+d(4),d(1):d(1)+d(3))=0;
end

bw=bw-1;
bw=abs(bw);
imshow(bw)
[L Ne]=bwlabel(bw);
propied=regionprops(L);
hold on
for n=1:size(propied,1)
    rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2);
end
pause(3)
s=find([propied.Area]<5000);
for n= 1:size(s,2)
    rectangle('Position',propied(s(n)).BoundingBox,'EdgeColor','r','LineWidth',2);
end 
pause(2)

for n=1:size(s,2)
    d=round(propied(s(n)).BoundingBox);
    bw(d(2):d(2)+d(4),d(1):d(1)+d(3))=0;
end

figure
imshow(bw)
a=propied.Area
%% histograma
img=imread('ciruela.jpg');
d=rgb2hsv(img);
d=mean(d(:,:,1));
d=mean(d)
