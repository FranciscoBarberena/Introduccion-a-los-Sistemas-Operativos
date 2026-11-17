if [ $# -ne 0 ]; then
	exit 1
fi

destino="$HOME/bin"
if [ ! -d $destino ]; then
	mkdir $destino
	echo "Se ha creado el directorio $destino"
fi
cantidadMovidos=0
for file in *; do
	if [ ! -f "$file" ] || [ ! -x "$file" ]; then
		continue
	fi
	mv $file $destino
	echo "$(basename $file) se ha movido"
	let cantidadMovidos++
done
echo "Se han movido $cantidadMovidos archivos"
exit 0
