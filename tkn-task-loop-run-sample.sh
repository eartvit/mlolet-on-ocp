#!/bin/bash

tkn task start launch-loop-auto-lt-pipeline-task --timeout 180m --param RUNS=3 --param randReqMode=True --param randPayload=True \
    --param connectionsLowerBound=5 --param connectionsUpperBound=25 \
    --param durationLowerBound=1800 --param durationUpperBound=3600 \
    --param createSpikes=True --param spikeConnections=15 --param randomSpikeDuration=False --param randomSpikeRepeat=False \
    --param spikeDurationLoBound=30 --param spikeDurationUpBound=31 \
    --param spikeRepetitionLoBound=180 --param spikeRepetitionUpBound=181
