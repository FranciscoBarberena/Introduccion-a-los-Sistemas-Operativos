if [ $# -ne 0 ] ; then
	echo "Este script no requiere de parámetros"
	exit 1
fi
PS3="Ingrese la opción a ejecutar: "
echo "MENU DE COMANDOS"
select comando in $(ls | grep ".sh" | cut -d. -f 1) Salir;
do
	case $comando in
		"Salir")
			echo "Saliendo del menú"
			exit 0
			;;
		*)
	        	./$comando.sh
			;;
	esac
done
exit 0
