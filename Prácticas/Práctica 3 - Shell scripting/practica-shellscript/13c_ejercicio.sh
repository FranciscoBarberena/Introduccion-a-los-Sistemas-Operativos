if [ $# -ne 1 ]; then
	echo "Cantidad erronea de parametros"
	exit 1
fi
if [ -f "$1" ]; then
	echo "El archivo existe"
elif [ -d "$1" ]; then
	echo "El directorio existe"
else
	echo "Creando directorio "$1""
	mkdir $1
fi
exit 0
