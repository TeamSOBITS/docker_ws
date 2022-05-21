#!/bin/bash

DIR=$(pwd)
str=`echo ${DIR} | awk -F "/" '{ print $(NF - 3) }'`

docker exec \
    -it \
    --user sobits \
    ${str} \
    /bin/bash