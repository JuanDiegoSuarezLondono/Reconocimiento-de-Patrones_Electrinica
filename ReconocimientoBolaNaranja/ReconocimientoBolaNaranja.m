clear all
clc
close all
vidObj = VideoReader('C:\Users\suare\Documents\MEGA\Documentos JD\Universidad\USTA\Ingenieria Electronica\Noveno semestre\Reconocimiento de patrones\ReconocimientoBolaNaranja\orangeBall.mp4'); % open file
get(vidObj);
nFrames=get(vidObj, 'NumberOfFrames');  
width = vidObj.Width;    % get image width
height =vidObj.Height;   % get image height
xlim([0,width]); 
ylim([0,height]); 
legend('','')
hold off
snap = read(vidObj, 1); 
hImage = imshow(snap)
for iFrame=1:nFrames
    snap = read(vidObj, iFrame);  %get one RGB image
    snap_red = imsubtract(snap(:,:,1), rgb2gray(snap));
    snap_red = medfilt2(snap_red, [3 3]);
    snap_red = im2bw(snap_red,0.18);
    snap_red = bwlabel(snap_red, 8);
    if iFrame > 1
        for n=1:size(propied,1)
            if propied(n).Area > 1000
                %delete(r(n))
                delete(c(n))
            end
        end
    end
    [L Ne] = bwlabel(snap_red);
    propied = regionprops(L);  
    set(hImage,'CData',snap);
    for n=1:size(propied,1)
        if propied(n).Area > 1000
            %r(n) = rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2);
            c(n) = rectangle('Position',propied(n).BoundingBox,'Curvature',[1 1],'EdgeColor',[1 1 1]);
        end
    end

    pause (0.01)    
    s=find([propied.Area]<500);

    for n=1:size(s,2)
        d=round(propied(s(n)).BoundingBox);
        bw(d(2):d(2)+d(4),d(1):d(1)+d(3))=0;
    end

end