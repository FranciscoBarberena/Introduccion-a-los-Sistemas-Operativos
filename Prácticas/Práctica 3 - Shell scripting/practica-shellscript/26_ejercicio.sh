inicializar(){
	if [ $# -ne 0 ]; then
                return 1
	fi
	array=()
	return 0
}

agregar_elem(){
	if [ $# -ne 1 ]; then
                return 1
	fi
	local tamanio="${#array[*]}"
	array[$tamanio]=$1
	return 0
}

eliminar_elem(){
	if [ $# -ne 1 ]; then
		return 1
	fi
	local tamanio="${#array[*]}"
	if [ "$1" -ge "$tamanio" ]; then
		return 2
	fi
	unset array[$1]
	return 0
}

longitud(){
	if [ $# -ne 0 ]; then
                return 1
	fi
	echo "${#array[*]}"
	return 0
}

imprimir(){
	if [ $# -ne 0 ]; then
                return 1
        fi
	for elem in "${array[@]}"; do
		echo "$elem"
	done
	return 0
}

inicializar_Con_Valores(){
	if [ $# -ne 2 ]; then
                return 1
        fi
	inicializar
	for ((i=0; i<"$1"; i++)); do
		array[i]="$2"
	done
	return 0
}

