# Práctica 2

## Punto 1

### Inciso A

* Todos los siguientes son algoritmos para seleccionar un proceso de la cola de listos, para que este se empiece a ejecutar en el CPU.
* **FCFS** (*First Come First Served*)
    * Selecciona al primer proceso que llegó a la cola de listos.
    * No es apropiativo.
* **SJF** (*Shortest Job First*)
    * Selecciona al proceso con menor tiempo estimado de su próxima ráfaga CPU. Para estimar el tiempo necesario, se utiliza la ejecución previa de dicho proceso.
    * Tiene versiones apropiativas y no apropiativas
* **RR** (*Round Robin*)
    * Utiliza un contador. Determina de antemano un valor llamado *Quantum* que luego utiliza para asignar tiempo de CPU a los procesos.
    * Por ejemplo, con un *Quantum* de 2, el algoritmo va a tomar el primer proceso en la cola FIFO de listos. Le va a asignar 2T de CPU a dicho proceso, y luego lo manda al final de la fila. Continúa haciendo esto con todos los procesos, siempre asignándoles 2T de CPU.
    * Es apropiativo
* **Prioridades**
    * Se pueden aplicar a cualquier algoritmo. Es un valor numérico que hace que, si un proceso tiene mayor prioridad que otro, siempre se ejecutará en su lugar, luego, el segundo criterio es el propio de cada algoritmo (FIFO, SJF, etc).

 ### Inciso B

* ???

### Inciso C

* FCFS no beneficia a ningún tipo de proceso. Aunque hay que destacar que, todos los procesos *CPU bound* van a poder ejecutarse en una sola ráfaga, mientras que los I/O bound van a dejar de ser ejecutados cuando pidan una entrada/salida, y luego son mandados al final de la cola
* SJF beneficia a aquellos procesos denominados *I/O bound*, ya que la “próxima ráfaga” de los procesos *CPU bound* va a ser, normalmente más larga, ya que no tiene interrupciones.
* RR beneficia a los procesos *CPU bound*, por lo que ilustra este ejemplo:
    * Si se tiene un *Quantum* de 10, se le asignan 10T de CPU a un proceso *I/O bound*
    * El proceso usa 1T, pero ahora requiere de una entrada/salida.
        * En este momento, el proceso no pudo usar los 9T restantes de CPU que le quedaban, y vuelve al final de la cola circular del *Round Robin*.
    * La solución es el Virtual Round Robin.
* En cuanto a los SO, los sistemas operativos de uso general, como *Windows* o *Linux-Ubuntu* se benefician de algoritmos apropiativos como *Round Robin*, ya que el cambio rápido entre procesos permite dar la ilusión de simultaneidad. En cambio, los no apropiativos ???

### Inciso D

* Ventajas de FCFS
    * Es fácil de implementar.
    * No sufre de inanición.
* Ventajas de RR
    * No sufre de inanición.
    * Minimiza el tiempo de respuesta.
* Ventajas de SJF
    * Beneficia a los procesos *I/O bound*.
    * Minimiza el tiempo de espera.
* Ventajas de prioridades
    * Permite que se ejecuten antes los procesos de mayor urgencia.

### Inciso E

* **Tiempo de retorno**: Es el tiempo desde que un proceso entra a la CPU, hasta que termina de ejecutarse.
* **Tiempo de espera**: Dentro del tiempo de retorno, es el subconjunto de tiempo en el que el proceso no hizo uso de la CPU. (Tiempo de retorno - tiempo de CPU = tiempo de espera).

### Inciso F

* En un lote (conjunto) de procesos, el tiempo promedio de retorno se calcula sumando los TR de cada proceso del lote, y dividiendo por la cantidad de procesos en el lote. Lo mismo aplica para el tiempo promedio de espera.

### Inciso G

* El tiempo de respuesta de un proceso es el intervalo de tiempo que ocurre desde que un proceso llega a la cola de listos hasta que se le asigna la CPU por primera vez.

## Punto 6

### Inciso A

* La inanición o *starvation* es algo que le sucede a un proceso, cuando por cuestiones del algoritmo de planificación, nunca logra ejecutarse. Por ejemplo, en un algoritmo de prioridades, si constantemente llegan procesos de alta prioridad, nunca se seleccionarían los de baja prioridad.

### Inciso B

* Cualquier algoritmo con prioridades, y además SJF/SRTF.

### Inciso C

* Sí, la solución se denomina *aging*, y consiste en subirle la prioridad a los procesos que han estado mucho tiempo en la cola de listo sin ejecutarse.

## Punto 8

### Inciso A

* En el Round Robin, el problema surge con los procesos *I/O bound*. Cuando se tiene en situaciones como la siguiente:
    * Quantum = 10
    * Proceso 4 necesita hacer 1U de CPU, esperar una I/O, y luego hacer los otros 9U
    * Cuando el proceso 4 es elegido por el planificador de la cola ready, se le asigna un quantum de 10 (como a todos los procesos). Sin embargo, luego de usar 1U de CPU, debe esperar la I/O, y cuando termine de eso, va a volver **al final de la cola circular del round robin**. Esto significa que hubo 9U del quantum las cuales el proceso no pudo usar.

### Inciso B

* En el SRTF, el problema surge con los procesos con alto uso de CPU (*CPU bound*)
* Como el algoritmo selecciona al proceso cuya próxima ráfaga de CPU sea la más corta, los proceso que hacen un uso intensivo de la CPU se ven perjudicados. En un ejemplo extremo, un proceso que dura 50U y usa exclusivamente CPU, va a tener su próxima ráfaga con un valor de 50. Al ser un valor alto, es probable que el algoritmo nunca elija al proceso para que sea asignado a la CPU (o tarde mucho en hacerlo). Además, como el algoritmo es apropiativo, es probable que una vez que sea elegido, sea rápidamente expulsado por el sistema operativo.

## Punto 10

* Una de las maneras de que el quantum nunca llegue a 0 con un sistema VRR, es que el proceso termine por completo luego de usar una cantidad de ciclos de CPU que sea menor al quantum. Por ejemplo:
    * Se le asigna *quantum* de 10U al proceso 4, que necesita 7U de CPU para su ejecución completa.
    * El proceso 4 usa 2U de CPU.
    * Necesita I/O, la usa y luego va a la cola auxiliar.
    * Vuelve a la CPU.
    * Usa 5U de CPU, quedó con un quantum de 3.
    * Listo, el proceso terminó y su *quantum* no llegó a 0.
    * Si el proceso del ejemplo anterior necesitase de 11U para terminar, esto ya no aplicaría. En algún momento va a volver de la cola auxiliar, y va a agotar su quantum por completo. Le va a quedar 1U pendiente cuando vuelva a la cola estándar.
* Otra manera, teniendo en cuenta la interrupción por *clock* mencionada en el enunciado, es la siguiente
    * El sistema operativo decrementa el *quantum* cada tick de reloj, que sucede cada cierta unidad de tiempo, por ejemplo 10ms.
    * El proceso 4 es elegido para usar la CPU, se le asigna un *quantum* de 10
    * Usa la CPU por 8ms
        * Como no pasaron los 10ms necesarios para un tick del reloj, su *quantum* nunca se decrementó, sigue en 10.
    * Pide una I/O
    * Termina la I/O y vuelve a la cola auxiliar. Sigue teniendo el *quantum* en 10.
    * Es elegido para la CPU, se le asigna su quantum restante, que sigue siendo 10.
    * Esto podría repetirse y que el *quantum* nunca llegue a 0.
