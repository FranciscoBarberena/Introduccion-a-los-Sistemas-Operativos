# Memoria virtual

## Introducción

* **Definición:** es el concepto que define que un proceso no debe encontrarse en la RAM en su totalidad para ejecutarse. Es decir, si se quiere ejecutar el proceso A, se pueden cargar únicamente unas porciones (páginas/segmentos) del proceso en memoria, y que el resto de porciones se carguen a medida que se necesitan.
    * Se denomina conjunto residente a las porciones del proceso que realmente están en RAM.
* **Ventajas**
    * Un proceso puede ser más grande que la memoria principal.
        * Esto implica que el programador no debe preocuparse por el tamaño de sus programas.
    * Se pueden tener más procesos en memoria. Esto aumenta la probabilidad de que siempre haya algún proceso en la cola de listos (*ready*), lo que minimiza el tiempo ocioso de la CPU.
* Requerimientos para poder implementar memoria virtual:
    * Procesador
        * Debe soportar paginación y/o segmentación por demanda
        * Debe soportar la traducción lógica de direcciones (MMU)
        * Debe detectar accesos a porciones que no están en RAM, para generar interrupciones (fallo de página)
    * Debe haber un dispositivo de memoria secundaria (disco), en el que se puedan almacenar las porciones del proceso que no están en RAM. El área del disco destinada a ese propósito se denomina **área de SWAP** o **área de intercambio**.
    * El kernel debe poder manejar la carga y descarga de porciones entre la RAM y el área de SWAP. También debe saber si las porciones están o no en memoria, mediante la tabla de páginas/segmentos.

## Implementación

* Los detalles de implementación se ven sobre un modelo de paginación (no segmentación).
* Cada proceso tiene su propia tabla de páginas
* Cada entrada en la tabla de páginas tiene el siguiente formato, que lo determina el hardware, y tiene la siguiente información:
    * Frame correspondiente en la memoria física
    * Bits de control
* Algunos de los bits de control son:
    * **Bit V:** indica si la página está realmente en RAM.
        * Lo manipula el kernel y lo consulta el hardware.
    * **Bit M:** indica si la página fue modificada desde que se cargó en RAM
        * Lo activa el hardware, lo consulta y desactiva el kernel.
    * **Bit R:** indica si la página fue referenciada desde cierto punto, determinado por el algoritmo usado por el kernel para seleccionar víctimas.
        * Lo activa el hardware y lo consulta y desactiva el kernel.
    * Entre otros
* Ejemplos de manejo de los bits de control (¿Qué significa que los manipulen o consulten el hardware/kernel?):
    * **Bit V:**
        * El procesador recibe una instrucción que pide acceso a una dirección.
        * El procesador consulta si la página que contiene la dirección pedida está en RAM (es decir, revisa su bit V en la tabla de páginas).
        * El procesador ve que el bit V está en 0 (no está la página en RAM) y genera una interrupción para darle el control al kernel. Esta interrupción se llama *trap* o *interrupción de fallo de página*.
        * El kernel carga la página en RAM, y cambia el bit de V a 1 para que quede registro de que la página está en RAM. También guarda el marco asignado a la página en la tabla.
        * El procesador ahora puede ejecutar la instrucción que recibió en el paso 1, porque la página necesaria está en RAM con el bit V=1.
    * **Bit M:**
        * El procesador recibe una instrucción que pide cambiar el contenido de una celda de memoria
        * Al escribir la celda, el procesador pone el bit M=1 de la página que contiene la celda.
        * Posiblemente después de un tiempo, la página que contiene dicha celda deba ser bajada a SWAP.
        * Cuando esto sucede, el kernel revisa el bit M, ve que está en 1, y determina que debe actualizar el contenido de la página en SWAP. Una vez que lo hace, vuelve a poner el bit M en 0 (además debería poner el bit V en 0, ya que la página ya no está en RAM).
            * Esto es necesario porque la página se modificó en RAM, y en SWAP quedó la versión desactualizada.
    * **Bit R:**
        * El procesador recibe una instrucción que pide acceder a la celda con la dirección 1000h.
        * Una vez que la ejecuta, el procesador pone el bit R de la página que contiene a 1000h en 1.
        * Esta información la consulta el kernel cuando tiene que seleccionar una página víctima, con los algoritmos que serán explicados más adelante (NRU, segunda chance, etc).
    
## Fallos de página

* **Definición:** un fallo de página ocurre cuando el procesador intenta ejecutar una instrucción, y la misma requiere acceso a una dirección de memoria cuya página no está cargada en RAM.

### Secuencia de un fallo de página

