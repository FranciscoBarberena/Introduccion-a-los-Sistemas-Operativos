if [ $# -ne 1 ]; then
	echo "Se necesita 1 parámetro"
	exit 1
fi
if [ $(echo "$1" | cut -c 1-1) != "." ]; then
	echo "La extensión debe empezar con un ."
	exit 2
fi
if [ $(echo "$1" | cut -d" " -f 1) != "$1" ]; then
	echo "La extensión no puede contener espacios"
	exit 3
fi
user=""
echo -n "USUARIO -- " > "test/reporte.txt" # Borrar contenido anterior
echo "CANTIDAD DE ARCHIVOS $1" >> "test/reporte.txt"
echo "------------" >> "test/reporte.txt"
while read -r line
do
	user="$(echo ${line} | cut -d: -f1)"
	echo -n "$user -- " >> "test/reporte.txt"
	homeDelUsuario="$(echo ${line} | cut -d: -f6)"
	if [ -d $homeDelUsuario ]; then
		echo "Escribiendo datos de usuario ${user}... (esto puede tardar unos segundos)"	
		amountOfFiles=$(find $homeDelUsuario -name "*${1}" 2>/dev/null | wc -l) # Redireccion de salida de error para ocultar errores de permisos
		echo $amountOfFiles >> "test/reporte.txt"
	else
		echo "No tiene directorio home" >> "test/reporte.txt"
	fi
done < /etc/passwd
exit 0
