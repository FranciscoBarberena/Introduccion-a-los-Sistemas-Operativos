* Parte 1
    * Proceso de arranque
    * Conceptos generales gnu/linux
    * Comandos
    * Directorios importantes
* Procesos
    * Módulos de planificación (schedulers, dispatcher, loader)
    * Estados de un proceso
    * Creación de procesos (fork, execev,exit, wait)
* Memoria
    * MMU que chota es
    * Espacio de direcciones
    * Sistemas de administración de memoria (particiones fijas, particiones dinámicas, paginación, segmentación y segmentación paginada)

# Conceptos generales

## Componentes de SO

* Los principales componentes de un Sistema Operativo son: el kernel, el shell y las herramientas.

### Shell

* Es el intérprete de comandos. Dichos comandos pueden ser literales, en un shell con interfaz de consola (CLI) o pueden ser acciones del usuario en una interfaz gráfica (GUI)

### Kernel

* Se encuentra siempre en memoria principal.
* Se encarga de la administración de recursos de *hardware* (CPU, memoria, E/S).
* Administra la manera en la que se almacenan los archivos mediante el *file system*
* Detecta y responde a errores de *hardware*
    * Memoria, CPU, dispositivos externos.
* Detecta y responde a errores de *software*
    * Acceso indebido a memoria
    * Errores aritméticos

## Problemas que debe evitar el kernel

### Apropiación de la CPU por parte de un proceso

* Si un proceso X cualquiera intenta ejecutar el siguiente código:
```
while (true)
    do nothing
```
* El kernel debe asegurarse que dicho proceso no bloquee a otros procesos de usar la CPU.
* **Solución: interrupción de clock**
    * El *clock*, periódicamente, interrumpe a la CPU. Una vez interrumpido, el kernel toma el control de la CPU, lo que le permite ejecutar tanto su propio código, como desalojar al proceso (en el caso de que se esté usando un algoritmo de *scheduling* apropiativo)
 
### Procesos accediendo a partes de la memoria fuera de su espacio declarado

* Si un proceso X está guardando datos en la memoria, no debería poder llegar una instrucción de un proceso Y a modificar esos datos.
* **Solución: protección de la memoria**
    * Cada vez que se carga un proceso en RAM, el kernel define un registro base y un registro límite. Dicho proceso solo podrá acceder a las direcciones entre ambos registros.
    * La definición de los registros bases y límites son instrucciones privilegiadas que solo puede ejecutar el kernel. Si no fuese así, el propio proceso podría expandir su espacio de direcciones, lo que haría inútil los registros bases y límites.

### Procesos ejecutando instrucciones exclusivas del sistema

* Hay operaciones, como la definición de registros base y límite, de lectura y escritura, o aquellas relacionadas al vector de interrupciones, que solo debería poder ejecutarlas el *kernel*. En caso contrario, el sistema sería vulnerable a ataques.
* **Solución: modos de ejecución**
    * En el registro PSW (*Program Status Word*), en donde se guardan las flags (Z, C, etc), se guarda una flag adicional llamada “modo de ejecución”
    * Dicha flag puede estar en modo usuario o modo kernel. En modo usuario, las instrucciones solo pueden acceder a direcciones del proceso del que provienen. En cambio, en modo kernel, no hay tal restricción.
* **Ejemplo**:
    * Un proceso X, intentó ejecutar la siguiente instrucción con el CPU en modo usuario:
        * `mov ax, [987h]`
    * ¿Qué va a pasar?
        * Si la dirección 987h es parte de las direcciones que se le asignaron al proceso X, se va a ejecutar sin problema.
        * En cambio, si 987h pertenece a otro proceso, o al propio SO (por ejemplo si es parte del vector de interrupciones), se genera un acceso indebido a memoria. Por lo tanto, no se puede ejecutar.
        * Si la CPU hubiese estado en modo kernel, la ejecución se podría haber ejecutado normalmente. Sin embargo, es importante aclarar que un proceso no puede cambiar a modo kernel para hacer lo que le quiera, sino que solo puede cambiar el modo del CPU mediante una interrupción. Y luego de ella, el código que se va a ejecutar lo determina el vector de interrupciones en vez del propio proceso.
