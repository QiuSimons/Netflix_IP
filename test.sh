#!/bin/bash
echo "$(cat /proc/cpuinfo | grep 'model name')"
runner_cpu1="$(cat /proc/cpuinfo | grep 'model name' | grep 'C CPU')"
runner_cpu2="$(cat /proc/cpuinfo | grep 'model name' | grep 'M CPU')"
if [[ "$runner_cpu1" != "" ]] && [[ "$runner_cpu2" != "" ]]; then
  echo "$(cat /proc/cpuinfo | grep 'model name')"
  exit 0
else
  echo "cpu performance not enough"
  exit 1
fi