* El procesador intenta ejecutar una instrucción que accede a una dirección de memoria. Esta dirección de memoria corresponde a una página cuya entrada en la tabla tiene el bit V=0.
* Sucede un **fallo de página**. El procesador genera un *trap* y le da control al kernel.
* El kernel puede colocar al proceso que había ejecutado la instrucción en un estado de “*Blocked*” mientras carga la página que dicho proceso necesita para su última instrucción.
* El kernel busca un frame libre para asignarle a la página que generó el fallo. Genera una operación de E/S al disco para copiar en dicho *frame* la página que generó el fallo.
    * *Nota: ¿Qué pasa si no hay frames libres? Ver “Selección de página víctima”.*
    * Mientras sucede esta operación de E/S, el kernel puede asignarle el CPU a otro proceso, para maximizar el uso del CPU. Una vez que la operación de E/S termina, se avisa su finalización mediante una interrupción.
    * Una vez que el kernel recibe la interrupción que avisa la finalización de la E/S, este debe actualizar la tabla de páginas:
        * Coloca el bit V en 1 de la página cargada.
        * Guarda en la misma entrada el frame asignado a la página.
* El proceso que generó el fallo de página, y se había puesto en estado “*Blocked*” ahora vuelve al estado de *Ready*. Cuando sea seleccionado de nuevo por el scheduler, ahora podrá ejecutar la instrucción del paso 1, que había generado el fallo de página (porque la página necesaria ahora está en RAM).

### Tasa de fallos de página

* La tasa de fallos de página es un número *p* entre 0 y 1, que determina la frecuencia de los fallos de página en el sistema o en un proceso particular.
* Si es 0, significa que no hay fallos de página.
* Si es 1, cada acceso a memoria es un fallo de página.
* Esta tasa puede afectar el tiempo efectivo de acceso a memoria (EAT), ya que este se determina por la siguiente fórmula:
    * `EAT = (1 – p) x memory access + p x (tiempo_de_manejo_de_fallo + [swap_page_out] + swap_page_in + tiempo_de_restauración_de_contexto)`
    * Notar que `swap_page_out` es opcional, porque no haría falta bajar la página a disco si esta tiene su bit M=0, o si hay frames libres en RAM.
    * Memory access: es el tiempo de acceso a una dirección de memoria (que está en RAM).
    * El tiempo de manejo de fallo de página incluye: el *trap*, guardar el contexto, encontrar la página nueva en disco, ordenar la operación de E/S que carga la página nueva en RAM (lo que sea que tarde la operación será el tiempo de swap_page_in), recibir la interrupción de que terminó la operación de E/S y actualizar la tabla de páginas
    * El tiempo de restauración de contexto representa a que, cuando se vuelva a elegir el proceso que produjo el fallo de página, se deben restaurar sus registros y estado. También debe volver a ejecutarse la instrucción que falló desde 0

### Selección de página víctima

* **Problema:** ¿Qué pasa si sucede un fallo de página, y no hay frames libres para asignarle a la página que debe ser cargada en memoria?
* **Solución:** el kernel debe seleccionar una de las páginas que está cargada en memoria, y sacarla de la RAM (bajándola a SWAP si su bit M=1). La página que se selecciona para sacar de la RAM se denomina *página víctima*.
* Lo ideal sería seleccionar a aquella página que no volverá a ser utilizada por ningún proceso en el futuro. Esto se denomina algoritmo óptimo, y es únicamente teórico, ya que es imposible predecir con exactitud las páginas que va a necesitar un proceso. Sin embargo, se desarrollaron distintos algoritmos que intentan aproximarse al óptimo. Estos son: FIFO, 2da Chance, NRU y LRU.

#### FIFO

* Selecciona como víctima a aquella página que hace más tiempo se cargó en memoria.
* Es fácil de implementar ya que la única estructura de datos que requiere mantener es una cola.
* Su desventaja es que no tiene en cuenta la frecuencia de uso de la página.

#### 2da Chance

* Generalmente se combina con el algoritmo FIFO.
* Selecciona a la posible víctima como FIFO, pero antes de realmente quitarla de la RAM, revisa el bit R de la página. Si está en 1 significa que fue referenciado, y el algoritmo lo "perdona”. Es decir, lo manda al final de la fila y reinicia su bit R.
* También es fácil de implementar, pero presenta una mejora considerable en comparación a FIFO común.

#### NRU

* Usa tanto el bit R como el bit M de la entrada correspondiente en la tabla de páginas.
* Prioriza a las posibles páginas víctima de la siguiente manera:
    * Si tienen bit R=0 y M=0, serían la víctima ideal → prioridad 0
    * Si tienen bit R=0 y M=1, no se usó recientemente, pero hay que bajarla a disco → prioridad 1
    * Si tienen bit R=1 y M=0 se usó recientemente, pero no hay que bajarla a disco → prioridad 2
    * Si tienen bit R=1 y M=1, serían la peor víctima posible, porque se usó recientemente y hay que bajarla a disco → prioridad 3
* El algoritmo selecciona como víctima a cualquier página dentro de la categoría con prioridad 0 si es posible. Si no hay ninguna página en esa categoría, elige uno con prioridad 1, y así sucesivamente.

#### LRU

* Es el que más se aproxima al algoritmo óptimo
* Tiene un alto costo de implementación, ya que requiere almacenar marcas de tiempo de la última vez que se referenció a las páginas.
* Selecciona como víctima a aquella página que hace más tiempo no se referencia.

