if [ $# -ne 3 ]; then
	echo "Cantidad erronea de parametros"
	exit 1
fi

if [[ ! -d $1 ]]; then
	echo "$1 No es un directorio"
	exit 2
fi
if [ "$2" != "-a" ] && [ "$2" != "-b" ]; then
	echo "Segundo parametro debe ser -a o -b"
	exit 3
fi
for file in $(ls "$1")
do
	if [ -f "${1}/${file}" ]; then
		case $2 in
			"-b")
				mv "${1}/${file}" "${1}/${3}${file}"
                       		 ;;
			"-a")
				mv "${1}/${file}" "${1}/${file}${3}"
				;;
		esac	
	fi
done
