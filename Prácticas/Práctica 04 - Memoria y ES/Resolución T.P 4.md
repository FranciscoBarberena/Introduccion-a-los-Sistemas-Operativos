# Memoria virtual

## Punto 1

* Las direcciones lógicas que causan fallos de página son: 1052, 2221, 5499 y 3101.
    * 1052 y 2221 corresponden a páginas que no tienen un marco que les corresponda, por lo que la página no está en memoria
    * 5499 y 3101 corresponden a páginas fuera de las mostradas. Por lo que se puede asumir que dichas páginas tendrán el bit de V en 0, y no tendrán un marco correspondiente.

## Punto 2

### Inciso A

* **Asignación fija:** consiste en decidir de antemano cuántas páginas se le va a asignar a cada proceso. Esa cantidad puede ser igual para todos los procesos (reparto equitativo) o dependiente las páginas que requiere (reparto proporcional).
* **Asignación dinámica:** la cantidad de páginas que se le asignan a los procesos no se define de antemano, sino que se decide a medida que el proceso demanda páginas.

### Inciso B

* Usando reparto equitativo, corresponderán 10 marcos para cada proceso (cantidadDeMarcosDisponibles/cantidadDeProcesos)
* Usando reparto proporcional, el proceso es el siguiente:
    * En total, todos los procesos juntos requieren 63 páginas
    * Proceso 1 → requiere 15. 15 es 23,8% de 63. Se le asigna ese porcentaje de páginas (0.238*40 = 9,52 -> 9)
    * Proceso 2 → requiere 20. 20 es 31,6% de 63. Se le asigna ese porcentaje de páginas (0.316*40 = 12,64 -> 12)
    * Proceso 3 → requiere 20. 20 es 31,6% de 63. Se le asigna ese porcentaje de páginas (0.316*40 = 12,64 -> 12)
    * Proceso 4 → requiere 8. 20 es 12,7% de 63. Se le asigna ese porcentaje de páginas (0.127*40 = 5,08 -> 5)
    * Como redondeé para abajo, sobran 2 marcos, que se asignan a los procesos que tuvieron mayor parte decimal en su porcentaje (es decir, que estaban más cerca del siguiente número entero). En este caso se asignaría una página extra al proceso 2 y 3, quedando con 13 cada uno

### Inciso C

* El reparto proporcional resulta más eficiente, porque asigna más páginas a los proceso que más pueden llegar a necesitar, lo que minimiza la probabilidad de un *page fault*.

## Punto 3

### Inciso A

* Ordenados de peor a mejor en cuanto a tasa de fallos de página serían: FIFO, FIFO segunda chance, LRU, OPT (solo teórico)

### Inciso B

* FIFO requiere una estructura de datos (cola), que es fácil de implementar
* LRU requiere un registro de cuándo se referenció por última vez una página.
* FIFO segunda chance requiere de un bit de referenciado R, que se revisa y actualiza a la hora de seleccionar una página víctima.
* OPT no se puede implementar.

### Inciso C

* El kernel puede detectar que una página víctima había sido modificada cuando su bit M=1 en la tabla de páginas. Las acciones que debe tomar el kernel en esta situación son:
    * La nueva página que se desea cargar, se carga en un frame de reserva (descarga asincrónica).
    * Mientras, el kernel baja a SWAP (disco) la página víctima.
    * Una vez que termina, el espacio que ocupaba la página víctima ahora es el nuevo frame de reserva para futuras descargas asincrónicas.

## Punto 7

* Uso de CPU del 13%, uso del dispositivo de paginación del 97%.
    * El sistema está en hiperpaginación. Está gastando más recursos en cargar y descargar páginas que realmente ejecutando los procesos.
    * No, añadir más procesos a la RAM haría el problema aún peor, ya que habría más páginas para cargar y descargar.
    * No, para que sea útil, debería bajarse el grado de multiprogramación.
* Uso de CPU del 87%, uso del dispositivo de paginación del 3%.
    * Los working sets de los procesos entran, en su mayoría, completos en sus marcos asignados en RAM. De esta manera, hay un alto tiempo productivo de CPU, pero suceden pocas cargas y descargas de páginas. Esto implica que los procesos son CPU Bound
    * Sí. Esto haría que el dispositivo de paginación tenga más trabajo, ya que puede que los working sets de los procesos ya no entren en la RAM (porque se redujeron los frames asignados a cada proceso), pero aumentaría el uso del CPU. Además, el dispostivo de paginación actualmente tiene un uso bajo, por lo que se le puede exigir un poco más.
    * Sí. El algoritmo LRU identificó correctamente las páginas que están usando los procesos, y las dejó cargadas en RAM para que hagan un uso intenso de la CPU