### Alcance de reemplazo

* Todos los algoritmos explicados previamente eligen una página víctima dentro de un conjunto de páginas.
* La política de alcance de reemplazo determina dentro de qué conjunto de páginas se va a buscar la víctima.
* Sus 2 opciones son: global y local.
    * **Reemplazo global:** selecciona una página víctima de todas las que están cargadas en RAM, usando alguno de los algoritmos anteriores.
    * **Reemplazo local:** funciona de la siguiente manera:
        * Acaba de suceder un fallo de página, es decir, un proceso A intentó acceder a una página que no está en memoria.
        * Con esta política de reemplazo, la página víctima a seleccionar será una página del proceso A. De esta manera, se evita que un proceso le quite páginas a otro. La manera de seleccionar la víctima sigue siendo con alguno de los algoritmos mencionados.
        * **Ventaja:** Permite aislar la tasa de fallos de página de cada proceso. Es decir, si un proceso tiene una alta tasa de fallos de página, se puede deducir que debería tener más RAM asignada. En cambio, con la política global, no hay manera de saber si realmente necesita más RAM, o si hay otro proceso quitándole frames.

## Implementaciones de tabla de páginas

### Tabla de 1 nivel

* Tiene una entrada por cada página virtual del proceso
    * Esto significa que su tamaño no cambia. Siempre debe tener una entrada para cada posible página, aún si el proceso solo usa un bajo porcentaje del mismo.
* Se almacena contiguamente en memoria
* Para traducir una dirección:
    * La dirección tiene un número de página y un desplazamiento.
    * Con el registro base ubica la tabla del proceso, y se ubica en la entrada con el número de página de la dirección.
    * Una vez que detecta en qué frame está la página (si es que está), se desplaza tantos bytes como indique el desplazamiento de la dirección.
        * En el caso de que no esté en memoria, porque V=0, ocurre un fallo de página.
* Son 2 accesos a memoria para cada dirección (tabla de páginas + dato)
* Ventajas:
    * Un solo acceso a la tabla
    * El hardware de la MMU es simple
    * Es simple de implementar un sistema en el que 2 procesos comparten una página. Dos tablas de distintos procesos pueden tener una entrada que apunta al mismo marco.
* Desventajas:
    * El tamaño es proporcional al espacio virtual (inviable en arquitecturas de 64 bits)
    * Debe ser contigua en memoria. Esto genera huecos entre páginas de datos, código y pila

### Tabla multinivel

* Se pagina la tabla de páginas
* Existe una tabla similar a la tabla de 1 nivel. Cada entrada de esta apunta a otra tabla, cuyas entradas sí apuntan a frames con datos. Estas tablas de segundo nivel solo se cargan en memoria cuando se demandan, disminuyendo considerablemente el espacio que ocupa la tabla.
* Para traducir una dirección:
    * La dirección tiene: número de página en la tabla de nivel 1, número de página en la tabla de nivel 2, y desplazamiento.
    * Con el registro base accede a la tabla de nivel 1 de ese proceso. Allí accede al número de página de nivel 1 de la dirección.
    * Esa entrada está asociada a un frame, que lleva a otra tabla. Dentro de esa segunda tabla, ubica el número de página de nivel 2 (el que está almacenada en la dirección), y se desplaza los bytes que indique el valor del desplazamiento.
* Son 3 accesos a memoria (tabla nivel 1 + tabla nivel 2 + dato)
* Este esquema puede expandirse a más de 2 niveles. En arquitecturas de 64 bits se usan 4 o 5.
* Ventajas:
    * La tabla ocupa menos espacio, ya que las de 2do nivel no están siempre cargadas.
    * Cada tabla cabe en un marco, no requiere espacios contiguos grandes
    * Las subtablas que corresponderían a partes inutilizadas del espacio de direcciones del proceso, directamente no se crean.
* Desventajas:
    * Un acceso extra por nivel
    * Recorrido más complejo

### Tabla invertida

* Hay una entrada por cada marco físico. Por lo tanto, deja de haber una tabla para cada proceso. Ahora hay una sola tabla para todo el sistema.
* En cada entrada se almacena:
    * Número de página, PID del proceso al que corresponde y "siguiente frame” (este último se usa para manejar las colisiones, como en el siguiente ejemplo).
* Resolución de direcciones:
    * Se usa el PID y el número de página como entrada a una función de *hash*, que devuelve un número.
    * Ese número, (por ejemplo, 45), se busca en una tabla llamada tabla de anclaje.
        * Esta almacena, para cada resultado de hash, qué frame le corresponde.
        * Por ejemplo, una entrada podría ser:
            * hash 45 → frame 20
        * Entonces, cuando obtenga el número 45 de la función de hash, lo busca en la tabla y encuentra que esa página está en el frame 20
        * Luego, se debe revisar si, en el frame 20, están almacenados el PID y el número de página correspondientes. Si no lo están, se revisa el campo "siguiente frame", y se revisa (en la tabla), la entrada del frame almacenado allí. Una vez que se encuentra el PID y número de página correspondientes, finaliza la búsqueda. Si nunca se encuentra, hay un fallo de página
