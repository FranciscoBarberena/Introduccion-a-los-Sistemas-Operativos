* Parte 1
    * Componentes de SO
    * Proceso de arranque
    * System calls
* Procesos
    * PCB, que chota es
    * Módulos de planificación (schedulers, dispatcher, loader)
    * Context switch
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
* El *wrapper* ejecuta una instrucción especial (NO PRIVILEGIADA). Esto genera un *trap*, que es una excepción, y hace que se pase a modo kernel

#### Fase 2 (hardware)

* El CPU pasa de modo usuario a modo kernel
* El CPU guarda la dirección de retorno y el **PSW**.
        * Dependiendo de la arquitectura, pueden guardarse en registros o en la pila del kernel.
* El CPU guarda en PC un punto de entrada fijo, para que la próxima instrucción a ejecutar sea código del kernel.
    * **Nota**: el punto de entrada es el mismo para todas las system calls. Una vez que se empiece a ejecutar el código del kernel, él será el responsable de revisar el parámetro con el número de system call, para decidir qué subrutina ejecutar. El hardware se abstrae de todo eso y solamente carga el punto de entrada fijo para todas las *system calls*

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
    * Si no, devuelve el resultado de la system call (bytes leídos, PID, etc.).
  

    






