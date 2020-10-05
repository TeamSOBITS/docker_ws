#!/bin/bash
cd ~/docker_ws/container/rc2020jp_sim_final_ros/

docker build \
    --tag sobits/rc2020jp_sim_final_ros \
    --network host \
    .