* Ventajas:
    * Tamaño fijo proporcional a la RAM
    * Una sola tabla para todos los procesos
    * Independiente del espacio virtual. Apta para 64 bits
* Desventajas
    * Requiere de una búsqueda en cada traducción
    * Depende fuertemente de la TLB
    * Compartir páginas es complejo debido a la naturaleza de las funciones de dispersión
    * Las páginas que no están en memoria no figuran en la tabla

## Elección de tamaño de página

* Páginas pequeñas:
    * Ventajas:
        * Menor fragmentación interna.
    * Desventajas:
        * Hace que los fallos de página sean menos productivos
        * Tabla de páginas más grande
* Páginas grandes:
    * Ventajas:
        * Tabla de páginas más chica.
        * Hace que los fallos de página sean más productivos. Es decir, se produce un fallo, se carga una página en RAM, y esa carga trae más información que si la página fuera pequeña.
        * Aprovecha el hecho de que los discos están diseñados para transferir grandes bloques de datos eficientemente.
        * Aprovecha mejor la TLB
    * Desventajas
        * Mayor fragmentación interna
* Además, el tamaño de páginas tiene un impacto sobre el concepto de localidad, ya que páginas muy grandes pueden hacer que se traiga información fuera de la localidad, y páginas chicas pueden hacer que no se traiga toda la localidad. Esto se explica más adelante con el concepto *Thrashing*.

## TLB (Translation Lookaside buffer)

* **Problema:** en memoria virtual, resolver una dirección de memoria siempre requiere como mínimo 2 accesos a RAM. Uno para encontrar el frame correspondiente en la tabla de páginas, y otro para obtener los datos del frame en el que está asignada.
* **Solución:** se agrega una memoria caché de alta velocidad llamada TLB.
    * Contiene las entradas de tabla de páginas de las direcciones virtuales usadas recientemente.
    * El procesador siempre revisa la TLB antes de intentar resolver la dirección virtual por su cuenta.
    * Al ser una memoria rápida, se considera que se analizan todas las entradas de la TLB en simultáneo
* **Nota:** ante un cambio de contexto, se invalida totalmente la TLB. Esto sucede porque la TLB tendrá las entradas de la tabla de páginas que necesitó el proceso en ejecución. Como cada proceso tiene su propia tabla de páginas, con sus propias entradas, la TLB se debe invalidar para que no quede información sobre las páginas del proceso anterior.

## Asignación de marcos

* **Concepto:** la política de asignación de marcos determina cuántos marcos va a tener un proceso a su disposición. Por ejemplo: si tengo 200 frames libres y 5 procesos, ¿Cuántos marcos puede usar cada proceso como máximo? La respuesta depende de la política de asignación que se use. Estas son: asignación fija (puede ser equitativa o proporcional) y asignación dinámica.

### Asignación fija

* La cantidad de frames asignados a cada proceso se determina de antemano en este tipo de asignación.
* Siempre se combina con el alcance de reemplazo local.

#### Asignación fija equitativa

* Se tiene en cuenta la cantidad de frames y la cantidad de procesos, tratando a todos los procesos como iguales. Es decir, si tengo 200 frames libres y 4 procesos, cada proceso obtendrá: `200/4 = 50 frames`
* **Problema:** no tiene en cuenta que hay procesos que necesitan más RAM que otros. En el ejemplo anterior, en el que se asignan 50 frames a cada proceso, se desperdiciaría espacio si uno de esos procesos solo necesita 10 frames.

#### Asignación fija proporcional

* Se tiene en cuenta el tamaño del programa correspondiente al proceso. Esto sirve como una aproximación de lo que puede llegar a ocupar en RAM.
* **Ejemplo:** se tienen 100 frames libres y 4 procesos
    * El proceso A tiene un programa de 100 páginas
    * El proceso B tiene un programa de 50 páginas
    * El proceso C tiene un programa de 20 páginas
    * El proceso D tiene un programa de 30 páginas
    * En total los procesos ocupan 200 páginas
        * De esas 200: el proceso A ocupa 50%, el proceso B ocupa 25%, el proceso C 10% y el proceso D 15%
        * Entonces, al proceso A se le asignan 50% de los 100 frames libres, al proceso B 25%, al proceso C 10% y al proceso D 15%
        * Quedaría: proceso A con 50 frames, proceso B con 25 frames, proceso C con 10 frames y proceso D con 15 frames.

### Asignación dinámica

* Puede combinarse tanto con política de alcance global como local
* La cantidad de frames asignados a cada proceso se determina durante la ejecución de los mismos.
* Su funcionamiento consiste en que, a medida que los procesos piden memoria, se les asignan los marcos que necesitan.
* **Problema:** los procesos de alta prioridad terminan acaparando todos los marcos

## Hiperpaginación

* Un sistema está en hiperpaginación (o *thrashing*) cuando pasa más tiempo paginando que ejecutando procesos.
* Usar un alcance de reemplazo local evita el robo de frames, por lo que limita el efecto del thrashing a un solo proceso.

