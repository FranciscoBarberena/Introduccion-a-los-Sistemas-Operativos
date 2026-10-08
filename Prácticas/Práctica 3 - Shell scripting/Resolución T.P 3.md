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


 
 