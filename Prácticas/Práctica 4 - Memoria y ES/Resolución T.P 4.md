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

* Seek time: tiempo que tarda la cabeza en posicionarse en el cilindro. Es el tiempo que mayor influencia tiene sobre la velocidad de transferencia de datos.
* Latency time: una vez que la cabeza encuentra la pista, es el tiempo que sucede hasta que el sector a buscar pasa por debajo de la misma. En la materia asumimos que es igual a lo que tarda el disco en dar media vuelta.
* Transfer time: tiempo de transferencia del sector (o conjunto de sectores/bloque) del disco a la RAM.

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

* Aunque la cantidad de información transferida es la misma, el tiempo del caso B es mucho mayor. Esto se debe a que el tiempo de transferencia es despreciable en comparación al tiempo de seek (y, en un menor grado, la latencia), y tener los sectores distribuidos aleatoriamente hace que se deba hacer un seek por cada sector.