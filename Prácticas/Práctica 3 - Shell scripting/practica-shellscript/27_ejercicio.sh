if [ $# -ne 1 ]; then
	exit 1
fi
directorio="$1"
if [ ! -d "$directorio" ]; then
	exit 4
fi
cantidadEscritura=0
cantidadLectura=0
for file in "$directorio"/*; do
	if [ ! -f "$file" ]; then
		continue
	fi
	if [ -r "$file" ]; then
		cantidadLectura=$(expr $cantidadLectura + 1)
	fi
	if [ -w "$file" ]; then
		cantidadEscritura=$(expr $cantidadEscritura + 1)
	fi
done
echo "Cantidad de archivos para los que el usuario tiene permiso de escritura: $cantidadEscritura"
echo "Cantidad de archivos para los que el usuario tiene permiso de lectura: $cantidadLectura"
exit 0

