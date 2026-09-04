# Práctica 1

## Punto 1

### Inciso A
* Es un SO con características de Unix, pero es libre. Se distribuye bajo la licencia GPL, y su código fuente es público.
* Al ser software libre, Linux permite las siguientes libertades a sus usuarios: 
    * Libertad de usar el programa con cualquier propósito.
    * Libertad de estudiar su funcionamiento.
    * Libertad para distribuir sus copias.
    * Libertad para mejorar los programas.
* Es *case-sensitive*.
* Es multiusuario
* Es multitarea y multiprocesador. Permite ejecutar varios programas al mismo tiempo, y es compatible con procesadores *multi-core*.
* Es altamente portable, por lo que se puede adaptar a distintos tipos de dispositivos.
* Puede usar distintos intérpretes de comandos o *Shells*. En particular, Debian usa *Bash*, pero esto es personalizable en Linux.
* Permite el manejo de usuarios y permisos.
* Trata todo como un archivo. Los dispositivos se tratan como archivos en el directorio `/dev`.
* Sus directorios tienen distintos propósitos asignados.


### Inciso B

* Características de *Windows* en comparación con Linux:
    * *Windows* es software propietario. Es decir que: no se distribuye su código fuente y no provee las 4 libertades de Linux. 
    * No es *case-sensitive*.
    * Ambos son multiusuario, multitarea y multiprocesador. También puede administrar usuarios y permisos.
    * No es altamente portable. *Windows* solo se puede instalar en computadoras de uso general.
    * *Windows* también permite instalar otros intérpretes de comandos. Aunque por defecto usa PowerShell* y cmd.
    * No trata a todo como un archivo. Los dispositivos se administran en un menú separado.
    * Sus directorios son de uso general. 

### Inciso C
* GNU es un sistema operativo similar a Unix, pero con la distinción de que es totalmente libre. Por eso está licenciado bajo la GPL.

### Inciso D

* En 1983, el sistema GNU fue iniciado por Richard Stallman con el fin de crear un Unix libre.
* Con él se creó la licencia GPL.
* En 1985, R. Stallman creó la FSF (*Free Software Foundation*) para financiar el proyecto GNU.
* En 1990, GNU ya contaba con un editor de texto (*Emacs*), un compilador (*GCC*) y varias bibliotecas.
* Desde 1991, Linus Torvalds estaba trabajando en un kernel que sea software libre.
* En 1992, Torvalds y Stallman fusionaron ambos proyectos, y allí nació GNU/Linux. El kernel es, básicamente, el núcleo de un SO.

### Inciso E

* La multitarea es el concepto en el que, administrando correctamente la memoria y el CPU, varios procesos pueden ejecutarse aparentemente de manera simultánea, aún cuando el CPU tiene un único *core*. Esto es mejorado ampliamente con procesadores multi-core.
* El tipo de multitarea que usa Linux se llama multitarea apropiativa (*preemptive multitasking*). El SO aquí tiene la capacidad de interrumpir un proceso para darle tiempo de CPU a otro.

### Inciso F

* POSIX (*Portable Operating System Interface*) es una familia de estándares creados por el IEEE. Su objetivo es lograr la compatibilidad entre distintos SO. 
* Permite que el código fuente de un software desarrollado para un SO que respeta el estándar POSIX, sea compilable en cualquier otro sistema POSIX.
* Muchos sistemas operativos actuales respetan este estándar, aunque algunos no en su totalidad. macOS lo respeta en su totalidad, mientras que Linux lo respeta parcialmente. En cambio, *Windows* no sigue a este estándar, aunque existen tecnologías que sirven para aumentar la compatibilidad de *Windows* con sistemas POSIX. 



## Punto 2

### Inciso A
* Una distribución Linux o distribución GNU/Linux es un conjunto de aplicaciones reunidas que permiten brindar mejoras para instalar fácilmente un sistema operativo basado en GNU/Linux. Son "sabores" de GNU/Linux que, en general, se diferencian entre sí por las herramientas para configuración y sistemas de administración de paquetes de software para instalar. Las distribuciones son libres de usar cualquier tipo de *software*, ya sea libre o propietario. Algunas **distros** son:
    * **Ubuntu:** Es la distribución más popular, y tiene como objetivo facilitar la experiencia del usuario. Está basada en Debian.
    * **Mint:** Tiene una interfaz similar a *Windows*, para facilitar el cambio de dicho SO a Linux. Está basada en Ubuntu.
    * **Fedora:** Es la continuación del proyecto *Red Hat*. Su objetivo es estar a la vanguardia de los programas de *software* libre y de código abierto.
    * **Damn Small Linux:** Como su nombre lo indica, está diseñado para ser liviano y poder ejecutarse en *hardware* desactualizado.

