if [ $# -ne 1 ]; then
	echo "Se debe pasar 1 parámetro"
	exit 1
fi
while true
do
	echo "Buscando logins de ${1}..."
	usuariosLogueados="$(who | cut -d" " -f 1)"
	for line in ${usuariosLogueados}
	do 
		if [[ "$line" = "${1}" ]]; then
			echo "Usuario $1 logueado en el sistema"
			break 2
		fi
	done
	sleep 10
done
exit 0
