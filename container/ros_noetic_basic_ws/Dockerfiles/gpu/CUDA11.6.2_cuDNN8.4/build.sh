#!/bin/bash

DIR=$(pwd)
str=`echo ${DIR} | awk -F "/" '{ print $(NF - 3) }'`

docker build \
    --tag sobits/${str} \
    --network host \
    .