### Modelo de localidad

* Las referencias a datos y programa dentro de un proceso tienden a agruparse. Es decir, es probable que un proceso necesite las páginas 5-10 durante un tiempo, hasta que, repentinamente, use las páginas 18-24. Este conjunto de páginas que se usa durante un período de tiempo se denomina localidad.
* Lo ideal sería que, en memoria, esté cargada la localidad que se está usando en el momento. Y que los *page faults* solo ocurran cuando se cambia de localidad.

### Working set (WS)

* Se define un Δ. (Por ejemplo, Δ = 5)
* El working set de un proceso consiste de las más recientes Δ referencias a páginas.
* En el ejemplo anterior, si un proceso referenció a las páginas en este orden: 12233445, el working set sería {5,4,3}.
* Una elección de Δ muy chico no cubrirá la localidad, mientras que un Δ muy grande abarcaría varias localidades.
* ¿Cómo detectar thrashing con este método?
    * m = cantidad de frames disponibles
    * WSS de A= tamaño del working set del proceso A.
    * Suma de todos los WSS: la llamamos D, es la demanda de frames que tiene el sistema.
    * Si D>m, entonces hay thrashing, ya que el sistema está demandando más frames de los que hay disponibles.
* El kernel asigna tantos frames a cada proceso como lo determine su WSS. Si D crece por encima de m, se elige un proceso para sacar de memoria, disminuyendo el grado de multiprogramación.
* **Desventaja:** es costoso mantener un registro de los WSS de todos los procesos. Además, la ventana de working set es móvil.

### Page fault frequency (PFF)

* Surge como una aproximación más económica al working set.
* Usa la tasa de fallos de página de un proceso.
* El kernel determina una cota inferior y una cota superior de tasas de fallo
    * Si la tasa de un proceso supera la cota superior, necesita más frames.
    * Si la tasa de un proceso está por debajo de la cota inferior, se le pueden quitar frames.
* ¿Cómo detectar thrashing con este método?
    * Si todos los procesos tienen una tasa de fallo mayor a la cota superior, y no hay frames libres que asignarles, el sistema está en thrashing. Se debe bajar el grado de multiprogramación.

## Demonio de paginación

* Es un proceso creado por el *kernel* durante el arranque del sistema.
* Ayuda a administrar la memoria. Se ejecuta cuando la cantidad de memoria libre queda por debajo de un número de frames establecido por el kernel, o hay muchas páginas “sucias” (bit M=1). También se ejecuta cuando la CPU tiene baja utilización, para aprovechar tiempo ocioso.
* Tareas:
    * Limpiar páginas modificadas, sincronizándolas con el área de SWAP.
    * Mantener un cierto número de frames libres en el sistema en todo momento.
    * Demorar la liberación de una página hasta que sea necesario.

## Memoria compartida

* Los procesos pueden compartir frames. Es decir, un proceso A puede tener su página 2 asociada al frame 5, mientras que al mismo tiempo, la página 7 del proceso B apunta al mismo frame (5).

### Mapeo de archivo a memoria

* Un proceso asocia el contenido de un archivo a una zona contigua en su espacio de direcciones. Por ejemplo, 1000h-1200h
    * En este paso **no se carga nada en memoria aún**.
* Cuando intenta acceder a la dirección 1100h, se produce un fallo de página, y es en ese momento que *esa parte* del archivo se carga en memoria. Para resolver este fallo de página, hay que buscar el contenido al archivo. No hay que acceder al área de SWAP.
* Si se modifica alguna de esas páginas en RAM, cuando se bajan a disco, se bajan al archivo en vez de al SWAP también.

### Copy on Write

* Cuando 2 procesos comparten un frame, el kernel marca esas páginas (en las tablas de los 2 procesos) como Copy on Write (COW), lo que las hace de solo lectura.
    * Esto significa que, cuando alguno de los 2 procesos intente escribir esa página, no van a poder escribirla directamente. Esto generará un trap por error de permisos, que hace que en el momento de la escritura, se duplique la página, y los procesos van a dejar de compartir la página. Debe actualizar la tabla de páginas del proceso que la escribió, y hacer que la página del otro ya no sea COW.
* Consecuencia: a nivel frames, un fork tiene costo 0 hasta que el nuevo proceso empiece a escribir frames.

### Implementación de área de SWAP

* Puede ser un área separada del sistema de archivos, como en Linux, o puede estar integrada como en Windows.
* Hay 2 técnicas de administración:
    * **Opción 1:** cada vez que se crea un proceso, se reserva una parte del área de swap para él. El tamaño de la misma es igual a lo que ocupa el proceso en su espacio de direcciones (sumado a estructuras de datos necesarias para su mantenimiento como la PCB). El kernel guarda la primera dirección del área reservada, y luego usa el número de página como desplazamiento.
    * **Opción 2:** no se reserva nada inicialmente. A cada página se le asigna un espacio en SWAP cada vez que se baja a SWAP, y se libera cuando se vuelve a cargar en RAM. Requiere de mantener la contabilidad de la ubicación de las páginas en SWAP.
