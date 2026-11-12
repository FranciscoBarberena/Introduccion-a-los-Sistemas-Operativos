# Práctica 3

## Punto 1

* Un *shell script* es un programa que está escrito en un lenguaje que la terminal de comandos entiende directamente. Están orientados a tareas como:
    * Automatización de tareas.
    * Aplicaciones interactivas.
    * Manejo de archivos de manera rápida.
    * Entre otras
* No requieren compilarse, porque su ejecución se hace línea por línea. A medida que el intérprete lee cada comando, se comunica con el kernel para ejecutar esa acción en tiempo real. No hay una fase previa en la que se analice el programa completo para ver si tiene errores.

## Punto 2

* **echo:** se utiliza para imprimir texto o el contenido de variables en la salida estándar (la pantalla de la terminal). Su comportamiento por defecto es tomar todos los argumentos que se le pasen, separarlos por un espacio, imprimirlos y agregar un salto de línea automático al final. El parámetro -n omite dicho salto de línea.
* **read:** captura la información ingresada por el usuario desde la entrada estándar (el teclado) y la asigna a una o más variables para que el script pueda utilizarla. Al ejecutarse, pausa por completo la ejecución del script y se queda esperando hasta que el usuario presione la tecla Enter. Algunos parámetros son:
    * -p (Prompt): Permite definir un mensaje de texto que se mostrará justo antes del cursor, en la misma línea.
    * -s (Silent): Oculta los caracteres a medida que el usuario los teclea en la terminal. Es útil para contraseñas
    * -r (Raw): Obliga a *read* a tomar el texto exactamente como se escribió, evitando que la barra invertida (`\`) sea procesada como un carácter de escape.

### Inciso A

* Los comentarios se indican con un `#`.

### Inciso B

* Las variables se declaran como:
```
nombre_string="Pepe"
arreglo=(elemento1 elemento2)
```
* Para hacer referencia a ellas, se usa el símbolo $. Por ejemplo: `echo ${nombre_string}`. Las llaves sirven para que sea menos ambiguo el *script*

## Punto 4

* Para acceder a los parámetros de un *script*, se usa $1, $2, etc. Por ejemplo: si yo llamo al script `./mostrar.sh Pepe Hola`, y en el script se hace echo $1, se imprimirá “Pepe”
* Variables especiales:
    * $#: contiene la cantidad de parámetros enviados
    * $*: contiene una lista del contenido de los parámetros enviados, separados por espacio (ej: Pepe Hola)
    * $?: contiene la salida del último comando ejecutado (0 indica éxito, positivo indica error)
    * $HOME: contiene el directorio personal del usuario que ejecutó el script

## Punto 5

* El comando `exit` sirve para indicar que terminó de ejecutarse un script. Tiene un parámetro que indica el estado del script que acaba de terminar (0 es éxito, 1-255 es error)

## Punto 6

| **Tipo de Operador**  | **Ejemplos**                         | **¿Qué devuelve?**                             | **Razón / Comportamiento**                                                                                                                                 |
| --------------------- | ------------------------------------ | ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Aritméticas**       | `+`, `-`, `\*`, `/`, `%`             | **El resultado matemático entero**             | Ejecuta la operación numérica solicitada. Si es una división (`/`), descarta automáticamente los decimales. `%` es el módulo                                                |
| **Cadenas (Strings)** | `length`, `substr`, `index`, `match` | **El texto procesado o un número de posición** | Extrae subcadenas (`substr`), cuenta la cantidad de caracteres (`length`) o busca la posición exacta de una letra/patrón (`index`, `match`).               |
| **Comparaciones**     | `=`, `!=`, `\>`, `\<`, `\>=`, `\<=`  | **`1`** (Verdadero) o **`0`** (Falso)          | No hay un valor útil que retornar más que la simple confirmación de si la condición matemática o de texto se cumple o no.                                  |
| **Lógicos**           | `\|` (OR)                | **`arg1`** o **`arg2`**                        | \| (OR Lógico): Evalúa arg1 \| arg2. Si el primer argumento no es nulo ni cero, devuelve `arg1` -->. Si es cero, devuelve devuelve `arg2`. (Ej: expr 0 \| 8 imprime 8).  |
| **Lógicos**           | `\&` (AND)                | **`arg1`** o 0                        | \& (AND Lógico): Evalúa arg1 \& arg2. Si ninguno de los dos argumentos es nulo o cero, devuelve `arg1`. Si alguno de los dos es cero, devuelve 0. (Ej: expr 5 \& 0 imprime 0).  |

## Punto 7

* Condiciones de strings: se usan los operadores de comparación y de Cadenas de la tabla anterior
* Condiciones de números: se reemplaza = por -eq, < por -lt, etc
* Condiciones para archivos:
| **Operador**                 | **Condición (Devuelve Verdadero si...)**                                          |
| ---------------------------- | --------------------------------------------------------------------------------- |
| **`-e`** (*exists*)          | El archivo existe, sin importar si es regular, carpeta o dispositivo.             |
| **`-f`** (*file*)            | Existe y es un **archivo regular** (no una carpeta ni un dispositivo especial).   |
| **`-d`** (*directory*)       | Existe y es un **directorio**.                                                    |
| **`-L`** o **`-h`** (*link*) | Existe y es un **enlace simbólico** (*soft link*).                                |
|  -----------------------  |                   -----------------------------------------------------------------------------------                   |
| ----------------------- | ----------------------------------------------------------------------------------- |
| **`-w`** (*writable*)   | El usuario actual tiene permiso de **escritura**.                                   |
|   **`-r`** (*readable*)  |                     El usuario actual tiene permiso de **lectura**.                     |
| **`-x`** (*executable*) | El usuario actual tiene permiso de **ejecución** (o de acceso si es un directorio). |
| **`-s`** (*size*)  | El archivo existe y **no está vacío** (su tamaño es mayor a 0 bytes).   |
| ------------------ | ----------------------------------------------------------------------- |
| **`-O`** (*owner*) | El usuario actual es el propietario real del archivo.                   |
| **`-G`** (*group*) | El grupo primario del usuario actual coincide con el grupo del archivo. |
|  |                                 |
| ------------------------------- | ------------------------------------------------------------------------------------------------- |
| **`archivo1 -ot archivo2`** (*older than*) | `archivo1` es **más antiguo** que `archivo2`.                                                           |
| **`archivo1 -ef archivo2`** (*equal file*) | Ambos archivos apuntan al **mismo i-nodo** y dispositivo físico (es decir, son enlaces duros entre sí). |
|   **`archivo1 -nt archivo2`** (*newer than*)   |         `archivo1` es **más reciente** (su `mtime` es posterior) que `archivo2`.        |

## Punto 8

### IF
```
if [ condition ]
then
    bloque
elif [ condition ]
then
    bloque
else
bloque
fi
```

### Case
```
case $variable in
"valor 1")
    bloque
    ;;
"valor 2")
    bloque
    ;;
*)
    bloque
    ;;
esac
```
### Select
```
select variable in opcion1 opcion2 opcion3
do
    # en $variable está el valor elegido
    bloque
done
```
### While
```
while [ condicion ] # Mientras se cumpla la condición
do
    bloque
done
```
* Opción repeat until
```
until [ condition ] # Mientras NO se cumpla la condición
do
    bloque
done
```
### For
```
for ((i=0; i < 10; i++))
do
    bloque
done
```
* Opción for each
```
for i in valor1 valor2 valor3 valorN
do
    bloque
done
```

## Punto 9

* *Break* hace que se termine un bucle
* *Continue* hace que se pase a la siguiente iteración del bucle
* Reciben un parámetro opcional `n`, que sirve para detallar la profundidad del bucle que se quiere cortar/saltear
* Es decir, si hay 2 for anidados, y dentro del for interno hay un break 2, se termina el bucle externo. Si se pusiese un continue 2, se pasaría a la siguiente iteración del bucle externo

## Punto 10

* Las variables pueden almacenar strings o arreglos
* El lenguaje no es fuertemente tipado, se puede asignar un string a una variable y luego un arreglo a esa misma variable
* Para definir un arreglo se hace:
    * arreglo=(1 2 3 4)

## Punto 11

* Sí, pueden definirse funciones en un script de la siguiente manera:

`function nombre { bloque }`

* Devuelven un valor entre 0 y 255 con return (misma lógica que exit).
* Reciben argumentos posicionales en las variables $1, $2, etc. Mientras se ejecuta la función, no se pueden acceder a los parámetros del script en sí.
* Se pueden declarar variables locales con la palabra clave *local*
* Las variables de entorno, como $HOME, pueden ser accedidas por cualquier script hijo del script original, ya que cada uno recibe una copia de la misma. Para transformar una variable normal en una de entorno, que hereden los hijos, se hace `export variable`
* Ejemplo: en el script `miScript.sh` se ejecuta:
    * mi_variable="Hola"
    * export mi_entorno="Mundo"
    * ./script_hijo.sh
    * Ahora se ejecuta el script hijo y hace:
        * echo $mi_variable # NO HACE NADA, porque esa variable era local al script
        * echo $mi_entorno # Imprime “Mundo”. Importantemente, si el script hijo modifica la variable, no se modifica en el padre, porque se pasa una copia.

