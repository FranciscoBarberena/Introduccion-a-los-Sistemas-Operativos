#!/bin/bash
for ((i=1; i < 101; i++))
do
    echo -n $i
    echo " -> $(expr "$i" \* "$i")"
done
exit 0