* Uso de CPU del 13%, uso del dispositivo de paginación del 3%.
    * Los procesos hacen un uso poco intensivo de la CPU (son I/O bound), y sus working sets entran casi completos en sus marcos asignados de RAM.
    * Sí, el dispositivo de paginación tiene un uso bajo, por lo que se le podría exigir más sin llegar a la hiperpaginación.La CPU está 87% libre así que podría manejar los nuevos procesos sin problema
    * Sí, porque permite alojar los *working sets* de los 4 procesos sin generar sobrecarga de paginación. Aunque sería más útil se se agregaran más procesos.

## Punto 8

* Instalar un procesador más rápido
    * No serviría. El procesador actual solo tiene un uso del 20%, por lo que aumentar la velocidad solo bajaría ese porcentaje aún más.
* Instalar un dispositivo de paginación mayor
    * Asumiendo que “Mayor” significa que resuelve la carga y descarga de páginas más rápidamente, entonces serviría. Se resolverían los page faults más rápidamente, y la CPU tendría más trabajo.
* Incrementar el grado de multiprogramación
    * No serviría. El sistema actualmente está en hiperpaginación, por lo que se tiene que *bajar* el grado de multiprogramación.
* Instalar más memoria principal
    * Esto permitiría que los procesos existentes tengan más páginas en RAM, reduciendo la exigencia en el dispositivo de paginación, y por lo tanto aumentando el uso de la CPU, ya que se producirían menos fallos de página.
* Decrementar el quantum de cada proceso.
    * No serviría. El quantum determina cuándo un proceso se va de la CPU, y en este caso en el que hay thrashing, lo importante es si las páginas que el proceso demanda se encuentran en RAM o no.

## Punto 9

### Inciso A

* Suceden 3 fallos de página cada 4 iteraciones del for interno. El for interno se ejecuta `64*64` veces, por lo que la cantidad total de fallos de página es `(64*64*3)/4 = 3072`
* Podría sumarse también un fallo de página al intentar acceder al código al principio de toda la ejecución, ya que el enunciado menciona que el código (programa) corresponde a un marco.

### Inciso B

* Para mejorar el código, se deberían invertir los ciclos for. El recorrido debería ser por filas en vez de por columnas.
* Con esta solución, suceden 3 fallos de página cada 4 iteraciones del for *externo*. Dicho for se ejecuta 64 veces, por lo que la cantidad de fallos de página sería `(64*3)/4 = 48`

## Punto 10

### Inciso A

* Delta = 5
* WS_A(24) = {4 5 6}
* WS_B(24) = {2 3 6 5}

### Inciso B

* Delta = 5
* WS_A(60) = {1 2 3 4 5}
* WS_B(60) = {3 4 5}

### Inciso C

* Hay 8 frames en el sistema, y el tamaño total de los working sets es 7, todos los working sets entran en memoria.
* Con 6 frames, no entran los WS completos en memoria, por lo que el sistema estaría en hiperpaginación

### Inciso D

* La tasa de fallos de página del proceso A entre los instantes 29 y 38 es de 0,5 (50%).

### Inciso E

* Como la tasa de fallos de página llegó a la cota superior para el proceso A, el kernel entiende que el proceso A necesita más frames. Esto puede resultar en 3 acciones dependiendo de la situación:
    * Si hay frames libres, sin asignar a ningún proceso, se le asignan al proceso A
    * Si no hay frames libres suficientes, lo que hace el kernel es quitarle frames a un proceso que tenga una PFF menor o igual a la cota inferior (0,2), y asignarle esos frames al proceso A.
    * Si no existe ningún proceso con una PFF menor a la cota inferior, se debe reducir el grado de multiprogramación para evitar la hiperpaginación

## Punto 11

### Inciso A

* *Asumiendo que las cotas son límites inclusivos*

* Escenario 1: el kernel debe distribuir los 100 frames libres entre los procesos 3,4,5,6,7 y 8. Si eso no alcanza, deberá quitarle frames al proceso 2. Si eso no alcanza, deberá descargar procesos a SWAP hasta que todos tengan una PFF menor a 0,6.

* Escenario 2: el kernel deberá quitarle frames al proceso 2. Si eso no alcanza, deberá descargar algún proceso a SWAP hasta que todos los procesos tengan una PFF menor a 0,6.

* Escenario 3: el kernel debe distribuir los 150 frames libres entre los procesos 1,2,3,4,5,6,7 y 8. Si eso no alcanza, deberá descargar procesos a SWAP hasta que todos tengan una PFF menor a 0,6.

* Escenario 4: el kernel deberá descargar procesos a SWAP hasta que todos tengan una PFF menor a 0,6.

* Escenario 5: el kernel no debe hacer nada.

* Escenario 6: el kernel no debe hacer nada.

### Inciso B