### Inciso B

* Como se mencionó, cada distribución tiene un foco particular (rendimiento en máquinas desactualizadas, facilidad de uso, etc) el kernel de Linux. 

### Inciso C

* Debian es la segunda distribución más popular de Linux. Tiene un énfasis en proveer estabilidad y *support* a largo plazo.
* Objetivo
    * Crear un sistema operativo libre, disponible para todo el mundo.
* Cronología
    * Debian comenzó a ser desarrollado por Ian Murdock en 1993.
    * Se consolidó como una de las distribuciones más populares a principios de los 2000.
    * En 2004, el comienzo de Ubuntu generó controversia en cuanto a la compatibilidad con sistemas derivados de Debian.
    * El sistema ha sufrido controversias en relación al uso de servicios no libres, pero continúa siendo una de las distribuciones más usadas hoy en día.

## Punto 3
### Inciso A
* Los componentes fundamentales de GNU/Linux son: el kernel, el *shell* y el *file system*.

### Inciso B
* La estructura básica de GNU/Linux consiste en:
    * **Kernel**: es el núcleo del SO. Se encarga de administrar el uso del CPU y la memoria. De modo general, se encarga de que el *software* y el *hardware* puedan trabajar juntos.
    * **Las aplicaciones base:** incluyen herramientas básicas como compiladores y librerías, así como programas que usa el usuario.
    * **Shell**: es el intérprete de comandos. Dichos comandos pueden ser literales, en un shell con interfaz de consola (CLI) o pueden ser acciones del usuario en una interfaz gráfica (GUI).

## Punto 4
### Inciso A
* Funciones principales del kernel:
    * Ejecutar programas y gestionar dispositivos.
    * Coordinar el *software* y el *hardware*
    * Administra la memoria, el CPU y la E/S.
    * Es un núcleo monolítico e híbrido
        * Es monolítico porque es un solo proceso. Si se cuelga algo en el kernel, se cuelga todo.
        * Es híbrido porque se le pueden cargar y descargar *drivers*, que le agregan funcionalidades distintas.
        * Todo el código del kernel se ejecuta en modo privilegiado.

### Inciso B

* Sí, es posible tener más de un kernel de GNU/Linux en la misma máquina. De la misma manera que el dual booting se puede usar para tener Linux y Windows en la misma PC, también podría usarse para tener Linux y una versión más vieja de Linux. En general, cuando el kernel se actualiza, no borra los archivos del kernel viejo, sino que ambos coexisten en el directorio `/boot/`.

### Inciso C
* Se encuentran en el directorio `/boot/`, y comienzan con la secuencia "vmlinuz-". Se puede ver todos las versiones de kernel que hay en una máquina Linux usando este comando en la terminal: `ls -lh /boot/vmlinuz-*`

## Punto 5

### Inciso A
* El *shell*, consola o intérprete de comandos, es un programa que actúa como interfaz para comunicar al usuario con el sistema operativo. En una interfaz CLI, el usuario escribe un comando, el *shell* lo interpreta, y se lo entrega al SO para su ejecución. 

### Inciso B
* Algunos *shells* de GNU/Linux son:
    * **Bourne Shell:** Ubicado en `/bin/sh`, está disponible en todas las versiones de UNIX y es lo suficientemente básico para que funcione en todas las plataformas.
    * **Bourne Again Shell o BASH:** Ubicado en `/bin/bash`, es uno de los *shells* más potentes y avanzados. Tiene licencia GNU. Algunas de sus funciones son:
        * Historial de comandos ejecutados, conservado entre sesiones.
        * Auto completado de nombres de comandos presionando TAB.
    * **Z Shell o Zsh:** Ubicado en `/bin/zsh`, está diseñado para su uso interactivo. Tiene incorporadas características de *Bash*, y es el *default* en macOS
### Inciso C

* Los comandos propios de un *shell* se encuentran en su directorio particular. Por ejemplo, los comandos propios de *Bash* se encuentran en `/bin/bash`. En cambio, los comandos externos pueden estar en `/bin`, `/usr/bin`, `/usr/local/bin` o cualquier otra ubicación si se la agrega a la variable PATH. Se pueden ver todas las ubicaciones de la variable PATH con el siguiente comando:
```
echo $PATH
```

