#!/bin/bash

# Pedir el DIR_IMAGES
read -r -p "Ingrese la ruta de la carpeta donde están los archivos: " DIR_IMAGES

# convertir formato Windows a formato Bash ---

# Reemplazar "C:\" o "D:\" al inicio por "/c/" o "/d/"
DIR_IMAGES=$(echo "$DIR_IMAGES" | sed -E 's|^([A-Z]):|/\L\1|')

# Reemplazar las barras invertidas '\' por barras normales '/'
DIR_IMAGES=${DIR_IMAGES//\\//}

# # Mostrar qué ruta final tenemos
# echo "Ruta corregida: $DIR_IMAGES"

# --------------------------------------------------------------

# Verificar que el DIR_IMAGES existe
if [ ! -d "$DIR_IMAGES" ]; then
  echo "Error: El DIR_IMAGES '$DIR_IMAGES' no existe."
fi

# Verificar si el DIR_IMAGES existe
if [ ! -d "$DIR_IMAGES" ]; then
    echo "El DIR_IMAGES no existe. Por favor, verifica la ruta."
    # exit 1
fi

# Solicitar al usuario que ingrese el texto alt para las imágenes
read -p "Ingresa el texto alt para las imágenes: " ALT_TEXT

# Solicitar al usuario que ingrese el nombre del archivo de salida
read -p "Ingresa el nombre del archivo de salida (por ejemplo, 'imagenes.txt'): " OUTPUT_FILE

# Verificar si el archivo tiene la extensión .txt, si no, agregarla
if [[ ! "$OUTPUT_FILE" =~ \.txt$ ]]; then
    OUTPUT_FILE="$OUTPUT_FILE.txt"
fi

# Crear o vaciar el archivo de salida
> "$OUTPUT_FILE"

# Contador para las imágenes
count=1

# Recorrer todos los archivos de imagen con extensiones .webp, .jpg, .png, .jpeg
shopt -s nullglob  # Asegurar que el bucle no falle si no hay imágenes
for img in "$DIR_IMAGES"/*.{webp,jpg,jpeg,png}; do
    # Verificar si el archivo realmente existe (para evitar errores si no se encuentran imágenes)
    if [ -e "$img" ]; then
        # Obtener solo el nombre del archivo (sin la ruta completa)
        img_name=$(basename "$img")
        
        # Crear la cadena de texto para cada imagen
        printf 'img%d:%s,alt:%s;' "$count" "$img_name" "$ALT_TEXT" >> "$OUTPUT_FILE"
        
        # Incrementar el contador
        count=$((count + 1))
    fi
done

# Mensaje de éxito
echo "Cadena de imágenes generada en $OUTPUT_FILE"