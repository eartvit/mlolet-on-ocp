#!/bin/bash

tkn task start launch-loop-auto-lt-pipeline-task --timeout 0 --param RUNS=10 --param randReqMode=True --param randPayload=True \
    --param connectionsLowerBound=5 --param connectionsUpperBound=25 \
    --param durationLowerBound=360 --param durationUpperBound=1800 \
    --param createSpikes=True --param spikeConnections=15 --param randomSpikeDuration=True --param randomSpikeRepeat=True \
    --param spikeDurationLoBound=15 --param spikeDurationUpBound=60 \
    --param spikeRepetitionLoBound=60 --param spikeRepetitionUpBound=181