* **Nota:** el kernel es la única parte del SO que se ejecuta en modo privilegiado. Otros componentes del SO y los programas de usuario se ejecutan en el modo usuario. Las instrucciones que se ejecutan en modo kernel se relacionan a:
    * Gestión de procesos
        * Creación, terminación, planificación, etc.
    * Gestión de memoria
        * Reserva de espacio de direcciones para los procesos (registros bases y límites), *swapping*, gestión de páginas y segmentos.
    * Gestión de E/S
        * Gestión de buffers, reserva de canales de E/S y de dispositivos de los procesos
    * Funciones de soporte
        * Gestión de interrupciones, auditoría y monitoreo.

### Procesos controlando dispositivos externos

* Un proceso no debería ser capaz de controlar directamente dispositivos externos como un disco o una impresora.
* **Solución: todas las instrucciones de E/S, que controlan directamente al hardware, se consideran privilegiadas, y solo pueden ejecutarse en modo kernel.**
* *Nota*: esto a su vez genera un problema. ¿Cómo hacen los procesos que requieren hacer uso de los dispositivos (por ejemplo para escribir un archivo en disco), pero no tienen privilegios para controlar al dispositivo? La solución son las *system calls*, que son esencialmente pedidos al SO para que este realice la instrucción privilegiada.

## System calls

### Conceptos

* Es la forma en la que los programas de usuario pueden acceder a los servicios del SO (por ejemplo para usar dispositivos de E/S).
* Toda system call devuelve éxito o fracaso
* Los procesos no suelen invocar la system call directamente, sino a través de una biblioteca (API). La función de biblioteca se llama *wrapper*.

### Paso a paso

#### Fase 1

* El programa llama al *wrapper* como a cualquier otra función. Ej: `read(fd, buffer, n)`
* Para que el *wrapper* pueda hacer la *system call*, necesita pasarle al kernel un parámetro que le diga *qué system call está llamando*. Esto lo hace mediante un número, ya que hay una tabla que une a cada system call con un número identificador.
    * El *wrapper* envía como parámetro/s al kernel tanto el identificador como los parámetros de la función misma `(fd, buffer, n)`. Este pasaje se puede hacer mediante registros, mediante un bloque de memoria cuya dirección va en un registro, o mediante la pila. El *wrapper* se encarga de que los parámetros estén donde el kernel los espera.
* El *wrapper* ejecuta una instrucción especial (**NO PRIVILEGIADA**). Esto genera un *trap*, que es una excepción, y hace que se pase a modo kernel

#### Fase 2 (hardware)

* El CPU pasa de modo usuario a modo kernel
* El CPU guarda la dirección de retorno y el **PSW**.
    * Dependiendo de la arquitectura, pueden guardarse en registros o en la pila del kernel.
* El CPU guarda en PC un punto de entrada fijo, para que la próxima instrucción a ejecutar sea código del kernel.
    * *Nota*: el punto de entrada es el mismo para todas las system calls. Una vez que se empiece a ejecutar el código del kernel, él será el responsable de revisar el parámetro con el número de system call, para decidir qué subrutina ejecutar. El hardware se abstrae de todo eso y solamente carga el punto de entrada fijo para todas las *system calls*

#### Fase 3 (atención en el kernel)

* Se cambia a la pila del kernel.
* Se resguardan los registros del proceso
* Se valida el número de system call que recibió por parámetro
    * Si no corresponde a ninguna de las system calls que existen, se rechaza con un código de error
* Se encuentra el número de system call en la tabla de system calls, y se va a a la dirección de la subrutina de servicio correspondiente.
* Antes de ejecutar el servicio, valida todos los parámetros que recibió
    * Si algún parámetro es inválido, devuelve error
    * Verifica que descriptores y tamaños sean válidos.
    * Debe comprobar que, si hay punteros, deben apuntar al espacio de direcciones del proceso (y no del kernel).
* Una vez que todos los parámetros fueron validados, se deben traer al kernel usando la subrutina copy\_from\_user()
* Se ejecuta la subrutina de servicio.
    * Caso en el que el servicio no es bloqueante
        * Lo importante es que en este caso, no sucede ningún cambio de contexto, y el proceso nunca dejó el estado *running*. Solo hubo un cambio de modo usuario a kernel, y luego de vuelta a modo usuario cuando retorna (fase 4).
    * Caso en el que el servicio es potencialmente bloqueante
        * Si la subrutina pide datos, la rutina debe verificar si ya están disponibles.
        * Si lo están (por ejemplo, en el buffer cache): se copian al buffer del proceso y se retorna sin bloquear
        * Si no lo están: el Kernel solicita la operación al driver del dispositivo y el proceso debe esperar
        * En el caso de que no lo estén, mientras el proceso está esperando los datos, pasa al estado de *waiting*. Esto significa que el scheduler va a elegir a otro proceso para aprovechar la CPU, y se va a empezar a ejecutar *otro proceso distinto* mientras el proceso original espera los datos.
        * Una vez que el proceso original vuelve a ser elegido, continúa la ejecución del servicio en modo kernel.