* Direccionamiento:
    * La PTE de una página tiene el bit V, el número de frame y otros bit de control. Cuando una página está en swap, todos los bits excepto por el bit V se vuelven inútiles. Entonces, esos bits restantes se usan para determinar la ubicación de una página en SWAP.
    * En particular, los bits restantes se usan para determinar en qué area de swap está (puede haber muchas en un sistema), y para determinar el “slot” que ocupa dentro de la misma. Un slot es una parte del disco con tamaño igual a una página.

# Entrada / Salida

## Variedad de dispositivos

* Los dispositivos de entrada salida varían en su:
    * Modo de transferencia de datos (por caracter o por bloques)
    * Modo de acceso (secuencial o aleatorio)
    * Sincronización (sincrónico o asincrónico)
    * Modo de compartido (exclusivo o compartido)
        * Determina si 2 procesos pueden usar el mismo dispositivo al mismo tiempo, como a un disco, o no, como a una impresora
    * Velocidad
        * Tienen distintos tiempos, y todos son órdenes de magnitud más lentos que la RAM y la CPU
    * Dirección de E/S
        * Solo lectura, solo escritura o read/write

### Tipos de entrada salida

* Ver anexo

## Responsabilidades del SO (subsistema de E/S)

* Controlar los dispositivos de E/S
    * Generar comandos
    * Manejar interrupciones
    * Manejar errores
* Proporcionar una interfaz de utilización
* Generalidad
    * El subsistema de E/S del kernel debe manejar todos los dispositivos de E/S de una manera uniforme y estandarizada
    * Esto significa ocultar los detalles de bajo nivel a los procesos, para que estos simplemente le manden al kernel instrucciones estandarizadas como “read, write, etc”
* Eficiencia
    * Como los dispositivos de E/S son más lentos que la CPU, se debe aprovechar la CPU ejecutando otro proceso mientras se está esperando una E/S
* Planificación
    * Debe organizar los requerimientos de los distintos dispositivos de manera eficiente. Un ejemplo son los algoritmos de planificación de discos que vemos en la práctica (SCAN, LOOK, etc)
* Buffering
    * Consiste en almacenar los datos en memoria mientras se transfieren
* Caching
    * Mantener en memoria copia de los datos de reciente acceso para mejorar performance
* Spooling
    * Sirve para controlar el acceso concurrente a un dispositivo sin que se pisen los procesos.
    * No se ejecuta en modo kernel
* Reserva de dispositivos
    * Para dispositivos con acceso exclusivo como las impresoras
* Manejo de Errores
    * Administrar errores ocurridos (de lectura, escritura, dispositivo no disponible, etc)
    * Mantiene logs de errores
    * Cada error devuelve un código de error
* Formas de realizar E/S
    * **Bloqueante:** el proceso se suspende hasta que se resuelve la E/S que pidió. Queda en estado waiting hasta que se resuelva el requerimiento.
    * **No bloqueante:** el requerimiento de E/S se retorna en cuanto es posible. El proceso, mientras se atiende el requerimiento, continúa en estado de running. Requiere implementar una manera de checkear si se resolvió la E/S o no.

## Capas de software de E/S

### Software de E/S de capa de usuario (funciones wrappers)

* Como su nombre lo indica, se ejecuta en modo usuario.
* Usa librerías de funciones wrappers, que permiten el acceso a system calls
* Incluye a procesos de apoyo como el spooling

### Software de SO independiente del dispositivo (subsistema de E/S)

* Se ejecuta en modo kernel
* Brinda los principales servicios mencionados en el encabezado anterior, usando las instrucciones de las funciones wrappers y traduciéndolas a instrucciones genéricas
* El kernel debe mantener la información de estado de cada dispositivo
    * Archivos abiertos, conexiones de red, etc.

### Controladores de dispositivos (drivers)

* Se ejecutan en modo kernel
* Contienen el código dependiente del dispositivo específico que manejan
* Traducen los requerimientos abstractos del software de la capa anterior a instrucciones que el dispositivo puede entender.
* Lo desarrollan los creadores del hardware del dispositivo. Lo hacen teniendo en cuenta una API establecida por el SO, implementando instrucciones como read, write, open, etc.
* Como Linux es modular, se le pueden agregar drivers sin modificar el kernel.

### Gestor de interrupciones

* Se ejecuta en modo kernel
* Atiende las interrupciones por hardware
* Resguarda el estado actual y deriva al driver correspondiente.
* Independiente de los drivers

## Flujo de una operación de E/S

## Modo usuario

* Se ejecuta:
    * var archivo = open (“/home/francisco/pepe.txt”)
    * read(archivo)
    * Se envía open (función wrapper) al subsistema de E/S (Software de SO independiente del dispositivo)

## Modo kernel

### Subsistema de E/S

