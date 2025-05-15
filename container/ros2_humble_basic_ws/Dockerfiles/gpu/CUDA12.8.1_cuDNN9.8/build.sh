#!/bin/bash

DIR=$(pwd)
str=`echo ${DIR} | awk -F "/" '{ print $(NF - 3) }'`

if [[ ${GIT_PSW} == "" ]]
then
    echo "You did not introduce your GIT Token"
    echo "Please use write the following command with the proper GIT token"
    echo "$ export GIT_PSW=YOUR_GIT_TOKEN"
    exit
else
    curl -s -H "Authorization: token ${GIT_PSW}" https://api.github.com/user/issues -o token_output.txt
    file_content=$( cat "token_output.txt" )
    check='Bad credentials'
    rm token_output.txt

    if [[ "$file_content" == *"$check"* ]]
    then
        echo "The introduced GIT Token is not valid"
        echo "Please use a new one"
        echo "$ export GIT_PSW=YOUR_GIT_TOKEN"

        exit
    else
        echo "The introduced GIT Token was valid"
    fi
fi

docker build \
    --tag sobits/${str} \
    --network host \
    --build-arg GIT_PSW=${GIT_PSW} \
    --build-arg LOCAL_UID=$(id -u ${USER}) \
    --build-arg LOCAL_GID=$(id -g ${USER}) \
    .