#### Fase 4 (retorno)

* La rutina deja el resultado en un registro acordado (valor negativo indica error)
* El hardware restaura el PC y el PSW, y vuelve a Modo Usuario.
* El *wrapper* interpreta el resultado del Kernel
    * Si hubo error, guarda el código en `errno` y devuelve -1.
    * Si no, devuelve el resultado de la system call (bytes leídos, PID, etc).

# Procesos

## Componentes de un proceso

* Un proceso ocupa su espacio de direcciones. En él se almacena:
    * Sección de código
    * Sección de datos (variables globales)
    * Stack(s) (datos temporales).
        * Con el enfoque en el que el kernel está dentro del proceso, se tiene una pila de usuario y una pila de kernel
        * Está formado por stack frames que son pushed (al llamar a una rutina) y popped (cuando se retorna de ella)
        * El stack frame tiene los parámetros de la rutina, y datos necesarios para recuperar el stack frame anterior (PC y el valor del stack pointer en el momento del llamado).

## Atributos de un proceso

* PID (identificador único de proceso)
* PPID (ID del proceso que lo disparó, llamado proceso padre)
* ID del usuario que lo disparó
* ID del grupo que lo disparó (si hay)
* En ambientes multiusuario, desde que terminal y quien lo ejecuto.

## PCB

* El PCB (*Process Control Block*) es una estructura de datos asociada a un proceso
* Existe una por cada proceso
* Es lo primero que se crea cuando se crea un proceso y lo último que se borra cuando termina
* Contiene a información asociada con cada proceso:
    * PID, PPID
    * Valores de los registros de la CPU (PC, IR, PSW, SP, registros generales)
    * Estado, prioridad, tiempo consumido
    * Ubicación en memoria
    * Accounting (estadísticas de uso de recursos)
    * Entrada salida (estado, pendientes)
* *Nota:* un proceso no puede acceder a su propio PCB. Es información que se guarda **fuera** del espacio de direcciones de un proceso, y a la que solo se puede acceder en modo kernel.
* A la información que guarda la PCB sobre un proceso, que es la que el SO necesita para administrarlo y la CPU para ejecutarlo, se le llama **contexto**.
* Cuando se habla de “colas de procesos”, como la cola de listo, en realidad la cola contiene los PCB de los procesos correspondientes.

## Cambio de contexto

* Un cambio de contexto (*context switch*) sucede cuando en la CPU se está ejecutando un proceso A, pero se decide cederle la CPU a otro proceso B, guardando el estado de A para retomarlo después.

### Fase 1 (realizada por el *hardware*)

* Sucede una interrupción de clock, dándole control al kernel.
* Al finalizar la instrucción en curso, la CPU verifica si hay interrupciones pendientes y habilitadas.
    * Hace esto porque la instrucción en ejecución al momento de la interrupción nunca puede quedar a medias.
* El CPU pasa a modo kernel
* El CPU deja la pila del usuario y pasa a la pila del kernel.
    * Cada proceso tiene su pila de kernel
* El *hardware* guarda lo indispensable para poder retornar: PC, PSW y SP (*Stack Pointer*) de usuario. También enmascara las interrupciones, de manera que estas van a estar bloqueadas por el momento.
* Con el número de la interrupción se indexa la tabla de vectores, se obtiene la dirección de la subrutina correspondiente y se carga en el PC.

### Fase 2 (ISR y planificación)

* Se resguardan los registros de uso general en la pila del kernel.
    * El sp del kernel queda apuntando a estos registros. Justo debajo de ellos está también la información esencial que se guardó en la fase 1 (PC, PSW y SP del usuario). Esto es importante porque luego el sp del kernel se deberá almacenar en la fase 3.
