if [ $# -eq 0 ]; then
	echo "Se necesita al menos un parámetro"
	exit 1
fi
i=1
inexistentes=0
for parametro in $@; do
	if [ "$(expr ${i} % 2)" -eq 1 ]; then
		if [ -d "$parametro" ]; then
			echo "$parametro es un directorio"
		elif [ -f "$parametro" ]; then
			echo "$parametro es un archivo"
		fi
	fi
	if [ ! -e "$parametro" ]; then
		inexistentes=$(expr $inexistentes + 1)
	fi
	i=$(expr $i + 1)
done
echo "Hubo $inexistentes parametros que no eran archivos ni directorios"
exit 0
