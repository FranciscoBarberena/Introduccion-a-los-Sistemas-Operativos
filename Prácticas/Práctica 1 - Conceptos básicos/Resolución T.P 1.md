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
* Puede usar distintos interpretes de comandos o *Shells*. En particular, Debian usa *Bash*, pero esto es personalizable en Linux.
* Permite el manejo de usuarios y permisos.
* Trata a todo como un archivo. Los dispositivos se tratan como archivos en el directorio `/dev`.
* Sus directorios tienen distintos propósitos:
    * `/home` son los archivos personales del usuario.
    * `/dev` son los dispositivos conectados.
    * `/var` son archivos que cambian con frecuencia. En `/var/log` se guardan los *logs* de los programas.
    * `/etc` son las configuraciones de las bases de datos.
    * `/bin` son archivos binarios y ejecutables.
    * `/usr`
    * `/boot` son los archivos necesarios para el arranque de la máquina.

### Inciso B

* Caracterísitcas de *Windows* en comparación con Linux:
    * *Windows* es software propietario. Es decir que: no se distribuye su código fuente y no provee las 4 libertades de Linux. 
    * No es *case-sensitive*.
    * Ambos son multiusuario, multitarea y multiprocesador. También puede administrar usuarios y permisos.
    * No es altamente portable. *Windows* solo se puede instalar en computadoras de uso general.
    * *Windows* también permite instalar otros interpretes de comandos. Aunque por defecto usa PowerShell* y cmd.
    * No trata a todo como un archivo. Los dispositivos se administran en un menú separado.
    * Sus directorios son de uso general. 

### Incisco C
* GNU es un sistema operativo similar a Unix, pero con la distinción de que es totalmente libre. Por esto está licenciado bajo la GPL.

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


## Punto 10

### Inciso A
* En GNU/Linux, los archu

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
* **Nano**: es un editor de textro que usa una interfaz por consola. Es similar al editor Pico, y fue creado para que haya una alternativa libre a dicho editor de Unix (fue una historia parecida a GNU con el propio Unix). El desarrollador principal del proyecto lo abandonó en 2016 por problemas con la *Free Software Foundation*.
* **Mccedit**: es un editor de texto que viene incluido en el programa de manejo de archivos conocido como *Midnight Commander*. Se puede ejecutar como un programa aparte (fuera de *Midnight Commander*) y tiene características como: resaltado de sintaxis en muchos lenguajes, macros, indentación automática, uso de *mouse*, portapapeles, entre otras.
    *
### Inciso C

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
        * `ls | more` mostaría página por página todos los archivos y directorios de la carpeta en la que estás parado.

### Inciso D

* El comando file sirve para identificar el tipo de archivo con el que se trata. Un ejemplo de uso sería: 
```
file prueba.exe
```
* Internamente, hace 3 pasos:
    * Realiza una *system call* llamada *stat()*, lo que le permite leer algunos metadatos de un archivo. Entre ellos, está la información de si el archivo es un archivo regular, un dispositivo o un directorio. Si es un directorio, lo reporta.
    * Lee los "números mágicos" del archivo. Esto suelen ser los primeros bytes del mismo, y son una firma digital. El comando luego los compara con una base de datos interna, que asocia a cada *magic number* con un tipo de archivo.
    * Si no tiene ningún número mágico reconocible, lee los primeros bloques (generalmente unos pocos kb), buscando palabras clave (ej: *program* para Pascal) o una codificación específica como ASCII o UTF-8 para determinar el tipo de archivo.

### Inciso E


| Comando | Significado | Comportamiento |
| --- | --- | --- |
| cd | *change directory* | Sirve para entrar a un directorio dentro de la terminal. Ej: **cd documents** |
| mkdir | *make directory* | Cell 2.3 |
| rmdir | *remove directory* | Cell 3.3 |
| ln | Cell 4.2 | Cell 4.3 |
| tail | Cell 5.2 | Cell 5.3 |
| locate | Cell 6.2 | Cell 6.3 |
| ls | Cell 7.2 | Cell 7.3 |
| pwd | Cell 8.2 | Cell 8.3 |
| cp | Cell 9.2 | Cell 9.3 |
| mv | Cell 9.2 | Cell 9.3 |
| find | Cell 9.2 | Cell 9.3 |

