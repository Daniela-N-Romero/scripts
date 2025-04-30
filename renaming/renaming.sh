#!/bin/bash

# Pedir el directorio
read -r -p "Ingrese la ruta de la carpeta donde están los archivos: " DIRECTORIO

# convertir formato Windows a formato Bash ---

# Reemplazar "C:\" o "D:\" al inicio por "/c/" o "/d/"
DIRECTORIO=$(echo "$DIRECTORIO" | sed -E 's|^([A-Z]):|/\L\1|')

# Reemplazar las barras invertidas '\' por barras normales '/'
DIRECTORIO=${DIRECTORIO//\\//}

# Mostrar qué ruta final tenemos
echo "Ruta corregida: $DIRECTORIO"

# --------------------------------------------------------------

# Verificar que el directorio existe
if [ ! -d "$DIRECTORIO" ]; then
  echo "Error: El directorio '$DIRECTORIO' no existe."
fi

# Pedir el nombre base
read -p "Ingrese el nombre base para los archivos: " NOMBRE_BASE

# Cambiar al directorio especificado
cd "$DIRECTORIO" || exit

# Contador inicial
contador=1

# Renombrar archivos
for archivo in *; do
  if [ -f "$archivo" ]; then
    extension="${archivo##*.}"
    nuevo_nombre="${NOMBRE_BASE}${contador}.${extension}"

    echo "Renombrando '$archivo' a '$nuevo_nombre'"
    mv "$archivo" "$nuevo_nombre"
    contador=$((contador + 1))
  fi
done

echo "Renombrado completado."
