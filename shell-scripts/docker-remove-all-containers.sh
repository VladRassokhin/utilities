#!/bin/bash
docker ps -a | awk '{print $1}' | tail -n +2 | xargs -n 1 docker rm
