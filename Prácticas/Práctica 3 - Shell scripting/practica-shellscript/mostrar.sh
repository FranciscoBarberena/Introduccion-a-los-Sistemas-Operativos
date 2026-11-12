#!/bin/bash
# Comentarios acerca de lo que hace el script
# Siempre comento mis scripts, si no lo hago hoy,
# mañana ya no me acuerdo de lo que quise hacer
echo "Introduzca su nombre y apellido:"
read nombre apellido
echo "Fecha y hora actual:"
date
echo "Su apellido y nombre es:"
echo "$apellido $nombre"
echo "Su usuario es: `whoami`"
echo "Su directorio actual es:"
pwd
echo "Tu directorio personal es: $(grep "^$(whoami):" /etc/passwd | cut -d ':' -f 6)"
echo "Escribe el nombre del punto de montaje de la particion de la  que quieres saber su espacio libre:"
read particion
df -h "$particion"
