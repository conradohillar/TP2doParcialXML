# TPE XML - 2C2023 - Grupo 13

## IMPORTANTE
El script tpe.sh borra todos los archivos de extension .xml en el directorio en el cual es ejecutado. Es recomendado solo ejecutar el mismo dentro de la carpeta del repositorio de GitHub. Esto es para una reutilizacion del programa mas eficiente y para evitar errores de sobreescritura de archivos de linux.

## Setup

#### API_KEY
Reemplazar key con api key obtenida. Ejecutar en terminal de bash antes de utilizar el script tpe.sh.
```bash
export API_KEY=key
```

#### PARSER
Se debe instalar el parser de xQuery y XSLT con Java. Se debe agregar saxon9he.jar a la variable de entorno 
CLASSPATH. [Descarga](https://sourceforge.net/projects/saxon/files/Saxon-HE/9.5/SaxonHE9-5-1-8J.zip/download)

## Metodo de utilizacion
Ejecutar en el directorio del proyecto donde se encuentra este README
```bash
./tpe.sh NAME YEAR
```