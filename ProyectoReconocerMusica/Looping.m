function readAllFiles(outputFilePath)
outputFileID = fopen(outputFilePath,'wt');
fprintf(outputFileID, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', 'genreName', 'length','stereoRMS', 'tempo', 'tempoWeightToDouble', 'lowBeatDev', 'highLowWeightToDouble', 'midBeatLikelihood', 'midBeatOffset','midBeatDev', 'dynamicRange', 'lowRMS', 'lowmidRMS', 'midRMS', 'highRMS', 'fastPeakStrength', 'slowPeakStrength', 'fileName');
mediaFolders = dir('media');
for i = 1:length(mediaFolders)
    if mediaFolders(i).isdir & ~(strcmp(mediaFolders(i).name, '.') | strcmp(mediaFolders(i).name, '..'))
     genreName = mediaFolders(i).name;
     disp(['Starting Genre: ' genreName])
     albumFolders = dir(['media/' mediaFolders(i).name]);
        for j = 1:length(albumFolders)
            if ~(albumFolders(j).isdir)
             trackName = albumFolders(j).name;
             readOneFile(genreName, ['media/' mediaFolders(i).name '/' albumFolders(j).name], outputFileID);
            elseif ~(strcmp(albumFolders(j).name, '.') | strcmp(albumFolders(j).name, '..'))
                albumName = albumFolders(j).name;
                tracks = dir(['media/' mediaFolders(i).name '/' albumFolders(j).name]);
                for k = 1:length(tracks) 
                    if ~tracks(k).isdir
                    trackName = tracks(k).name;
                    readOneFile(genreName, ['media/' mediaFolders(i).name '/' albumFolders(j).name '/' trackName],outputFileID);
                    end
                end
            end
        end
    end
end
fclose(outputFileID);
function readOneFile(genreName, fileName, outputFileID)
[pathstr, fname, ext] = fileparts(fileName);
switch ext
    case '.wav'
     sizeInfo = round(wavread(fileName, 'size') / 44100); % length of original, in seconds (at a guessed sample rate)
    case '.mp3'
     sizeInfo = round(mp3read(fileName, 'size') / 44100); % length of original, in seconds (at a guessed sample rate)
    otherwise
    return
end
startpos = 25; % num of seconds from start of file to start/end snippet
endpos = 50;
output = getNumbersFromAudioFile(fileName, startpos, endpos);
if isfield(output, 'length') % all good output struct
 fprintf(outputFileID,'%s\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%s\n',genreName, output.length, output.stereoRMS, output.tempo, output.tempoWeightToDouble, output.lowBeatDev,output.highLowWeightToDouble, output.midBeatLikelihood, output.midBeatOffset, output.midBeatDev, output.dynamicRange,output.lowRMS, output.lowmidRMS, output.midRMS, output.highRMS, output.fastPeakStrength, output.slowPeakStrength, fileName);
 else
 disp(['Error (returned 0) for file: ' fileName ' startpos: ' num2str(startpos) ' endpos: ' num2str(endpos)]);
return
end
longSongSegments = 240; % long songs are sampled every 4 minutes
if(sizeInfo(1) > (longSongSegments + startpos + endpos)) % if original is longer than 5 minutes 15 seconds
 partNum = 1;
 maxParts = 5; % no more than this for any one input file
while (sizeInfo(1) > ((partNum * longSongSegments) + startpos + endpos)) & (partNum < maxParts)
 longstartpos = startpos + (partNum * longSongSegments);
 longendpos = endpos + (partNum * longSongSegments);
 output = getNumbersFromAudioFile(fileName, longstartpos, longendpos);
if isfield(output, 'length') % all good output struct
    fprintf(outputFileID,'%s\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%3.5f\t%s\n',genreName, output.length, output.stereoRMS, output.tempo, output.tempoWeightToDouble, output.lowBeatDev,output.highLowWeightToDouble, output.midBeatLikelihood, output.midBeatOffset, output.midBeatDev, output.dynamicRange,output.lowRMS, output.lowmidRMS, output.midRMS, output.highRMS, output.fastPeakStrength, output.slowPeakStrength, [fileName(partNum + 49)]);
else
    disp(['Error (returned 0) for file: ' fileName ' startpos: ' num2str(startpos) ' endpos: ' num2str(endpos)]);
    return
end
 partNum = partNum + 1;
end
end