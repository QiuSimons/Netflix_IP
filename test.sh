  echo "$(cat /proc/cpuinfo | grep 'model name')"
  runner_cpu="$(cat /proc/cpuinfo | grep 'model name')"
  cpu1="C CPU"
  cpu2="M CPU"
  result1=$(echo $runner_cpu | grep "${cpu1}")
  result2=$(echo $runner_cpu | grep "${cpu2}")
  if [[ "$result1"+"$result2" != "" ]]
  then
      echo "$(cat /proc/cpuinfo | grep 'model name')"
  else
      echo "cpu performance not enough"
      exit 1
  fi