* *Asumiendo que las cotas son límites inclusivos*

* Escenario 1: el kernel debe distribuir 80 de los 100 frames libres entre los procesos 3,4,5,6,7 y 8. Si eso no alcanza, deberá quitarle frames al proceso 2. Si eso no alcanza, deberá descargar procesos a SWAP hasta que todos tengan una PFF menor a 0,6.

* Escenario 2: el kernel deberá quitarle frames al proceso 2. Si eso no alcanza para todos los procesos y para reservar 20 FL, deberá descargar algún proceso a SWAP hasta que todos los procesos tengan una PFF menor a 0,6.

* Escenario 3: el kernel debe distribuir 130 de los 150 frames libres entre los procesos 1,2,3,4,5,6,7 y 8. Si eso no alcanza, deberá descargar procesos a SWAP hasta que todos tengan una PFF menor a 0,6.

* Escenario 4: el kernel deberá descargar procesos a SWAP hasta que todos tengan una PFF menor a 0,6 y haya 20 frames libres.

* Escenario 5: el kernel no debe hacer nada.

* Escenario 6: el kernel debe quitarle frames a cualquiera de los procesos, priorizando los de menor PFF, hasta llegar a 20 frames libres.

# Administración de discos

## Punto 12

* Un disco rígido está organizado en platos. Cada plato tiene 2 caras, que están separadas en pistas, que a su vez están separadas en sectores.
* Un cilindro son todas las n-ésimas pistas de todas las caras. Como están a la misma distancia del eje de rotación, son las pistas que que las cabezas pueden leer/escribir simultáneamente sin mover el brazo actuador.
* El sector es la unidad mínima de almacenamiento, aunque el kernel puede usar *clusters*, lo que hace que la unidad mínima de trabajo del SO pueda ser mayor a 1 sector.

## Punto 13

* **Seek time:** tiempo que tarda la cabeza en posicionarse en el cilindro. Es el tiempo que mayor influencia tiene sobre la velocidad de transferencia de datos.
* **Latency time:** una vez que la cabeza encuentra la pista, es el tiempo que sucede hasta que el sector a buscar pasa por debajo de la misma. En la materia asumimos que es igual a lo que tarda el disco en dar media vuelta.
* **Transfer time:** tiempo de transferencia del sector (o conjunto de sectores/bloque) del disco a la RAM.

## Punto 17

* SSTF es el único que puede provocar inanición, en el caso de que siempre lleguen requerimientos cercanos a la posición actual, y nunca se atiendan los lejanos.

# Administración de archivos

## Punto 20

* Capacidad en sectores = `10*2*350*500 = 3.500.000`
* Capacidad en clusters de 4 sectores = `3.500.000/4 = 875.000`
* Capacidad en clusters de 8 sectores = `3.500.000/8 = 437.500`

## Punto 21

* Cluster 0 = sectores 120 a 127
* Cluster 123 = `(123*8) + 120 = sectores 1104 a 1111`
* Cluster 299 = `(299*8) + 120 =  sectores 2512 a 2519`
* Cluster 1001 = `(1001*8) + 120 = sectores 8128-8135`

## Punto 22

### Inciso A

* Seek time
    * 10ms
* Latency time
    * 9000 revoluciones → 60.000ms
    * ½ revolución → latency = 3,333ms...
* Transfer time
    * Velocidad es 10MiB/seg
    * 1 cluster = `16 sectores * 512B = 8192B`
    * 10MiB son `1024*1024*10 = 10.485.760B`
    * Proporciones
        * 10.485.760 B → 1000ms
        * 8192B → 0,78125ms
* Tiempo total = `10ms + 0,78125ms + 3,333ms = 14,114583333ms`

### Inciso B

* Seek time
    * 10ms*16 = 160ms
* Latency time
    * 3,333ms * 16 = 53,333…ms
* Transfer time = 0,78125ms
* Tiempo total = `160ms + 53,333ms + 0,78125ms =  214,114583333ms`

### Inciso C

* Aunque la cantidad de información transferida es la misma, el tiempo del caso B es mucho mayor. Esto se debe a que el tiempo de transferencia es despreciable en comparación al tiempo de seek y latencia (especialmente el seek), y tener los sectores distribuidos aleatoriamente hace que se deba hacer un seek por cada sector.

## Punto 23

