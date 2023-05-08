function [a] = indentificador(bw)
[L Ne]=bwlabel(bw);
propied=regionprops(L);
hold on
for n=1:size(propied,1)
    rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2);
end

s=find([propied.Area]<5000);
for n= 1:size(s,2)
    rectangle('Position',propied(s(n)).BoundingBox,'EdgeColor','r','LineWidth',2);
end 


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
for n=1:size(s,2)
    d=round(propied(s(n)).BoundingBox);
    bw(d(2):d(2)+d(4),d(1):d(1)+d(3))=0;
end

imshow(bw)
a=propied.Area
end