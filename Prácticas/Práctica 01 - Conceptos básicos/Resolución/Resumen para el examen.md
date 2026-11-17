* Parte 1
    * Proceso de arranque
        * UEFI
    * Conceptos generales gnu/linux

## Proceso de arranque

### BIOS

* La BIOS (*Basic Input/Output System*) es *firmware* que se almacena en un *chip* directamente soldado en la placa madre. Contiene la información necesaria para arrancar una computadora, con su última acción siendo leer el MBC del MBR, que comienza la carga del SO.

### MBR

* Está en el cilindro 0, cabeza 0, sector 1 de un disco duro.
* Ocupa 512 bytes
    * 446 bytes son el MBC (*master boot code*). Tiene instrucciones simples para leer la tabla de particiones.
    * 64 bytes es la tabla de particiones. La información de cada partición ocupa 16 bytes.
    * Los 2 bytes restantes se usan para firmarlo.

### Tabla de particiones del MBR

* Al ocupar 64 bytes, y cada partición ocupar 16 bytes, solo puede tener información de 4 particiones.
* De esas 4 particiones se pueden tener:
    * Las 4 primarias
    * 3 primarias y 1 extendida. La partición extendida no tiene un *file system*, sino que solo contiene información de sus particiones lógicas. Cada partición lógica tiene un puntero a la siguiente, funcionando como una lista enlazada. Para llegar a la primera, se accede desde la partición extendida 

### UEFI

* UEFI (*Unified Extensible Firmware Interface*) realiza las mismas tareas que la BIOS, y es su reemplazo en computadoras modernas. A diferencia de la BIOS, que era propiedad de IBM, UEFI es un estándar abierto de la industria (es de UEFI Forum, que no tiene fines de lucro). En vez de ejecutar ciegamente los primeros 512 bytes del disco, tiene en su placa madre un puntero a la tabla de particiones GPT. De aquí sabe a dónde ir para llegar a la partición especial ESP, que es un file system FAT32, que UEFI puede leer. En dicha partición, busca el archivo `.efi` de arranque y lo ejecuta.

### Tabla de particiones GPT

* Las siglas GPT significan *GUID Partition Table* y son el reemplazo de la tabla de particiones del MBR, eliminando la limitación de 4 particiones primarias. De cada partición se almacena el nombre y las coordenadas de inicio y fin.

### Proceso de arranque en system V

1. Se empieza a ejecutar el código del BIOS.
2. El BIOS ejecuta el POST.
3. El BIOS lee el sector de arranque (MBR).
4. Se carga el gestor de arranque (MBC). *Acá se puede cargar GRUB*
5. El bootloader carga el kernel y el initrd (initial ram disk).
6. Se monta el initrd como sistema de archivos raíz y se inicializan componentes esenciales (por ejemplo, el scheduler).
7. El Kernel ejecuta el proceso init y se desmonta el initrd.
8. Se lee el `/etc/inittab`. En este archivo están las reglas, acciones y niveles de ejecución (runlevels) en el formato `id:runlevels:acción:proceso`
9. Se ejecutan los scripts apuntados por el runlevel 1.
10. El final del runlevel 1 le indica que vaya al runlevel por defecto.
11. Se ejecutan los scripts apuntados por el runlevel por defecto.
12. El sistema está listo para ser usado

## Directorios

### Directorios base

* `/home` son los archivos personales del usuario.
* `/dev` son los dispositivos conectados.
* `/var` son archivos que cambian con frecuencia. En `/var/log` se guardan los *logs* de los programas.
* `/etc` son las configuraciones de las bases de datos.
* `/bin` son archivos binarios y ejecutables.
* `/sbin` se usa para almacenar programas esenciales del sistema, que usará el administrador del mismo.
* `/usr` son subdirectorios con archivos de programas y configuración del sistema. 
* `/boot` son los archivos necesarios para el arranque de la máquina.
* `/root` es el directorio home del superusuario root.
* `/tmp` contiene archivos no persistentes que generan los programas.
* `/proc` contiene ficheros que hacen referencia a procesos que corren en el sistema, y le permiten obtener información acerca de qué programas y procesos están corriendo en un momento dado.
* `/lib` contiene código de librerías que utilizan muchos programas.