* Se notifica el fin de la interrupción al controlador.
* Se actualiza la hora del sistema y el uso de CPU.
* Se decrementa el *quantum* del proceso en ejecución.
* Si el *quantum* se agotó, se invoca al *short-term scheduler*.
    * El proceso saliente pasa de Running a Ready y su PCB se encola en la cola de listos
    * Se elige al próximo proceso a ejecutar según el algoritmo usado (RR, FCFS, etc)
    * Si se elige al mismo proceso, **no hay cambio de contexto**. Se retorna directamente (fase 4)

### Fase 3 (el cambio de contexto)

* Estos pasos los realiza el *dispatcher*.
* El SP del kernel, que apuntaba a toda la información resguardada (PC, PSW, SP del usuario y registros generales) se almacena en el PCB del proceso en ejecución.
    * De esta manera, en la PCB queda toda la información necesaria para seguir ejecutando el proceso.
* Cambio de espacio de direcciones. Se carga el registro base de la tabla de páginas del proceso entrante.
    * Solo es necesario si el entrante tiene otro espacio de direcciones.
    * **Costo:** hay una tabla que almacena las traducciones recientes de direcciones lógicas a físicas, que funciona como una especie de caché para no tener que traducirlas cada vez. Al cambiar el estado de direcciones, la tabla se vuelve inútil hasta que se empiece a llenar de las traducciones del nuevo espacio de direcciones.
* Se carga el contexto del proceso entrante. Dicho contexto se encuentra en la dirección a la que apunta el sp-kernel resguardado en el PCB del proceso.
* Para obtener los datos del contexto, se deben desapilar todos esos datos de la pila del kernel del nuevo proceso.
* *Nota:* mientras el CPU ejecuta todo esto, no puede estar ejecutando procesos. Es por esto que un cambio de contexto tiene cierto costo, y se dice que es **overhead** (no realiza trabajo útil para los procesos). Si se permite un grado de multiprogramación muy alto, generando cambios de contexto constantemente, podría tener efectos negativos en el rendimiento.

### Fase 4 (retorno a modo usuario)

* El Kernel ejecuta una instrucción atómica que desapila PC, PSW y SP de usuario, restaurando el estado que tenía el nuevo proceso al momento en el que fue suspendido originalmente.
* El CPU vuelve a modo usuario.

## Estados de un proceso

* Estado **new**: un usuario disparó el proceso. Se hizo la system call que empieza el proceso y su PCB. El proceso queda en la *cola de procesos* (ubicada en almacenamiento secundario).
    * **Transición new → ready:** para pasar de new a ready, el long term scheduler debe elegir al proceso para cargarlo en RAM
* Estado **ready**: el proceso ya fue cargado en RAM. Necesita la CPU para su ejecución, pero está esperando a que el short term scheduler lo elija para asignarle dicho recurso.
    * **Transición ready → running:** Para pasar de ready a running, el short term scheduler debe elegir al proceso de la cola de **ready**. Luego, el dispatcher debe asignarle la CPU al proceso elegido por el short term scheduler. 
* Estado **running**: el proceso ya fue elegido por el short term scheduler. Tendrá la CPU hasta que el algoritmo de planificación lo expulse, necesite E/S o termine. Si el algoritmo de planificación lo expulsó, pero el proceso todavía no terminó, vuelve a la cola de procesos **ready**.
    * **Transición running → waiting:** el proceso “se pone a dormir”, esperando por un evento.
* Estado **waiting**: el proceso está esperando a que ocurra un evento para continuar su ejecución. Dicho evento puede ser la terminación de una E/S solicitada, o la llegada de una señal por parte de otro proceso. Cuando termine el evento, vuelve al estado **ready**. Es importante aclarar que cuando un proceso simplemente está esperando a que le asignen la CPU, NO está en este estado (en ese caso está en el estado **ready**).
    * **Transición waiting → de vuelta a ready:** Terminó la espera y compite nuevamente por la CPU.
* Estado **terminated**: se llegó a la última instrucción del proceso. Se le avisa al kernel con la system call “exit” para que libera la RAM (borrando el PCB y otras cosas) y la CPU. Antes de borrar, hay un momento en el que el kernel conserva la PCB y otras cosas, aunque le proceso ya haya terminado. Se dice que el proceso está en “estado zombie”
* *Nota:* puede haber múltiples colas para cada estado. Por ejemplo, para el estado waiting, va a haber una cola por cada evento al que se esté esperando.



