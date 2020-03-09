#!/bin/bash
f=$(cat "$1")

echo "input file $1"
echo "input tests $2"
echo "output file $3"

for i in $(echo $2| sed "s/,/ /g")
do
    # call your procedure/other scripts here below
    tests="$tests<runTest>$i</runTest>"
    
done

echo "Results to $3"
echo ${f/runTests/$tests} > $3