### Subdirectorios importantes

* `**/etc/passwd**`: Es la base de datos de usuarios del sistema. Contiene una línea por cada usuario con información estructurada, como el nombre de usuario, identificadores (UID y grupo primario GID), información personal, la ruta del directorio personal (*home*) y el intérprete de comandos asignado (como `/bin/bash`), el cual se define al final de la respectiva línea. Comandos como `useradd` (al crear usuarios) o `usermod` (al modificar el grupo primario o el directorio home) alteran este archivo.

* **`/etc/group`**: Almacena la información de los grupos existentes en el sistema. Este archivo se modifica, por ejemplo, cuando se utiliza el comando `usermod -G` para asignarle grupos adicionales a un usuario.

* **`/etc/shadow`**: Contiene las contraseñas de los usuarios de forma encriptada, así como la información sobre la vigencia y caducidad de las mismas. Este archivo se modifica cada vez que se asigna o cambia una contraseña utilizando el comando `passwd`


## Comandos

### Generales

| **Nombre** | **Significado en inglés** | **Comportamiento** |
| --- | --- | --- |
| cd | *change directory* | Sirve para entrar a un directorio. Ej: `cd documents` |
| mkdir | *make directory* | Crea un directorio nuevo. Ej: `mkdir carpeta_a_crear` |
| rmdir | *remove directory* | Elimina un directorio. Ej: `rmdir carpeta_a_borrar` |
| ln | *link* | Crea un enlace a un directorio o archivo (como un acceso directo) en la carpeta donde estás ubicado. Ej: `ln -s [archivo_original] [nombre_del_enlace]`. En este caso, -s indica que es un enlace simbólico (si se borra o mueve el archivo, deja de funcionar) |
| tail | *tail* | Muestra las últimas líneas de un archivo de texto. Ej: `tail -n 20 archivo.txt` -n 20 hace que muestre 20 líneas |
| locate | *locate* | Busca en una base de datos interna un archivo Ej: `locate nombre archivo`. **Parámetros**:  -i ignora mayúsculas y minúsculas, -n 5 limita el número de resultados a 5. |
| ls | *list* | Muestra una lista de todos los archivos y directorios de mi ubicación. Parámetros: -l incluye permisos, el dueño, el tamaño y la fecha, -a incluye los ocultos que empiezan con (.), -lh muestra el tamaño en unidades legibles |
| pwd | *print working directory* | Muestra la ruta absoluta del directorio actual. **Parámetros:** -P ignora enlaces simbólicos (los que crea `ln`), -L tiene en cuenta enlaces simbólicos. |
| cp | *copy* | Copia un archivo con otro nombre en el mismo lugar, o con el mismo nombre en otro lugar. Ej: `cp archivo.txt nuevo_nombre.txt` o `cp archivo.txt /nueva/ubicacion/`. **Parámetros:** -i pregunta antes de sobreescribir, -v muestra el paso a paso. |
| mv | *move* | Sirve para mover o renombrar archivos y directorios. Ejemplo para mover: `mv archivo.txt /home/usuario/documentos/`. Ejemplo para renombrar: `mv viejo.txt nuevo.txt` |
| find | *find* | Sirve para buscar un archivo por distintos criterios (nombre, tamaño, tipo, fecha, etc). **Ejemplo:** `find . -size 54k` busca archivos de 54 kilobytes. |

### Manejo de usuarios y grupos

