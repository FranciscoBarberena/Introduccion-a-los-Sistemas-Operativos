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

