#!/bin/bash

DIR=$(pwd)
str=`echo ${DIR} | awk -F "/" '{ print $(NF - 3) }'`

docker build \
    --tag sobits/${str} \
    --network host \
    --build-arg GIT_PSW=${GIT_PSW} \
    .
