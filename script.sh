#!/bin/sh -l

# echo "Hello $1"
# time=$(date)
# echo ::set-output name=time::$time

rdmd -unittest -main prog1.d
rdmd -unittest -main prog2.d 