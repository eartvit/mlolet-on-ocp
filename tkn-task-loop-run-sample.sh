#!/bin/bash

tkn task start launch-loop-auto-lt-pipeline-task --param RUNS=2 --param randReqMode=True --param randPayload=True \
    --param connectionsLowerBound=10 --param connectionsUpperBound=50 \
    --param durationLowerBound=180 --param durationUpperBound=360 \
    --param createSpikes=True --param spikeConnections=15 --param randomSpikeDuration=False --param randomSpikeRepeat=False \
    --param spikeDurationLoBound=15 --param spikeDurationUpBound=16 \
    --param spikeRepetitionLoBound=15 --param spikeRepetitionUpBound=16
