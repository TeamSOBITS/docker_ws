#!/bin/bash

DIR=$(pwd)
str=`echo ${DIR} | awk -F "/" '{ print $(NF - 2) }'`

docker build \
    --tag sobits/${str} \
    --network host \
    .