### Inciso D
* El *shell* no forma parte del kernel de GNU/Linux porque, justamente, sirve para que el usuario pueda enviarle órdenes al mismo sin interactuar directamente con él. Si el *shell* fuese parte del kernel, esto sería imposible.

### Inciso E
* Sí, cada usuario puede usar un intérprete de comandos diferente según su elección. En Linux, se puede ver el *shell* asignado a cada usuario en el archivo `/etc/passwd `. Para buscar el de un usuario, se puede usar el siguiente comando:
```
grep "nombre_usuario" /etc/passwd | cut -d: -f7
``` 

## Punto 6
### Inciso A
* Un sistema de archivos o *file system* es la manera en la que, en una computadora, se administran y organizan los archivos. Esto incluye:
    * **Métodos de acceso:** cómo se acceden los datos contenidos en el archivo.
    * **Manejo de archivos:** cómo actúan los mecanismos para almacenar, referenciar, compartir y proteger los archivos.
    * **Manejo de la memoria secundaria:** Cómo se administra el espacio para los archivos en memoria secundaria.
    * **Mecanismos de integridad:** con qué métodos se garantiza la incorruptibilidad del archivo.

### Inciso B
* El contenido de cada uno de los directorios principales de Linux lo determina el FHS (*Filesystem Hierarchy Standard*). Estos son:
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

### Inciso C
* Algunos sistemas de archivos soportados por GNU/Linux son: ext3, ext4, ReiserFS y XFS

## Punto 7
### Inciso A
* Una partición de disco es una región de almacenamiento secundario, que se crea con el fin de que dicha área pueda manejarse de manera independiente a las otras.
* Tipos de particiones:
    * **Partición primaria:** división cruda del disco (solo puede haber 4 por disco). Se almacena información de la misma en el MBR.
    * **Partición extendida o secundaria:** sirve para contener particiones lógicas en su interior. Solo puede existir una partición de este tipo por disco. No se define un tipo de *file system* directamente sobre ella. Es decir, no se guardan archivos en la partición extendida directamente, sino que dentro de la partición extendida, se crea una partición lógica. Es en esa partición lógica donde se guardan los archivos.
    * **Partición lógica:** ocupa la totalidad o parte de la partición extendida y se le define un tipo de *file system*. Las particiones de este tipo se conectan como una lista enlazada entre sí. 

### Inciso B
* IDE era la interfaz estándar para la identificación de HDDs hasta que fue reemplazada por SATA. Los nombres de sus discos y particiones eran así:
    * `/dev/hda`: configurado como Master en el 1er bus IDE
    * `/dev/hdb`: configurado como Slave en el 1er bus IDE
    * `/dev/hdc`: configurado como Master en el 2do bus IDE
    * `/dev/hdd`: configurado como Slave en el 2do bus IDE
    * Las particiones primarias se numeran del 1 al 4, con las lógicas usando los números del 5 en adelante.
* SATA es la interfaz estándar usada actualmente por usuarios comunes. En cambio, la forma evolucionada de SCSI es el estándar para servidores. Sin embargo, la nomenclatura de ambos es idéntica en Linux:
    * `/dev/sda` disco físico 1
    * `/dev/sdb` disco físico 2
    * `/dev/sdc` disco físico 3, etc...
    * Las particiones primarias se numeran del 1 al 4, con las lógicas usando los números del 5 en adelante. Solo las particiones primarias pueden marcarse como *booteables*.

### Inciso C
# DUDA: TÉCNICAMENTE PODRÍAS TENER SOLO LA PARTICIÓN / Y LISTO?? MARCANDOLA COMO BOOTEABLE, Y DEJANDO /home y /boot COMO CARPETAS DENTRO DE LA ÚNICA PARTICIÓN
* Se necesitan 3 particiones primarias. Una para el directorio raíz (`/`), una para el `/boot` y una que funcione como partición extendida, alojando las siguientes particiones lógicas:
    * `/home` para documentos personales.
    * Área de *swap* para mejorar rendimiento.
    * Podrían crearse más a gusto del usuario
