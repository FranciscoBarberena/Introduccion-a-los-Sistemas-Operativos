if [ $# -ne 0 ]; then
	echo "Se necesitan exactamente 0 parámetros"
	exit 1
fi

vector1=(1 80 65 35 2)
vector2=(5 98 3 41 8)
tamanio="${#vector1[*]}"
for ((i=0; i<tamanio; i++)); do
	echo "La suma de los elementos en la posicion $i de los vectores es $(expr ${vector1[i]} + ${vector2[i]})"
done
exit 0