| **Nombre** | **Significado en inglés** | **Funcionalidad** | **Parámetros** |
|-------------------|-------------------------|--------------------------|-------------------|
| **useradd**            | User Add                      | Comando de bajo nivel para crear un nuevo usuario. Por defecto, solo crea la entrada en `/etc/passwd` sin configurar carpeta home, contraseña ni shell (depende de la configuración de la distribución).         | `-m` (crea el directorio home) `-s /bin/bash` (define la shell) `-g grupo` (define grupo principal)                       |
| **adduser**            | Add User                      | Interfaz de alto nivel y amigable para `useradd` (muy común en Debian/Ubuntu). Es interactivo: te pregunta paso a paso la contraseña, nombre real y crea automáticamente el directorio home y los archivos base. | `--system` (crea un usuario de sistema sin home ni shell interactiva)                                                     |
| **usermod**            | User Modify                   | Modifica las propiedades de una cuenta de usuario ya existente (cambia su home, su shell, su nombre de login, o sus grupos).                                                                                     | `-aG grupo` (agrega el usuario a un grupo suplementario sin borrar los anteriores) `-d /nueva/ruta` (cambia el home)      |
| **userdel**            | User Delete                   | Elimina la cuenta de un usuario del sistema (borra su entrada de `/etc/passwd` y `/etc/shadow`).                                                                                                                 | `-r` (elimina también el directorio personal `/home/usuario` y su buzón de correo)                                        |
| **su**                 | Substitute User / Switch User | Permite cambiar la identidad del usuario actual en la terminal por la de otro usuario (requiere conocer la contraseña del usuario de destino). Si se usa sin argumentos, asume que quieres ser `root`.           | `-` o `-l` (simula un login completo, cargando las variables de entorno y el path del nuevo usuario)                      |
| **groupadd**           | Group Add                     | Crea un nuevo grupo lógico en el sistema (agrega una entrada en el archivo `/etc/group`).                                                                                                                        | `-g GID` (fuerza la asignación de un ID de grupo numérico específico en lugar de uno automático)                          |
| **who**                | Who is logged in              | Muestra una lista de los usuarios que están actualmente conectados al sistema, indicando desde qué terminal (tty/pts) y la hora de conexión.                                                                     | `-a` (muestra toda la información disponible) `-b` (muestra la hora del último reinicio)                                  |
| **groupdel**           | Group Delete                  | Elimina un grupo existente del sistema. (Nota: No puedes eliminar el grupo principal de un usuario si ese usuario todavía existe).                                                                               | -                                                               |
| **passwd**             | Password                      | Permite cambiar la contraseña de un usuario (actualiza el hash en `/etc/shadow`). Un usuario normal solo puede cambiar la suya propia; el root puede cambiar la de cualquiera.                                   | `-l` (bloquea la cuenta) `-u` (desbloquea la cuenta) `-e` (fuerza al usuario a cambiar su contraseña en el próximo login) |

### Random

