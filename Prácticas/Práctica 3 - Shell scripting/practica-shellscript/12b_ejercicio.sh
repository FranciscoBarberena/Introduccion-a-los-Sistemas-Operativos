#!/bin/bash
if [[ $# -ne 2 ]]; then
    echo "Se deben pasar dos números como parámetro"
    exit 1
fi
a=$1
b=$2
if [ $b -eq 0 ]; then
	echo "El divisor no puede ser 0"
	exit 2
fi
expr $a + $b
expr $a \* $b
expr $a - $b
expr $a / $b

if [ "$a" -gt "$b" ]
then
	echo "A es mas grande: $a"
elif [ "$b" -gt "$a" ]
then
	echo "B es mas grande: $b"
else
	echo "Los numeros son iguales y valen $a"
fi
exit 0