if [[ $# -ne 3 ]]; then
    echo "Se deben pasar tres números como parámetro"
    exit 1
fi
case $3 in
"+")
	echo "$(expr $1 + $2)"
	;;
"-")
	echo "$(expr $1 - $2)"
	;;
"x")
	echo "$(expr $1 \* $2)"
	;;
"/")
	if [ "$2" -eq 0 ]; then
    	echo "Error: El divisor no puede ser 0"
		exit 2
    else
    	echo "$($1 / $2)"
    fi
    ;;
*)
	echo "Operacion no soportada"
	exit 3
esac
exit 0