* Todas las particiones utilizan el file system ext4, excepto por el área de *swap* que utiliza el tipo *swap*.
* Las identificaciones y puntos de montaje serían:
    * Disco físico: sda
        * Partición `/`: 
            * ID: sda1
            * Punto de montaje: `/`
        * Partición `/boot`: 
            * ID: sda2
            * Punto de montaje: `/boot/`
        * Partición extendida (que aloja a las lógicas): 
            * ID: sda3
            * Punto de montaje: No tiene. Aunque técnicamente contiene a todas sus subparticiones lógicas, no las procesa usando un formato como ext4 o similar. Por lo tanto, no se puede acceder a sus subparticiones a través de ella, y no se encuentra en ninguna carpeta.
            * Partición *SWAP*:
                * ID: sda5
                * Punto de montaje: No tiene, porque sus archivos no tienen organización alguna. Simplemente, cuando se satura la RAM, los archivos se dejan allí, pero no tienen un formato de *file system* como ext4.
            * Partición `/home`: sda6
                * ID: sda6
                * Punto de montaje: `/home`
### Inciso D
* DUDA distintos esquemas de particionamiento para distintos usos

### Inciso E
* Sí, Linux puede leer las particiones que usan *file systems* propios de Windows como FAT o NTFS. Sin emabrgo, lo opuesto no es verdad, ya que *Windows* no puede leer particiones ext4.

### Inciso F
* Existen particionadores destructivos y no destructivos.
    * **Particionadores destructivos:** solo permiten crear o eliminar particiones. Ej: **Fdisk**
    * **Particionadores no destructivos:** permiten crear, eliminar, fusionar, dividir o editar particiones. Ej: **Gparted**, administrador de discos de *Windows*.

## Punto 8

### Inciso A
* La BIOS (*Basic Input/Output System*) es *firmware* que se almacena en un *chip* directamente soldado en la placa madre. Contiene la información necesaria para arrancar una computadora, con su última acción siendo leer el MBC del MBR, que comienza la carga del SO.

### Inciso B
* UEFI (*Unified Extensible Firmware Interface*) realiza las mismas tareas que la BIOS, y es su reemplazo en computadoras modernas. A diferencia de la BIOS, que era propietario de IBM, UEFI es un estándar abierto de la industria. En vez de ejecutar ciegamente los primeros 512 bytes del disco, tiene en su placa madre un puntero a la tabla de particiones GPT. De aquí sabe a dónde ir para llegar a la partición especial ESP, que es un file system FAT32, que UEFI puede leer. En dicha partición, busca el archivo `.efi` de arranque y lo ejecuta.

### Inciso C
* El MBR (*Master Boot Record*) son 512 bytes de un disco, que tienen información especial, y están siempre ubicados en el cilindro 0, cabeza 0,
sector 1. Los primeros 446 bytes tienen instrucciones rudimentarias para que arranque el sistema operativo. Luego tiene la tabla de particiones primarias, que ocupa 64 bytes. Finalmente, se firma con 2 bytes especiales. La limitación de tener solo 4 particiones primarias viene de que la información de cada partición ocupa 16 bytes, y la tabla de particiones tiene un tamaño de 64 bytes.

### Inciso D
* Las siglas GPT significan *GUID Partition Table* y son el reemplazo de la tabla de particiones del MBR, eliminando la limitación de 4 particiones primarias. De cada partición se almacena el nombre y las coordenadas de inicio y fin.

### Inciso E
* Una vez que la BIOS o UEFI terminó su ejecución, no se cargó el sistema operativo en sí. Lo que se cargó fue un gestor de arranque, que es un programa con más complejidad, con instrucciones para iniciar un SO. Con el estándar UEFI, se almacenan en una partición especial llamada ESP (*EFI System Partition*). En cambio, con el estándar BIOS, para que se inicialize el gestor de arranque, la información de su ejecución tiene que estar en el primer sector de la partición marcada como booteable. Algunos gestores de arranque son:
    * **GRUB:** es el estándar para Linux.
    * ***Windows Boot Manager:*** es el estándar en *Windows*.

### Inciso F
DUDA preguntar esto porque es importante 
* Con estándar BIOS:
    * Se prende la computadora.
    * Se ejecuta el código ubicado en el cilindro 0, cabeza 0, sector 1 del disco. Aquí está el MBR.
    * Primero se ejecuta el MBC, con instrucciones simples que leen la tabla de particiones.
    * Se lee la tabla de particiones, y se busca aquella con el flag de *booteable* activo.
    * Una vez que se llega a la partición *booteable*, se ejecuta el primer sector de la misma, que tiene los primeros pasos de ejecución para inicializar el gestor de arranque.
    * Una vez ejecutado el gestor de arranque, este perimte cargar el sistema operativo.
