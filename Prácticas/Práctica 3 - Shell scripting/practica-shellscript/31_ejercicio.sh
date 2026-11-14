if [ $# -eq 0 ]; then
	echo "Se necesita al menos un parametro"
	exit 1
fi
for parameter in "$@"; do
	homeDirectory=$(grep "^${parameter}:" /etc/passwd | cut -d: -f 6)
	if [ "$homeDirectory" != "" ] && [ -d $homeDirectory ]; then
		echo "Creando directrio para $parameter..."
		mkdir -p "$homeDirectory"/directorio_iso/{2025,2026}/{01,02,03,04,05,06,07,08,09,10,11,12}
		touch "$homeDirectory"/directorio_iso/{2025,2026}/{01,02,03,04,05,06,07,08,09,10,11,12}/archivo.txt
		echo "Directorio creado exitosamente para $parameter!"
	else
		echo "El usuario $parameter no existe o no tiene directorio home"
	fi
done
