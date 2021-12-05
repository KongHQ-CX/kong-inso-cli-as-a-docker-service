#!/bin/bash
### wrapper-inso-service.sh
###   -d directory relative to current working folder
###   -f api-spec file to lint
###   -i docker image to call
###   -v verbose outputs the pretty format json result
### exit value is set to # of errors found.
###
### usage ./wrapper-inso-service.sh -v -d run/oas/ -f kong-demo-api-errors.yaml ; echo $?

LOCALDIR=$(pwd)
APISPEC=""
IMAGE="inso-cli:latest"
VERBOSE=0

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--dir) LOCALDIR="${LOCALDIR}/$2"; shift ;;
        -f|--file) APISPEC="$2"; shift ;;
        -i|--image) IMAGE="$2"; shift ;;
        -v|--verbose) VERBOSE=1 ;;
        *) echo "Unknown parameter passed: $1"; head $0 -n 10; exit 256 ;;
    esac
    shift
done

if [ "${APISPEC}" == "" ]; then
  echo "No specification file name passed";
  head $0 -n 10;
  exit 256
fi

DOCKERRESULT=`docker run --rm -ti -v "${LOCALDIR}:/workdir/" ${IMAGE} ${APISPEC} `
NUMERRORS=`echo ${DOCKERRESULT} | jq 'length'`

if [ "${NUMERRORS}" != "0" ]; then
   if [ "${VERBOSE}" == "1" ]; then
     echo "${DOCKERRESULT}" | jq -C ; #Color the output again, Remove JQ to be plain text
   fi
   exit "${NUMERRORS}"
fi
