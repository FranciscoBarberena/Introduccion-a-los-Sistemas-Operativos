select opcion in "Listar" "QuienEsta" "DondeEstoy" "Salir"
do
	case "$opcion" in
		"Listar")
			echo "$(ls -l)"
			;;
		"QuienEsta")
			echo "$(who)"
			;;
		"DondeEstoy")
			echo "$(pwd)"
			;;
		"Salir")
			echo "Saliendo"
			break
			;;
		*)
			echo "Ingresa un numero del 1 al 4"
			;;
	esac
done