| **Comando**  | **Ruta**             | **Descripción**                                                                                      | **Parámetros**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ------------ | -------------------- | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **man**      | `/usr/bin/man`       | Muestra la documentación oficial o página de manual de cualquier otro comando del sistema.           | **--whatis** **-k \[palabra clave]**: Busca comandos que tengan la palabra clave en su descripción.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| **shutdown** | `/usr/sbin/shutdown` | Se utiliza para apagar, reiniciar o programar el apagado del sistema de forma segura.                | **-h / --halt**: Apaga el equipo deteniendo todos los procesos. **-P / --poweroff**: Apaga el equipo y corta la energía (por defecto). **-r / --reboot**: Reinicia el sistema. **-c / --cancel**: Cancela un apagado/reinicio programado. **-k / --kmsg**: Envía advertencia a usuarios sin apagar.                                                                                                                                                                                                                                                                                                                 |
| **reboot**   | `/usr/sbin/reboot`   | Se utiliza para reiniciar el SO.                                                                     | **-f / --force**: Fuerza el reinicio inmediato sin contactar a init/systemd. **-p / --poweroff**: Apaga el equipo por completo. **-w / --wtmp-only**: Solo registra la acción en /var/log/wtmp sin reiniciar. **-d / --no-wtmp**: Reinicia sin registrar en /var/log/wtmp. **--halt**: Detiene el sistema (suspensión/halt).                                                                                                                                                                                                                                                                                        |
| **halt**     | `/usr/sbin/halt`     | Apaga el equipo de forma inmediata, rompiendo el flujo normal del sistema y deteniendo la CPU.       | **-p / --poweroff**: Apaga el equipo y corta la corriente. **--reboot**: Reinicia el sistema. **-f / --force**: Fuerza la parada inmediata sin contactar a systemd. **-w / --wtmp-only**: Solo registra el evento en /var/log/wtmp. **-d / --no-wtmp**: Apaga sin registrar en /var/log/wtmp. **--no-wall**: Apaga sin enviar advertencia a los usuarios.                                                                                                                                                                                                                                                           |
| **uname**    | `/usr/bin/uname`     | Muestra información detallada del sistema operativo y del kernel.                                    | **-a / --all**: Toda la información en orden fijo. **-s / --kernel-name**: Nombre del núcleo. **-n / --nodename**: Nombre de host/red. **-r / --kernel-release**: Versión/subtipo del kernel. **-v / --kernel-version**: Fecha y detalles de compilación. **-m / --machine**: Arquitectura del hardware. **-p / --processor**: Tipo de procesador. **-i / --hardware-platform**: Plataforma de hardware. **-o / --operating-system**: Nombre del SO.                                                                                                                                                                |
| **dmesg**    | `/usr/bin/dmesg`     | Examina y controla el búfer de anillos del kernel. Muestra mensajes del núcleo (arranque, hardware). | **-T / --ctime**: Marcas de tiempo legibles. **-C / --clear**: Limpia el búfer por completo. **-c / --read-clear**: Muestra el contenido y luego lo limpia. **-w / --follow**: Muestra nuevos mensajes en tiempo real. **-L / --color**: Organiza la salida con colores. **-l / --level**: Filtra por criticidad (emerg, alert, crit, err, etc.). **-f / --facility**: Filtra por componente (kern, user, daemon, etc.). **-n / --console-level**: Configura el nivel enviado a la consola. **-s / --buffer-size**: Define el tamaño del búfer. **-H / --human**: Salida amigable con colores, paginación y tiempo. |
| **lspci**    | `/usr/bin/lspci`     | Muestra información sobre todos los periféricos conectados (gráficas, red, sonido, discos).          | **-v, -vv, -vvv**: Aumentan progresivamente el nivel de detalle de la información.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| **at**       | `/usr/bin/at`        | Programa la ejecución de tareas una sola vez en un momento determinado.                              | **-c**: Muestra el contenido de un trabajo antes de ejecutarse. **-f**: Lee comandos desde un archivo. **-m**: Envía un correo al usuario al finalizar la tarea. **-q**: Especifica una letra de cola (a-z) para agrupar trabajos.                                                                                                                                                                                                                                                                                                                                                                                  |
| **head**     | `/usr/bin/head`      | Muestra las primeras líneas de un archivo de texto.                                                  | **-n / --lines=\[-]NUM**: Muestra primeras NUM líneas. Con \[-], excluye últimas NUM. **-c / --bytes=\[-]NUM**: Muestra primeros NUM bytes. Con \[-], excluye últimos NUM. **-q / --quiet / --silent**: Oculta encabezados con el nombre del archivo.                                                                                                                                                                                                                                                                                                                                                               |
| **tail**     | `/usr/bin/tail`      | Muestra las últimas líneas o partes de un archivo de texto.                                          | **-n / --lines=\[+]NUM**: Muestra últimas NUM líneas. Con \[+], muestra desde la línea NUM. **-c / --bytes=\[+]NUM**: Muestra últimos NUM bytes. Con \[+], muestra desde el byte NUM. **-f / --follow**: Monitorea el archivo en tiempo real. **-F**: Igual a -f, pero con seguimiento reforzado (retry). **-q / --quiet / --silent**: Oculta cabeceras con nombres de archivos.                                                                                                                                                                                                                                    |
### Permisos

| **Nombre** | **Significado en inglés** | **Funcionalidad** | **Parámetros (Ejemplos comunes)** |
| :--- | :--- | :--- | :--- |
| **chmod** | Change Mode | Modifica los permisos de acceso (lectura `r`, escritura `w`, ejecución `x`) de un archivo o directorio. Puede usarse mediante notación octal (números) o simbólica (letras). | `-R` (recursivo: aplica los cambios a todos los archivos y subdirectorios dentro de una carpeta) `+x` (notación simbólica: añade permiso de ejecución) `755` (notación octal: rwx para el dueño, rx para grupo y otros) |
| **chown** | Change Owner | Cambia el usuario propietario (dueño) de un archivo o directorio. También permite cambiar simultáneamente el grupo propietario. | `-R` (recursivo: aplica el cambio de dueño a todo el contenido de una carpeta) `usuario:grupo` (cambia el dueño y el grupo al mismo tiempo, ej: `chown isocso:informatica archivo.txt`) |
| **chgrp** | Change Group | Cambia exclusivamente el grupo propietario de un archivo o directorio. | `-R` (recursivo: cambia el grupo de todo el contenido de una carpeta) |