* Recibe la instrucción open con el path del archivo
* ¿Cómo sabe dónde encontrar ese path?
    * Tiene un archivo con la información de los puntos de montaje. Una de sus líneas podría ser:
        * `/home -- sda2 -- rw -- ext4`
    * Como el path empieza con `/home`, ahora el subsistema sabe que está en una partición de lectura y escritura, ext4, en el dispositivo `sda2`.
* ¿Cómo lee un archivo ext4?
    * Le envía read(francisco/pepe.txt) al file system
    * El file system necesita la información del `/dev/sda2`. Le pide eso al subsistema, que a su vez se lo envía a otro módulo (`/dev`). Este último módulo tiene toda la información sobre el disco (rígido/sólido, etc). El subsistema usa esa información para ver a qué driver derivarle la tarea

## Caché de disco

* Su objetivo es minimizar la cantidad de accesos a disco.
* Son un conjunto de áreas de la RAM, que mantienen temporalmente bloques de disco. De esta manera, cuando un proceso los necesita, accede al buffer de la RAM en vez de al disco.
* Dos opciones cuando un proceso intenta acceder a un bloque que está en la caché.
    * Se copia de la caché al espacio de direcciones del proceso (no permite compartir datos).
    * Se trata a la caché como memoria compartida. El área debe ser limitada así que se implementa un algoritmo de reemplazo
        * Generalmente se usa LRU o LFU (LFU reemplaza al que tiene el menor número de referencias). De esta manera se mantienen en memoria los bloques que se están utilizando.

### Buffer caché system V

* Implementación de caché de disco en system V. No todos los sistemas operativos usan esta implementación.
* Es una estructura de datos formada por buffers
* Cada buffer tiene:
    * El **buffer** en sí: el lugar donde se almacena el bloque de disco traído a memoria
    * **Header:** información sobre dicho bloque. Número de bloque, estado, relación con otros buffers, etc.
* Estructura del header:
    * Número de bloque, ID del dispositivo correspondiente al bloque (en qué partición está)
    * Estado (4 posibles)
        * **Free:** el bloque al que apunta se puede utilizar
        * **Busy:** lo está usando un proceso
        * Se está escribiendo o leyendo del disco.
        * **Delayed write:** se modificó el bloque en la caché, pero todavía no se bajó a disco (sucio).
    * Punteros
        * 2 punteros para la hash queue
        * 2 punteros para la free list
        * 1 puntero al bloque en memoria (puntero al buffer en sí)
        * Las 2 listas son doblemente enlazadas (por eso son 2 punteros, uno al siguiente y uno al anterior)
* Listas
    * **Free list:** lista doblemente enlazada de los buffers disponibles. Sirve para buscar un buffer libre para asignarle a un nuevo bloque
        * Se ordena según LRU
        * Los bloques no están necesariamente vacíos. El proceso puede haber terminado, pero que siga en estado de delayed write. Si se busca un buffer libre, y se encuentra uno en estado de delayed write, se manda a escribir ese bloque y se usa el siguiente de la free list. Esto se repite hasta encontrar uno que no esté en delayed write. Cuando se termina de escribir un bloque, vuelven al *inicio* de la free list, no al final.
    * **Hash queue:** colas para optimizar la búsqueda de un buffer en particular. Sirve para determinar si un bloque está o no en caché. Solo están en la hash queue si realmente están en la caché
        * Los headers se organizan según una función de hash f(dispositivo, `#bloque`). Se agrupan los bloques cuyo resultado dio igual en la misma hash queue, para facilitar la búsqueda.
        * Hay tantas hash queues como haya posibles resultados de la función de hashing.
* **Importante:** siempre que se necesita reacomodar estructuras, lo único que realmente se modifican son los punteros. No se intercambian las ubicaciones en memoria realmente.

# File system

## Unidades de asignación

* La unidad de asignación que usa el kernel determina el tamaño mínimo que van a ocupar los datos de un archivo.
    * Por ejemplo, si un archivo tiene 2 bytes de datos, pero la unidad de asignación es un sector de 512B, a esos 2 bytes se le asignarán un sector. Quedarían 510 bytes de fragmentación interna. El archivo ocuparía 512 bytes en la realidad.
* Puede ser un sector de disco, o un cluster (conjunto de sectores consecutivos)
* Ventajas de usar clusters grandes
    * Existen menos unidades que direccionar, por lo que las estructuras de datos como el gestor de espacio libre se vuelven más chicas.
    * Se hace más productivo el tiempo de seek, ya que una búsqueda resulta en traer múltiples sectores a memoria en vez de uno solo. Esto es útil cuando la información está almacenada de manera secuencial y no aleatoria.
* La desventaja de tener clusters más grandes es, como se vio en el ejemplo anterior, que hay más fragmentación interna.

## Formas de asignación

### Pre-asignación

* Al momento de crear un archivo, se le asigna cierto espacio (generalmente mayor a su tamaño esperado).
* Suele usar la forma de asignación continua.
* **Desventaja:** se necesita saber de antemano el tamaño de un archivo

### Asignación dinámica

* El espacio se asigna a medida que se solicita. Pueden quedar archivos almacenados de manera no continua.