* Con estándar UEFI:
    * Se prende la computadora
    * En la placa madre del chip *UEFI*, se tiene almacenada la ubicación del archivo del gestor de arranque.
    * En el principio del disco, se lee la tabla de particiones GPT, para poder ubicar la partición con ID de UEFI (ESP).
        * **Nota:** En realidad, en el primer sector del disco sigue estando el viejo MBR, que se mantiene por cuestiones de retro-compatibilidad. Es en el siguiente sector a ese donde se almacena la tabla GPT.
    * En la partición ESP, se busca el archivo del gestor de arranque (la ubicación del mismo estaba almacenada en el chip UEFI, así que sabe donde buscarlo)
    * Se revisa que no se trate de un archivo malicioso.
    * Se ejecuta el gestor de arranque.
    * El gestor de arranque carga el SO.

### Inciso G
DUDA es lo mismo que cualquier otro SO (el arranque en linux)?

### Inciso H
* DUDA que pasos se ejecutan al apagar una maquina linux

### Inciso I
* Sí, es posible, ya que hay gestores de arranque como GRUB que muestran un menú al ejecutarse. En este menú se encuentran los disintos archivos de arranque de cada SO instalado en una PC. 


## Punto 9

### Inciso A
* DUDA a que se refiere como se identifica a un archivo en linux

### Inciso B

* **Vim**: es un editor de texto que se puede usar tanto por consola como con una interfaz gráfica (modo GUI). Tiene 7 modos, aunque en la cátedra se nombraron 3:
    * Modo *insert* (activado con la tecla I): es para editar contenido como en un editor moderno. 
    * Modo visual (activado con la tecla V): es para seleccionar áreas de texto. Se pueden correr comandos sobre las áreas seleccionadas.
    * Modo normal (activado con la tecla esc): es para comandos de editor. Es el modo por *default*.
    * Algunos de sus comandos son:
        * w: escribir cambios
        * q o q!: salir del editor
        * dd: cortar
        * y: copiar al portapapeles
        * p: pegar desde el portapapeles
        * u: deshacer
        * /frase: busca “frase” dentro del archivo
* **Nano**: es un editor de texto que usa una interfaz por consola. Es similar al editor Pico, y fue creado para que haya una alternativa libre a dicho editor de Unix (fue una historia parecida a GNU con el propio Unix). El desarrollador principal del proyecto lo abandonó en 2016 por problemas con la *Free Software Foundation*.
* **Mcedit**: es un editor de texto que viene incluido en el programa de manejo de archivos conocido como *Midnight Commander*. Se puede ejecutar como un programa aparte (fuera de *Midnight Commander*) y tiene características como: resaltado de sintaxis en muchos lenguajes, macros, indentación automática, uso de *mouse*, portapapeles, entre otras.

### Inciso C
* Se debe realizar esta serie de comandos y acciones, teniendo Vim instalado:
```
cd ~
```
```
vim prueba.exe
```
```
Entrar a modo *insert* apretando la tecla I
```
```
Escribir nombre y número de alumno, como si fuese un .txt normal (se puede usar el Enter para saltar de línea)
```
```
Apretar Esc para entrar a modo normal. Guardar el archivo con el siguiente comando:
```
```
:wq
```
* Para comprobar que se creó el archivo, ejecutar el siguiente comando:
```
ls -l prueba.exe
```


### Inciso D

* cat: su nombre viene de *concatenate*. Permite mostrar archivos de texto en la terminal con distintos formatos. Algunas de sus funciones son:
    * Ver un archivo: `cat archivo.txt` muestra todo el texto en la pantalla.
    * Numerar líneas: `cat -n archivo.txt` muestra el texto con números al lado de cada línea.
    * Unir archivos: `cat archivo1.txt archivo2.txt > nuevo.txt` junta dos archivos en uno nuevo.
    * Crear un archivo: `cat > archivo.txt` te deja escribir texto nuevo y guardarlo al pulsar Ctrl + D.
* more: sirve para ver el contenido de un archivo de texto largo pantalla por pantalla, para de esta manera no saturar la terminal. 
    * Sus controles son:
        * Barra espaciadora: Avanza una página completa.
        * Tecla Enter (Intro): Avanza una sola línea.
        * Tecla Q: Sale del comando y vuelve a la terminal
    * `more archivo.txt` sería el comando
    * Se puede usar para leer la salida de otros comandos de la siguiente manera:
        * `ls | more` mostraría página por página todos los archivos y directorios de la carpeta en la que estás parado.

