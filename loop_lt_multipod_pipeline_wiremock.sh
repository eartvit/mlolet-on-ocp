#!/bin/bash

NOW=`date +%s`
ASYNCRESP="True"

ERR_COUNT=0

for (( i=0; i<$RUNS; ++i)); do

    ASYNC=$(($RANDOM%2))
    if [[ $ASYNC -eq 1 ]]
    then
      ASYNCRESP="True"
    else
      ASYNCRESP="False"
    fi
    
    TIMEOUT=$(($RANDOM % 5 + 1))

    LEVELS_DEEP=$(($RANDOM % 4))

    echo -e 'Running cycle '$(($i+1))' out of '$RUNS' using async resp mode: '${ASYNCRESP}', levelsDeep: '${LEVELS_DEEP}' and timeout: '${TIMEOUT}

    # with showlog parameter the tkn command will remain active in the shell until the pipeline executes/completes
    # without the showlog param, the tkn command will finish and then we need to monitor in a loop when the execution finished, as below
    `tkn pipeline start auto-lt-wiremock-metrics --param reqTimeout=${TIMEOUT} --param traceActive=False \
            --param threadSleepMS=50 --param randReqMode=True --param randPayload=True \
            --param payloadSizes='50,150,255' --param ltReqPayloadSizeFactor=10 --param ltReqFirstSizeOnly=True \
            --param connectionsLowerBound=1 --param connectionsUpperBound=50 \
            --param durationLowerBound=10 --param durationUpperBound=900 \
            --param URL=http://wiremock-metrics-1.demo.svc.cluster.local:8080/mock \
            --param levelsDeep=$LEVELS_DEEP --param deepURLPattern='http://wiremock-metrics-{n}.demo.svc.cluster.local:8080/mock' \
            --param scaleLowerBound=1 --param scaleUpperBound=10 --param wiremockPort=8080 \
            --param prometheusPort=9090 --param delayLowerBoundsMS=100 --param delayUpperBoundsMS=300 \
            --param asyncResp=${ASYNCRESP} --param asyncRespThreadsLowerBound=10 --param asyncRespThreadsUpperBound=25 \
            --param jacptThreadsLowerBound=100 --param jacptThreadsUpperBound=200 \
            --param jacptQSizeLowerBound=1000  --param jacptQSizeUpperBound=2000 \
            --param cpuLimit=1 --param cpuRequest=500m --param memoryLimit=2Gi --param memoryRequest=1Gi >> tkn_lt_pipeline_$NOW.log 2>&1`

    PIPELINERUN=`tkn pipelineruns list --no-headers | sed -n 1p | awk '{print $1}'`
    STATUS=`tkn pipelineruns list --no-headers | sed -n 1p | awk '{print $NF}'`
    while [[ $STATUS != 'Succeeded' ]]
    do
      echo -e 'Pipeline run '$PIPELINERUN' is '$STATUS'...'
      if [[ $STATUS == 'Failed' ]]; then
        echo -e 'Cleaning up resources of failed pipelinerun...'
        oc delete deployment,services -l app=wiremock-mlasp
        ERR_COUNT = $((ERR_COUNT+1))
        break;
      fi
      STATUS=`tkn pipelineruns list --no-headers | sed -n 1p | awk '{print $NF}'`
      sleep 5
    done
    if [[ $STATUS != 'Failed' ]]; then
      echo -e 'Pipeline run '$PIPELINERUN' is '$STATUS'.'
    fi
    echo -e 'Waiting 60s before the next round starts.\n'
    sleep 60
done

if [[ $ERR_COUNT -gt 0 ]]; then
  echo -e 'Errors encountered: $ERR_COUNT'
fi


