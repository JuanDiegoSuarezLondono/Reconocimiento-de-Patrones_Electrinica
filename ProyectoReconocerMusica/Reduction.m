function makeDAT(inputFilePath, selections)
inputFileID = fopen(inputFilePath, 'r');
outputTrainFileID = fopen(['dat files/' num2str(selections) '_train.dat'],'wt'); 
outputTestFileID = fopen(['dat files/' num2str(selections) '_test.dat'],'wt');
rawData = textscan(inputFileID, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %s', 'headerlines', 1, 'whitespace','\t');
switch selections
case 1 % everything
 selections = [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17];
case 2 % 'about' the song
 selections = [2 3 4 11];
case 3 % tempo and weight to doubles only
 selections = [4 5 7];
case 4 % beat deviations
 selections = [6 10];
case 5 % frequency spectrum
 selections = [12 13 14 15];
case 6 % mid beat things
 selections = [8 9];
case 7 % peak attack
 selections = [16 17];
case 8 % things from 2, 3, 5 and 7 above
 selections = [2 3 4 5 7 11 12 13 14 15 16 17];
case 9 % things from 2, 5 and 7 above
 selections = [2 3 4 11 12 13 14 15 16 17];
end
numLines = length(rawData{1});
genres = unique(rawData{1});
genreCodeFormat = '';
for i = 1:length(genres)
 genreCodeFormat = [genreCodeFormat '%4.5f\t'];
end
for i = 1:numLines 
    if rem(i, 3) % 2 out of 3 samples go into training set
 outputFID = outputTrainFileID;
else % every 3rd sample goes into the test set
 outputFID = outputTestFileID;
end
for j = 1:length(selections)
 fprintf(outputFID, '%4.5f\t', rawData{selections(j)}(i));
end
 genreCode = permute(strcmp(genres, rawData{1}{i}), [2 1]); % gives a 1 in the column of this genre only
 fprintf(outputFID, [genreCodeFormat '\n'], genreCode);
end
fclose(outputTrainFileID);
fclose(outputTestFileID);
fclose(inputFileID); 