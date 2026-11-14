source ./30_ejercicio.sh

if [ $# -gt 1 ]; then
	exit 1
fi
if [ $# -eq 1 ]; then
	if [ $1 -eq 0 ] || [ $1 -gt 32767 ]; then
		exit 2
	fi
	valorMaximo=$(expr $1 + 1)
else
	valorMaximo=100
fi
initialize
while true; do
	numero=$(expr $RANDOM % $valorMaximo)
	add $numero
	if [ $? -ne 0 ]; then
		continue
	fi
	echo "Siguiente numero: $numero"
	echo "Si ganaste, escribí 'BINGO'. Presiona ENTER para seguir cantando"
	read bingo
	if [ "$bingo" = "BINGO" ]; then
		echo "GANASTE"
		break
	fi
done
echo "---- Numeros cantados ----"
print_sorted
exit 0
