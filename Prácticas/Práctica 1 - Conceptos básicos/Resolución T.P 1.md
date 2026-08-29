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
* DUDA (???)

### Inciso E
* Sí, Linux puede leer las particiones que usan *file systems* propios de Windows como FAT o NTFS. Sin emabrgo, lo opuesto no es verdad, ya que *Windows* no puede leer particiones ext4.

### Inciso F
* Existen particionadores destructivos y no destructivos.
    * **Particionadores destructivos:** solo permiten crear o eliminar particiones. Ej: **Fdisk**
    * **Particionadores no destructivos:** permiten crear, eliminar, fusionar, dividir o editar particiones. Ej: **Gparted**, administrador de discos de *Windows*.

## Punto 10

### Inciso A
* DUDA a que se refiere

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
 





