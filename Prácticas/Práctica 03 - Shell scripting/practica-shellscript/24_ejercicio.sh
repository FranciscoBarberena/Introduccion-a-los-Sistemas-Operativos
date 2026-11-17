if [ $# -gt 1 ]; then
	echo "Cantidad de parámetros erronea"
        exit 1
fi
usuarios=()
for line in $(cat /etc/group); do
	group=$(echo $line | cut -d: -f 1)
	if [ "$group" = "users" ]; then
		listaUsuarios=$(echo $line | cut -d: -f 4 | tr ',' ' ')
		for usuario in $listaUsuarios; do
			ultPos="${#usuarios[*]}" 
			usuarios[ultPos]=$usuario
		done
	fi
done
if [ $# -eq 0 ]; then
	exit 0
fi
tamanio="${#usuarios[*]}"
if [ "$1" = '-l' ]; then
	echo "$tamanio"
elif [ "$(expr substr "$1" 1 2)" = '-b' ]; then
	n=$(echo $1 | cut -d" " -f 2)
	if [ $n -lt $tamanio ]; then
		echo "La posicion $n del arreglo es ${usuarios[${n}]}"
	else
		echo "La posicion $n del arreglo no existe"
		exit 1
	fi
elif [ "$1" = '-i' ]; then
	for user in "${usuarios[@]}"; do
		echo $user
	done
else
	echo "Parametro debe ser -b n, -l o -i"
	exit 2
fi
exit 0
