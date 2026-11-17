verArchivo(){
	if [ $# -ne 1 ]; then
		return 1
	fi
	local archivoABuscar=$1
	for file in "${arreglo[@]}"; do
		if [ "$(basename "$file")" = "$archivoABuscar" ]; then
			cat $file
			return 0
		fi
	done
	echo "Archivo no encontrado"
	return 5
}

cantidadArchivos(){
	if [ $# -ne 0 ]; then
		return 1
	fi
	echo "Cantidad de archivos .extensionSuperEpica: ${#arreglo[*]}"
	return 0
}

borrarArchivo(){
	if [ $# -ne 1 ]; then
		return 1
	fi
	local i=0
	local archivoABuscar=$1
	local encontre=0
        for file in "${arreglo[@]}"; do
		if [ "$(basename "$file")" = "$archivoABuscar" ]; then
                        encontre="1"
			local rutaCompleta=$file
			break
                fi
		let i++
        done
	if [ $encontre -ne 1 ]; then
		echo "Archivo no encontrado"
		return 10
	fi
	echo "Desea eliminar el archivo lógicamente? (SI/NO)"
	while true; do
		read opcion
		case $opcion in
			"SI")
				unset arreglo[i]
				break
				;;
			"NO")
				unset arreglo[i]
				rm "${rutaCompleta}"
				break
				;;
			*)
				echo "Ingrese SI o NO"
				;;
		esac
	done
	return 0
}



if [ $# -ne 0 ]; then
	echo "Se necesitan 0 parametros"
	exit 1
fi
arreglo=()
archivos=$(find /home -name "*.extensionSuperEpica")
for file in $archivos; do
	tamanio="${#arreglo[*]}"
	arreglo[tamanio]=$file
done
cantidadArchivos
borrarArchivo "pepe.extensionSuperEpica"
exit 0
