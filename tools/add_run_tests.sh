#!/bin/bash
if [[ $# -eq 0 ]]
then
	echo "No arguments supplied"
	exit 1
fi

f=$(cat "$1")
echo "input file $1"
echo "input tests $3"
echo "output file $2"
tests=

if [[ $# -eq 3 ]]
then
	for i in $(echo $3| sed "s/,/ /g")
	do
    		# call your procedure/other scripts here below
   		tests="$tests<runTest>$i</runTest>"
	done
fi
echo "Results to $2"
final=${f/runTests/$tests} 
echo ${final/apexTestList/$3} > "$2"