### Del sistema

| **Nombre** | **Significado en inglés** | **Funcionalidad** | **Parámetros** |
|-------------------|-------------------------|--------------------------|-------------------|
| **mount**              | Mount                     | "Montar" un sistema de archivos. Le indica al Kernel que tome un dispositivo de bloque físico (como `/dev/sdb1` o un pendrive) y lo conecte lógicamente al árbol del sistema de archivos en una carpeta específica (punto de montaje). Si se ejecuta sin parámetros, lista todo lo que está montado actualmente. | `-t ext4` (especifica el tipo de sistema de archivos) `-o ro` (lo monta en modo Read-Only, solo lectura)                                      |
| **umount**             | Unmount                   | "Desmontar". Desconecta de forma segura un sistema de archivos del árbol de directorios, asegurando que todos los datos en caché (páginas sucias) se vuelquen físicamente al disco antes de cortar el acceso.                                                                                                    | `-f` (fuerza el desmontaje, útil si un disco de red se desconectó) `-l` (*lazy*: desconecta lógicamente ahora, limpia después)                |
| **du**                 | Disk Usage                | Mide el espacio en disco que está consumiendo un archivo o directorio específico. Es ideal para buscar qué carpetas (por ejemplo, dentro de tu `home`) te están llenando el disco duro.                                                                                                                          | `-s` (summary: muestra solo el total de la carpeta, sin detallar cada archivo dentro) `-h` (human-readable: muestra el tamaño en KB, MB o GB) |
| **df**                 | Disk Free                 | Muestra la cantidad de espacio libre y usado de todos los sistemas de archivos (particiones) que están montados en el sistema en ese momento, en lugar de carpetas individuales.                                                                                                                                 | `-h` (human-readable: Muestra megas/gigas en lugar de bloques de 1K) `-i` (muestra el uso de inodos en lugar de bloques de datos)             |
| **fdisk**              | Format Disk / Fixed Disk  | Es una herramienta interactiva para manipular la tabla de particiones de un disco físico (crear, borrar o cambiar el tipo de particiones). Históricamente se usa para el estándar MBR (para GPT suele usarse `gdisk` o `parted`).                                                                                | `-l` (lista todas las tablas de particiones de todos los discos conectados a la PC sin modificarlas)                                          |
| **mkfs**               | Make File System          | Formatea una partición. Toma una partición física en blanco creada por `fdisk` (ej. `/dev/sdb1`) y le inyecta la estructura lógica de un sistema de archivos (bloques, superbloque, tabla de inodos) para que el SO pueda guardar archivos en ella.                                                              | `-t ext4 /dev/sdb1` (crea un sistema ext4 en sdb1). *Suele usarse con sus variantes directas como `mkfs.ext4` o `mkfs.vfat`*.                 |
| **write**              | Write                     | (Nota: Este comando es de comunicación, no de discos). Permite enviar un mensaje de texto en tiempo real desde tu terminal hacia la terminal de otro usuario que esté logueado en el mismo sistema.                                                                                                              | `write usuario_destino` (abre un canal interactivo para escribir el mensaje). Termina con `Ctrl+D`.                                           |
| **losetup**            | Loop Setup                | Asocia un archivo de imagen normal (ej. un `.iso` o un `.img` lleno de ceros) a un dispositivo "loop" lógico (ej. `/dev/loop0`). Esto permite que el kernel trate a ese archivo ordinario como si fuera un disco duro físico real para poder formatearlo o montarlo.                                             | `-f` (encuentra automáticamente el primer dispositivo loop libre y lo asocia al archivo indicado)                                             |
| **stat**               | Status                    | Muestra el estado detallado y completo de un inodo. Imprime metadatos precisos sobre un archivo: su tamaño exacto en bytes, su número de inodo, sus permisos (en octal y texto), y las tres marcas de tiempo (Access, Modify, Change).                                                                           | `-c %a` (muestra únicamente los permisos en formato octal, útil para scripts)                                                                 |