### Inciso E

* El comando file sirve para identificar el tipo de archivo con el que se trata. Un ejemplo de uso sería: 
```
file prueba.exe
```
* Internamente, hace 3 pasos:
    * Realiza una *system call* llamada *stat()*, lo que le permite leer algunos metadatos de un archivo. Entre ellos, está la información de si el archivo es un archivo regular, un dispositivo o un directorio. Si es un directorio, lo reporta.
    * Lee los "números mágicos" del archivo. Estos suelen ser los primeros bytes del mismo, y son una firma digital. El comando luego los compara con una base de datos interna, que asocia a cada *magic number* con un tipo de archivo.
    * Si no tiene ningún número mágico reconocible, lee los primeros bloques (generalmente unos pocos kb), buscando palabras clave (ej: *program* para Pascal) o una codificación específica como ASCII o UTF-8 para determinar el tipo de archivo.

### Inciso F

* **Nota: se recomienda visualizar esta tabla en una pantalla ancha. Si aparece formateada de manera errónea, aquí hay un [link a la tabla en pdf](url).**

| Nombre del comando | Significado | Comportamiento |
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
| find | *find* | Sirve para buscar un archivo por distintos criterios (nombre, tamaño, tipo, fecha, etc). **Ejemplo:** `find . -size 54k` busca archivos de 54 kilobytes.|
 
## Punto 11

* man
    * Sirve para mostrar la documentación oficial o página de manual de cualquier otro comando del sistema. 
    * `/usr/bin/man`
    * Parámetros:
        * --whatis
        * -k [palabra clave]. Busca comandos que tengan la palabra clave en su descripción.
* shutdown
    * Se utiliza para apagar, reiniciar o programar el apagado del sistema de forma segura.
    * `/usr/sbin/shutdown`
    * Parámetros
    * -h / --halt: Apaga el equipo deteniendo todos los procesos.
    * -P / --poweroff: Apaga el equipo y corta la energía (acción por defecto).
    * -r / --reboot: Reinicia el sistema.
    * -c / --cancel: Cancela un apagado o reinicio programado.
    * -k / --kmsg: Envía el mensaje de advertencia a los usuarios pero no apaga el sistema.
* reboot
    * Se utiliza para reiniciar el SO.
    * `/usr/sbin/reboot`
    * Parámetros
        * -f (--force) Fuerza el reinicio inmediato. No contacta al gestor de inicio init ni a systemd. Puede causar pérdida de datos no guardados.
        * -p (--poweroff) Apaga el equipo por completo en lugar de reiniciarlo. Actúa como el comando poweroff.
        * -w (--wtmp-only) No reinicia el sistema. Solo registra la acción de reinicio en el archivo de historial /var/log/wtmp.
        * -d (--no-wtmp) Reinicia el sistema pero suprime la escritura del registro en el archivo /var/log/wtmp.
        * --halt Detiene el sistema (pasa a estado de suspensión/halt) en lugar de apagarlo o reiniciarlo.
* halt
    * Se utiliza para apagar el equipo de forma inmediata, rompiendo el flujo normal del sistema y deteniendo la CPU.
    * `/usr/sbin/halt`
    * Parámetros
        * -p / --poweroff: Apaga el equipo y corta la corriente eléctrica de la máquina.
        * --reboot: Reinicia el sistema en lugar de solo detenerlo (funciona igual que el comando reboot).
        * -f / --force: Fuerza la parada inmediata. No contacta con el gestor de servicios (systemd). Puede causar pérdida de datos si hay archivos abiertos.
        * -w / --wtmp-only: No apaga el sistema. Solo registra el evento de parada en el archivo de historial /var/log/wtmp.
        * -d / --no-wtmp: Apaga el sistema pero no registra el evento en el archivo /var/log/wtmp.
        * --no-wall: Apaga el equipo sin enviar el mensaje de advertencia a los usuarios conectados a la terminal.
