# Práctica 4

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