### Asignación continua

* En la FAT (*File Allocation Table*) se almacena para cada archivo: número de bloque en donde comienza su almacenamiento, y longitud en bloques. Por ejemplo se podría almacenar:
    * `File A --- Start block 5 --- Length 4`
    * Esto nos dice que el archivo A está almacenado en los bloques 5, 6, 7, y 8.
* **Ventajas:**
    * La FAT es simple, y el archivo se puede leer con solo una operación.
    * Se puede leer el bloque X de un archivo en un solo acceso, ya que solo se hace `bloque_inicio` + X para acceder a él.
* **Desventajas:**
    * **Fragmentación externa**. Si necesito guardar un archivo de 20 bloques, necesito que haya 20 bloques continuos libres. Si existe un conjunto de 19 bloques libres, no se puede usar, y ese espacio queda como fragmentación externa.
    * Requiere de la pre-asignación.
        * Resulta difícil aumentar el tamaño de un archivo si sus bloques consecutivos fueron ocupados por otro. No sirve para sistemas de archivos con alta volatilidad.

### Asignación encadenada

* En la FAT se almacena para cada archivo: número de bloque en donde comienza su almacenamiento, y longitud en bloques.
* En cada bloque, además del contenido del archivo, se almacena un puntero al siguiente bloque.
* **Ventajas:**
    * Útil para acceso secuencial
    * No hay fragmentación externa
    * Los archivos pueden crecer y ser volátiles
    * No se requieren bloques contiguos
        * **Nota**: por temas de optimización, se puede consolidar el disco para que los bloques queden almacenados de manera contigua igualmente, pero no es necesario. Funciona similar a la compactación en la asignación continua.
* **Desventajas:**
    * No sirve para acceso aleatorio. Para acceder a un bloque, se deben acceder a todos sus anteriores.
    * Pierde el principio de localidad espacial, ya que los bloques de un mismo archivo quedan dispersos en el disco.
    * Al almacenar un puntero al siguiente bloque, se pierde un poco de capacidad de almacenamiento en cada bloque.

### Asignación indexada

* En la FAT se almacena para cada archivo, el número de su bloque índice.
* Un bloque índice contiene una lista de punteros a los bloques con el contenido del archivo.
* **Ventajas**:
    * No hay fragmentación externa.
    * Tanto el acceso secuencial como el random son eficientes.
* **Desventajas:**
    * Requiere almacenar un índice para cada archivo. Además, dicho índice se debe leer para acceder al archivo, así que la cantidad de lecturas aumenta en 1.
* Se le pueden agregar niveles de indirección. Es decir, que la FAT apunte a un índice, y que el índice del archivo contenga:
    * Punteros a bloques de datos
    * Punteros a otros índices
        * A su vez, estos podrían tener más índices, aumentando en 1 la indirección cada vez.

#### Asignación indexada por secciones

* A cada entrada del bloque índice se le agrega el campo longitud.
* Por lo tanto, ahora cada entrada del bloque índice apunta a un conjunto de bloques almacenado contiguamente.
* **Ventaja**: mejora la proximidad y achica el índice
* **Desventaja**: reintroduce la fragmentación externa. Si la longitud del conjunto de bloques al que se referencia es de 10, y hay espacios libres continuos de 9, no se pueden usar.

## Gestión de espacio libre

### Tabla de bits

* Es un array que tiene un bit por cada unidad de asignación. Un valor de 0 indica libre, y un valor de 1 indica ocupado.
* **Ventaja:** fácil de encontrar espacio libre, sea continuo o no.
* **Desventaja:** si hay muchas unidades de asignación en el sistema, el arreglo se vuelve muy grande como para cargarlo en la RAM.
    * **Nota:** clusters más grandes ayudan a que esto no pase, ya que implican menos entradas en el vector de bits.

### Bloques libres enlazados

* Cada bloque libre de la memoria tiene un puntero al siguiente bloque libre. Además, se guarda un puntero al primer bloque libre (lista enlazada).
* **Ventaja:** no requiere una estructura de datos adicional
* **Desventajas:**
    * Es difícil de buscar bloques libres continuos.
    * Es poco tolerante a fallos. Si se pierde un enlace, se pierde toda la estructura.
    * Para cada búsqueda de un bloque libre, se requiere un acceso a disco.

### Indexación o agrupamiento

* Es una variante de los bloques libres enlazados.
* El primer bloque libre contiene las direcciones de N bloques libres. La última de estas es una referencia a otro bloque con N direcciones libres.
* **Ventaja**: permite obtener las direcciones de múltiples bloques libres con una sola lectura de disco (al leer el índice).

### Recuento

* Similar al anterior, pero en cada entrada se guarda un puntero a un conjunto de bloques libres.
* Una entrada podría ser: bloque 1, length 8. Esto nos dice que el primer bloque libre es el 1, y que los siguientes 7 también están libres.
* **Ventaja:** achica las estructuras de datos (índices)
* **Desventaja:** es difícil de mantener el recuento