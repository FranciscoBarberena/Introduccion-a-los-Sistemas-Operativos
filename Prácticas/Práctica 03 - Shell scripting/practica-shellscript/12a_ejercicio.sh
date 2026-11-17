#!/bin/bash
echo "Ingrese el número A"
read a
echo "Ingrese el numero B"
read b
expr $a + $b
expr $a \* $b
expr $a - $b
expr $a / $b
if [ $a -gt $b ]
then
	echo "A es mas grande: $a"
elif [ $b -gt $a ]
then
	echo "B es mas grande: $b"
else
	echo "Los numeros son iguales y valen $a"
fi
exit 0
