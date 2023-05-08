[datamono,Fs]=audioread('C:\Users\suare\Desktop\audio\genres\blues\blues.00000.au');

songLength=round(length(datamono)/Fs);

[b,a] = butter(4, 200 / (Fs / 2), 'low'); % LPF at 200 Hz
datalow = filtfilt(b, a, datamono);
[b,a] = butter(4, 5000 / (Fs / 2), 'high'); % HPF at 5000 Hz
datahigh = filtfilt(b, a, datamono);
[b,a] = butter(4, [600 / (Fs / 2), 1250 / (Fs / 2)], 'bandpass'); % band at 600Hz - 1.25kHz
datamid = filtfilt(b, a, datamono);
[b,a] = butter(4, [200 / (Fs / 2), 500 / (Fs / 2)], 'bandpass'); % band at 200Hz - 500Hz
datalowmid = filtfilt(b, a, datamono);

tempo=tempo2(datamono,Fs);

lowBeatList = beat2(datalow, Fs, [110, 0.9], 1);
lowBeatGaps = diff(lowBeatList); % relative time between each low beat
lowBeatGaps = (lowBeatGaps - (30 / tempo(2))) / (30 / tempo(2)); % scale the gap times to 0 for same as tempo, 1 for skipped one beat
lowBeatDev = norm(lowBeatGaps)/sqrt(length(lowBeatGaps)); % take the RMS of the deviation from the tempo for low beats
lowTempo = tempo2(datalow, Fs); % get tempo of low freq
highTempo = tempo2(datahigh, Fs); % get tempo of high freq
highLowWeightToDouble = lowTempo(2) / highTempo(2); % ratio of weighting for high freq. Reference is bass
midBeatList = beat2(datamid, Fs, [110, 0.9], 1); % get the beat list for mid frequencies
midBeatLikelihood = length(midBeatList) / length(lowBeatList); % the number of mid frequency beats, as compared to the number of low frequency beats.
i = 1; % which midBeatList value to use... used midBeat value must be after the first lowBeat
midBeatOffsetTime = midBeatList(i) - lowBeatList(1); % the time difference between first low beat and the following mi beat
while midBeatOffsetTime < 0 % step through midBeatList until we find one greater than the first value in lowBeatList... and use that one
 i = i + 1;
 midBeatOffsetTime = midBeatList(i) - lowBeatList(1);
end;
midBeatOffset = midBeatOffsetTime / (60 / tempo(2)); % scale relative to the tempo (that is, give in beats)
midBeatGaps = diff(midBeatList); % relative time between each mid beat
midBeatGaps = (midBeatGaps - (30 / tempo(2))) / (30 / tempo(2)); % scale the gap times to 0 for same as tempo, 1 for skipped one beat
midBeatDev = norm(midBeatGaps)/sqrt(length(midBeatGaps)); % take the RMS of the deviation from the tempo for mid beats
monoRMS = norm(datamono)/sqrt(length(datamono)); % overall RMS of audio
dynamicRange = ((max(datamono) - min(datamono)) / monoRMS); % the ratio difference between the highest peak and the RMS value
stereoRMS = 0 / monoRMS; % scale the stereo diff RMS relative to mono RMS
lowRMS = norm(datalow)/sqrt(length(datalow)) / monoRMS; % relative RMS of low freq's
lowmidRMS = norm(datalowmid)/sqrt(length(datalowmid)) / monoRMS; % relative RMS of low mid freq's
midRMS = norm(datamid)/sqrt(length(datamid)) / monoRMS; % relative RMS of mid freq's
highRMS = norm(datahigh)/sqrt(length(datahigh)) / monoRMS; % relative RMS of high freq's
attackWindowLength = round(Fs / 20); % sample about 20 times per second
for i = 1:(length(datamono) / attackWindowLength)-1
% get peak value for within each quarter of a second
 fastpeaks(i) = max(abs(datamono((i * attackWindowLength):((i + 1) * attackWindowLength - 1))));
end
fastPeakStrength = norm(diff(fastpeaks)) / sqrt(length(fastpeaks) - 1) / monoRMS; % RMS of the fast peak slopes, scaled to the overall sound level
attackWindowLength = round(Fs / 3); % sample about 3 times per second
for i = 1:(length(datamono) / attackWindowLength)-1
% get peak value for within each quarter of a second
 slowpeaks(i) = max(abs(datamono((i * attackWindowLength):((i + 1) * attackWindowLength - 1))));
end
slowPeakStrength = norm(diff(slowpeaks)) / sqrt(length(slowpeaks) - 1) / monoRMS;
