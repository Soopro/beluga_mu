#!/bin/bash
echo '---- A peon start working ----'

# primary task
for arg in $@
do
  if [ $arg = "release" ]
    then
      echo '---- release ----'
      harp compile src release
  fi
done

echo '---- The peon finish his work ----'