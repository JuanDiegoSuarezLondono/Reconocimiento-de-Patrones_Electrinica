%menciptakan object akuisisi dari web-cam
vidDevice = imaq.VideoDevice('winvideo', 1, 'YUY2_640x480', ...
'ROI', [1 1 640 480], ...
'ReturnedColorSpace', 'rgb');

%menciptakan object video player original
hVideoIn = vision.VideoPlayer;
hVideoIn.Name = 'Original Video';
hVideoIn.Position = [30 100 640 480];

%menciptakan object video player fingers tracking
hVideoOut = vision.VideoPlayer;
hVideoOut.Name = 'Fingers Tracking Video';
hVideoOut.Position = [700 100 640 480];

%menciptakan blob analysis
hblob = vision.BlobAnalysis('AreaOutputPort', false, ... %untuk menghitung area   %%Set blob analysis handling%%
                                'CentroidOutputPort', true, ... % untuk mengambil kordinat center
                                'BoundingBoxOutputPort', true', ... % untuk mengambil kordinat box
                                'MinimumBlobArea', 800, ... % min area pixel blob
                                'MaximumBlobArea', 3000, ... % max area pixel blob
                                'MaximumCount', 10); % maks blob yang dapat dihitung
%menciptakan shape inserter                            
hshapeinsRedBox = vision.ShapeInserter('BorderColor', 'Custom', ...%%Set Red box handling%%
                                        'CustomBorderColor', [1 0 0], ...
                                        'Fill', true, ...
                                        'FillColor', 'Custom', ...
                                        'CustomFillColor', [1 0 0], ...
                                        'Opacity', 0.4);
%menciptakan text inserter 1                               
htextins = vision.TextInserter('Text', 'Hi, Saya melihat: %2d jari kamu terangkat', ... % Set text for number of blobs
                                    'Location',  [12 20], ...
                                    'Color', [0 1 0], ... // red color
                                    'FontSize', 12);
                                
%menciptakan text inserter 2                                
htextinsCent = vision.TextInserter('Text', '+      X:%4d, Y:%4d', ... % set text for centroid
                                    'LocationSource', 'Input port', ...
                                    'Color', [1 1 0], ... // yellow color
                                    'FontSize', 14);

%%%%%%%%%%%%%%%%%%%%%%%%% Program Inti %%%%%%%%%%%%%%%%%%%%%%%%%
nFrames = 0;
while (nFrames <= 50) %menjalankan program hingga 200 Frame diakuisisi
    rgbData = step(vidDevice); %mengakuisisi 1 frame
    rgbData = flipdim(rgbData,2); %mencerminkan gambar
    data = rgbData;
    
    % Skin Segmentation
    diff_im = imsubtract(data(:,:,1), rgb2gray(data)); %mengurangi channel merah dengan grayscale
    diff_im = medfilt2(diff_im, [3 3]); %filtering
    diff_im = imadjust(diff_im); %melakukan color-maping pada hasil pengurangan
    level = graythresh(diff_im); %menemukan threshold dengan otsu methode
    bw = im2bw(diff_im,level); %mekonversi ke binary image
    bwfill = medfilt2(imfill(bw,'holes'), [3 3]); %mengisi lubang bila ada
    
    % Fingers Extraction
    se1 = strel('disk',28);
    kikis = imerode(bwfill,se1);
    
    se2 = strel('disk',40);
    tebalin = imdilate(kikis,se2);    
    
    hasil = imsubtract(bwfill,tebalin);
    se3 = strel('disk',5);
    jari = imerode(hasil,se3);
    jari = im2bw(jari);
    
    % Representation
    [centroid, bbox] = step(hblob, jari); %% % mengambil nilai centroid dan bounding box dari blobs
    centroid = uint16(centroid); % konversi nilai centroid
    data(1:40,1:250,:) = 0; % label hitam pada sudut atas video player fingers traker
    vidIn = step(hshapeinsRedBox, data, bbox); % memberi label merah jika jari ditemukan
    for object = 1:1:length(bbox(:,1)) % memberi kondinat pada bbox
        centX = centroid(object,1); centY = centroid(object,2);
        vidIn = step(htextinsCent, vidIn, [centX centY], [centX-6 centY-9]); 
    end
    vidIn = step(htextins, vidIn, uint8(length(bbox(:,1)))); %% Menghitung jumlah bbox
    rgb_Out = vidIn;

    step(hVideoIn, rgbData); %mengirimkan frame akuisisi original ke video player 1
    step(hVideoOut, rgb_Out); %mengirimkan frame hasil manupulasi ke video player 2
    nFrames = nFrames + 1;
    
end
imshow(rgb_Out);
if length(bbox(:,1)) >= 4
    disp('Papel')
end


if length(bbox(:,1)) == 0 || length(bbox(:,1)) == 1 
    disp('Piedra')
end


if length(bbox(:,1)) < 4 || length(bbox(:,1)) > 1
    disp('Tijeras')
end

%release semua object video
release(hVideoOut);
release(hVideoIn);
release(vidDevice);