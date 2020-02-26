#!/bin/sh -l

fail=0

run1="rdmd -unittest -main prog1.d"
run2="rdmd -unittest -main prog2.d"
run3="rdmd -unittest -main prog3.d" 

$run1
status1=$?
echo $status1

if [ $status1 -ne 0 ]
then
	echo "Failure: prog1.d"
	fail=1
	# exit 1
fi

$run2
status2=$?
echo $status2

if [ $status2 -ne 0 ]
then
	echo "Failure: prog2.d"
	fail=1
	# exit 1
fi

$run3
status3=$?
echo $status3

if [ $status3 -ne 0 ]
then
	echo "Failure: prog3.d"
	fail=1
	# exit 1
fi

if [ $fail -eq 1 ]
then 
	exit 1
else
	exit 0
fi