* uname
    * Sirve para mostrar información detallada del sistema operativo y del kernel.
    * `/usr/bin/uname`
    * Parámetros
        * -a o --all: Muestra toda la información del sistema en orden fijo.
        * -s o --kernel-name: Muestra el nombre del núcleo (ej. Linux).
        * -n o --nodename: Muestra el nombre de host o red del equipo.
        * -r o --kernel-release: Muestra la versión o subtipo del kernel.
        * -v o --kernel-version: Muestra la fecha y detalles de compilación del kernel.
        * -m o --machine: Muestra la arquitectura del hardware de la máquina (ej. x86_64).
        * -p o --processor: Muestra el tipo de procesador.
        * -i o --hardware-platform: Muestra la plataforma de hardware.
        * -o o --operating-system: Muestra el nombre del sistema operativo (ej. GNU/Linux)
* dmesg
    * Se utiliza para examinar y controlar el búfer de anillos del kernel. Muestra los mensajes generados por el núcleo del sistema, especialmente durante el arranque y al conectar hardware.
    * `/usr/bin/dmesg`
    * Parámetros
        * -T (o --ctime): Muestra marcas de tiempo legibles por humanos (fecha y hora local) en lugar del tiempo en segundos desde el arranque.
        * -C (o --clear): Limpia por completo el búfer de mensajes del kernel.
        * -c (o --read-clear): Muestra el contenido actual del búfer y luego lo limpia.
        * -w (o --follow): Modo interactivo. Espera y muestra nuevos mensajes en tiempo real (ideal para ver qué pasa al conectar un USB).
        * -L (o --color): Organiza la salida usando colores para facilitar la lectura de advertencias y errores.
        * -l (o --level): Filtra la salida por niveles de criticidad (separados por comas).Niveles: emerg, alert, crit, err, warn, notice, info, debug.
        * -f (o --facility): Filtra por el componente que generó el mensaje.Componentes: kern, user, mail, daemon, auth, syslog, lpr, news.
        * -n (o --console-level): Configura el nivel de los mensajes que se enviarán directamente a la consola de texto.
        * -s (o --buffer-size): Define el tamaño del búfer utilizado para consultar al kernel (por defecto suele ser 16392 bytes).
        * -H (o --human): Activa una salida amigable: habilita paginación automática, colores y marcas de tiempo amigables
* lspci
    * Sirve para mostrar información sobre todos los periféricos conectados al sistema, como tarjetas gráficas, de red, de sonido y controladores de disco.
    * `/usr/bin/lspci`
    * -v, -vv y -vvv aumentan el nivel del detalle de la información.
* at
    * Sirve para programar la ejecución de tareas una sola vez en un momento determinado.
    * `/usr/bin/at`
    * Parámetros
        * -c: Muestra el contenido de un trabajo programado antes de que se ejecute.
        * -f: Lee los comandos desde un archivo en lugar de la entrada estándar.
        * -m: Envía un correo electrónico al usuario cuando la tarea finaliza, incluso si no hay salida en pantalla.
        * -q: Especifica una letra de cola diferente (de a a z) para agrupar los trabajos.
* head
    * Se utiliza para mostrar las primeras líneas de un archivo de texto.
    * /usr/bin/head
    * Parámetros
        * -n, --lines=[-]NUM: Muestra las primeras NUM líneas en lugar de las 10 predeterminadas. Si se usa con un signo menos (-n -NUM), imprime todo el archivo excepto las últimas NUM líneas.
        * -c, --bytes=[-]NUM: Muestra los primeros NUM bytes del archivo. Si se usa con un signo menos (-c -NUM), imprime todo excepto los últimos NUM bytes.
        * -q, --quiet, --silent: No muestra los encabezados con el nombre del archivo cuando se consultan varios archivos a la vez.
* tail
    * Sirve para mostrar las últimas líneas o partes de un archivo de texto.
    * `/usr/bin/tail`
    * Parámetros
        * -n, --lines=[+]NUM: Muestra las últimas NUM líneas en lugar de las 10 predeterminadas. Si se usa con signo más (+NUM), muestra el contenido a partir de la línea número NUM.
        * -c, --bytes=[+]NUM: Muestra los últimos NUM bytes del archivo. Con signo más (+NUM), muestra desde el byte indicado.
        * -f, --follow: Monitorea el archivo en tiempo real; muestra las nuevas líneas que se van agregando al final del archivo de forma continua.
        * -F: Similar a -f, pero realiza un seguimiento reforzado ("retry"), útil si el archivo se rota, se elimina y se vuelve a crear.
        * -q, --quiet, --silent: No imprime las cabeceras con los nombres de los archivos cuando se consultan múltiples archivos a la vez.