### Empaquetar

| **Nombre** | **Significado en inglés** | **Funcionalidad** | **Parámetros** |
|-------------------|-------------------------|--------------------------|-------------------|
| **tar**                | Tape Archive                    | Agrupa (empaqueta) múltiples archivos y directorios en un solo archivo unificado (conocido como *tarball*). Originalmente diseñado para respaldos en cintas. Por sí solo no reduce el peso, solo agrupa. | `-c` (crea un empaquetado), `-x` (extrae), `-f` (indica el nombre del archivo), `-z` (comprime con gzip en el mismo paso, ej. `tar -czf`).                        |
| **grep**               | Global Regular Expression Print | Filtra texto. Busca un patrón de caracteres o expresión regular dentro de uno o varios archivos, e imprime en la terminal únicamente las líneas que contienen coincidencias.                             | `-i` (ignora mayúsculas y minúsculas), `-v` (invierte la búsqueda, muestra las líneas que NO coinciden), `-r` (busca recursivamente dentro de carpetas).          |
| **gzip**               | GNU zip                         | Comprime archivos individuales mediante el algoritmo DEFLATE para ahorrar espacio en disco. Por defecto, reemplaza el archivo original por uno nuevo con la extensión `.gz`.                             | `-d` (descomprime, logrando lo mismo que el comando `gunzip`), `-k` (keep: conserva el archivo original intacto sin borrarlo), `-9` (máximo nivel de compresión). |
| **zgrep**              | Compressed grep                 | Permite ejecutar el motor de búsqueda de `grep` directamente en el interior de archivos comprimidos (`.gz`). Lo hace en la memoria RAM, evitando que tengas que descomprimir el archivo en el disco.     | Acepta exactamente los mismos parámetros que grep (ej. `zgrep -i "error" log.gz`).                                                                                |
| **wc**                 | Word Count                      | Analiza un archivo de texto (o el flujo de datos de otro comando) y cuenta la cantidad exacta de saltos de línea, palabras y bytes/caracteres que contiene.                                              | `-l` (imprime exclusivamente la cantidad de líneas), `-w` (cuenta solo palabras), `-c` (cuenta la cantidad de bytes).                                             |

### Procesos

| **Comando** | **Ruta**                        | **Descripción**                                                                                                                                       | **Parámetros**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ----------- | ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **kill**    | `/bin/kill` (o `/usr/bin/kill`) | Envía una señal a un proceso específico utilizando su Identificador de Proceso (PID). Por defecto, envía SIGTERM (15) para un cierre ordenado.        | **-l / --list**: Lista los nombres y números de todas las señales soportadas por el sistema. **-s / --signal \[señal]**: Especifica qué señal enviar al proceso (por número o nombre). **-9 / -SIGKILL**: Señal extrema que fuerza la destrucción inmediata del proceso a nivel de Kernel. El proceso no puede bloquearla ni ignorarla. **-15 / -SIGTERM**: Solicita que el proceso termine de manera segura y libere sus recursos (señal predeterminada).                                                                                                                                                                                                                            |
| **killall** | `/usr/bin/killall`              | Envía una señal a todos los procesos que estén ejecutando un comando o nombre específico (ej. `killall firefox`), evitando tener que buscar sus PIDs. | **-i / --interactive**: Solicita confirmación manual antes de enviarle la señal a cada proceso coincidente. **-I / --ignore-case**: Ignora la diferencia entre mayúsculas y minúsculas al buscar el nombre del proceso. **-u / --user \[usuario]**: Afecta únicamente a los procesos con el nombre indicado que pertenezcan al usuario especificado. **-s / --signal \[señal]**: Envía una señal específica en lugar de la predeterminada SIGTERM. **-v / --verbose**: Imprime en pantalla un mensaje confirmando el envío de la señal a cada proceso. **-e / --exact**: Fuerza una coincidencia exacta del nombre, útil para procesos con nombres muy largos (más de 15 caracteres). |
