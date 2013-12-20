function simTime = deduceSimTime(rawData)

timestampIndex = 3;

simTime = (rawData{size(rawData,1),timestampIndex} - rawData{1,timestampIndex})/1000;