* Cada partición de un disco tiene un file system, que a su vez contiene:
    * Un bloque de booteo, con el código para bootear el S.O.
    * Un super-bloque, que tiene atributos sobre el file system
    * Un gestor de espacio libre, que a veces está incluido en el super-bloque. Puede usar un vector de bits, bloques libres encadenados o agrupamiento
    * Una tabla de I-NODOS
        * Tiene una entrada por cada posible archivo del sistema. En cada entrada se almacena información sobre ese archivo (tipo, permisos, contador de enlaces, última fecha de modificación del contenido, última fecha de modificación del I-NODO, etc). El nombre no se almacena porque eso se almacena en los directorios (cada directorio tiene un nombre asociado a un I-NODO)
        * También cada I-NODO tiene 13 campos para direcciones a los bloques de datos, tal como se describe en la consigna del siguiente punto (24)
    * Directorio raíz de la partición (punto de montaje)
    * Los datos en sí (archivos, directorios, etc).

## Punto 24

### Inciso B

* Si cada cluster es de 1 KiB y para referenciar un cluster se necesitan 32 bits:
    * En un cluster de 1 KiB entran: `1KiB / 32 bits = 256 direcciones`
* Tamaño máximo de un archivo:
    * Un I-NODO tiene información de un archivo.
    * Tiene 10 punteros a clusters de datos. `10*1KiB = 10KiB`
    * Tiene 1 puntero a un cluster de punteros a datos. `256*1KiB = 256 KiB`
    * Tiene 1 puntero a un cluster de punteros hacia otro cluster de punteros. `256 * 256 * 1KiB = 65.536 KiB`
    * Triple indirección: `256*256*256 * 1KiB = 16.777.216 KiB`
    * Tamaño máximo de un archivo: `10 KiB + 256 KiB + 65.536KiB + 16.777.216 KiB = 16,06 GiB`

## Punto 25

### Inciso A

* En la tabla de tuplas que es el directorio, se agrega una nueva entrada, de la forma: `Archivo1 --> I-NODO`

### Inciso B

* Se modifica el contenido del Archivo1
* Se modifica el I-NODO del Archivo1, ya que se actualiza su última fecha de modificación, y la última fecha de modificación de I-NODO

### Inciso C

* Se modifica la tabla de tuplas del directorio, ahora la entrada del inciso A es: `Archivo2 --> I-NODO (es el mismo que antes)`
* Se actualizan ambas fechas del I-NODO del directorio. 

### Inciso D

* Se modifica el I-NODO de Archivo2 porque aumenta su link count en 1.
* Se agrega una entrada en la tabla de tuplas del directorio: `LinkArchivo2 --> I-NODO (es el mismo, de nuevo)`

### Inciso E

* El link count del I-NODO correspondiente a Archivo3 llegó a 0. El gestor de espacio libre ahora cuenta a ese I-NODO como libre.

## Punto 26

### Inciso A

* Un sector contiene: `512 bytes / 32 bits = 128` direcciones como máximo
* `(10*512 bytes) + (1*128*512 bytes) + (2*128*128*512 bytes) = 16.847.872 bytes`
* Sectores necesarios para cada archivo:
    * Archivo A (55 KiB = 56.320 bytes)
        * Ocupa los 10 sectores referenciados directamente (ocupa 5.120 bytes, quedan 51.200 bytes por almacenar)
        * Del sector referenciado indirectamente de manera simple, que puede tener hasta 65.536 bytes, ocupa solo 51.200 bytes
            * De los 128 sectores, ocupa 100
        * Usa un sector de indirección (+1)
        * Cantidad total de sectores: `10 + 100 + 1 = 111`
        * No utiliza los sectores con direccionamiento indirecto doble
        * Fragmentación interna: 0
    * Archivo B (12 KiB = 12.288 bytes)
        * Ocupa los 10 sectores referenciados directamente (ocupa 5.120 bytes, quedan 7.168 bytes por almacenar)
        * Del sector referenciado indirectamente de manera simple, que puede tener hasta 65.536 bytes, ocupa solo 7.168 bytes
            * De los 128 sectores, ocupa 14
        * Usa un sector de indirección (+1)
        * Cantidad total de sectores: `14 + 10 + 1 = 25`
        * No utiliza los sectores con direccionamiento indirecto doble.
        * Fragmentación interna: 0
    * Archivo C (1075 KiB = 1.100.800 bytes)
        * Ocupa los 10 sectores referenciados directamente (ocupa 5.120 bytes, quedan 1.095.680 bytes por almacenar)
        * Ocupa completamente los 128 sectores referenciado indirectamente de manera simple, (65.536 bytes, quedan 1.030.324 bytes)
        * Usa el primero de los punteros con direccionamiento indirecto doble. Los sectores de este pueden tener hasta 8.388.608 bytes, pero solo se ocupan 1.030.324 bytes.
            * De los 16.384 sectores, ocupa 2012.
        * Usa 17 sectores de indirección simple y 1 de indirección doble (18 en total)
        * Cantidad total de sectores: 128 + 10 + 2013 + 18 = 2168 sectores
        * El último puntero con direccionamiento doble queda sin utilizar.
        * Fragmentación interna: 0
