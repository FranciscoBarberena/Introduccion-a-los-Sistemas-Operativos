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
    * **Bit R:** indica si la página fue referenciada desde cierto punto, determinado por el algoritmo usado por el kernel para seleccionar víctimas. Lo manipula el hardware y lo consulta el kernel.
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
* Lo ideal sería seleccionar a aquella página que no volverá a ser utilizada por ningún proceso en el futuro. Esto se denomina algoritmo óptimo, y es únicamente teórico, ya que es imposible predecir con exactitud las páginas que va a a necesitar un proceso. Sin embargo, se desarrollaron distintos algoritmos que intentan aproximarse al óptimo. Estos son: FIFO, 2da Chance, NRU y LRU.

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