## Punto 12

### Inciso A
1. Se empieza a ejecutar el código del BIOS.
2. El BIOS ejecuta el POST.
3. El BIOS lee el sector de arranque (MBR).
4. Se carga el gestor de arranque (MBC).
5. El bootloader carga el kernel y el initrd ( initial ram disk).
6. Se monta el initrd como sistema de archivos raíz y se inicializan componentes esenciales (por ejemplo, el scheduler).
7. El Kernel ejecuta el proceso init y se desmonta el initrd.
8. Se lee el `/etc/inittab`.
9. Se ejecutan los scripts apuntados por el runlevel 1.
10. El final del runlevel 1 le indica que vaya al runlevel por defecto.
11. Se ejecutan los scripts apuntados por el runlevel por defecto.
12. El sistema está listo para ser usado.

### Inciso B
* El proceso **init** es el único que se considera que no tiene padre, por lo que no es ejecutado por otro proceso. Su función es cargar todos los subprocesos necesarios para el
correcto funcionamiento del Sistema Operativo. También es el encargado de montar los filesystems y de hacer disponible los demás dispositivos.

### Inciso C
* El *runlevel* es el nivel de ejecución en el que se encuentra el SO. Cada nivel limita la serie de servicios que se pueden ejecutar:

### Inciso D
* 0 → halt (parada o apagado).
* 1 → single-user mode (modo monousuario).
* 2 → multi-user without network support (multiusuario sin soporte de red).
* 3 → multi-user console mode (modo multiusuario en consola).
* 4 → N/A (no se utiliza).
* 5 → X11 (modo multiusuario con entorno gráfico basado en X.org).
* 6 → reboot (reinicio)

* Por defecto, Linux se inicia en runlevel 3 o runlevel 5, dependiendo de si la distribución utiliza una interfaz gráfica o no.
    * Esto se define en el archivo inittab. Particularmente, hay una directiva que es initdefault. El runlevel definido allí es en el que se va a iniciar el sistema. Por ejemplo: id:5:initdefault iniciaría en runlevel 5, con interfaz gráfica.

### Inciso E
* El archivo inittab sirve para dictarle a init qué debe hacer, qué programas debe arrancar y qué debe detener dependiendo del estado (runlevel) en el que se encuentre el sistema.
* La estructura de la información almacenada es: id:runlevels:acción:proceso
* Contiene las asociaciones de qué scripts deben realizarse al pasar a cada *runlevel*. El directorio de los enlaces a los scripts es /etc/rcX.d (donde X es el número de runlevel entre 0 y 6).

### Inciso F
* Para cambiar a runlevel Y, se tiene que ejecutar el comando init Y, con permisos de sudo. El cambio dura hasta que se reinicia la máquina, ya que no se modifica la directiva initdefault.

### Inciso G
* Los scripts rcX.d contienen enlaces a los scripts que se tienen que realizar al cambiar al runlevel X. 
* Los scripts en sí se almacenan en `/etc/init.d/`.
* Los enlaces en rcX.d tienen este patrón:
    * [S|K] `orden` `nombre`
    * S y K determinan si dicho script debe ejecutarse o detenerse respectivamente (start/kill).
    * El orden es un número de 2 dígitos que establece la prioridad del *script*. Esto determina el orden de ejecución de los mismos, lo que resuelve dependencias entre *scripts*.
    * El nombre es simplemente el nombre lógico que se le da al *script*.

## Punto 13
### Inciso A
* Systemd es un sistema que centraliza la administración de demonios (servicios) y librerías del sistema. Reemplaza a systemV, mejorando el paralelismo de arranque.
* Cambios de terminología comparado a systemV:
    * *Runlevel* ----> *target*
    * No utiliza `/etc/inittab`.

### Inciso B
* Una *Unit* en systemd es una unidad de trabajo. Pueden estar en estado *active* o *inactive* y tienen distintos tipos:
    * *Service*: controla un servicio particular.
    * *Socket*: encapsula IPC, un *socket* del sistema o *file system* FIFO.
    * *Target*: agrupa *units* o establece puntos de sincronización durante el arranque.
    * *Snapshot*: almacena el estado de un conjunto de unidades para que pueda ser restablecido más tarde.

### Inciso C
* El comando `systemctl` se utiliza para administrar y controlar los servicios y el estado del sistema en distribuciones de Linux que usan `systemd`. Reemplaza al comando *init*

### Inciso D




