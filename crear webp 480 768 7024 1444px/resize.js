const fs = require('fs');
const path = require('path');
const sharp = require('sharp');

const inputDir = './convertir';
const outputDir = './convertido';
const sizes = [480, 768, 1024, 1440];

// Función para convertir y redimensionar imágenes
function convertToWebPAndJPG(imagePath) {
  const imageName = path.basename(imagePath, path.extname(imagePath)); // Extrae nombre sin extensión

  sizes.forEach(size => {
    const outputWebP = path.join(outputDir, `${imageName}-${size}.webp`);
    const outputJPG = path.join(outputDir, `${imageName}-${size}.jpg`);

    // Crear versión WebP
    sharp(imagePath)
      .resize(size)
      .webp({ quality: 80 })
      .toFile(outputWebP, (err) => {
        if (err) {
          console.error('Error al convertir a WebP:', err);
        } else {
          console.log(`✅ Imagen WebP creada: ${outputWebP}`);
        }
      });

    // Crear versión JPG
    sharp(imagePath)
      .resize(size)
      .jpeg({ quality: 80, mozjpeg: true })
      .toFile(outputJPG, (err) => {
        if (err) {
          console.error('Error al convertir a JPG:', err);
        } else {
          console.log(`✅ Imagen JPG creada: ${outputJPG}`);
        }
      });
  });
}

// Crear directorio de salida si no existe
if (!fs.existsSync(outputDir)){
  fs.mkdirSync(outputDir);
}

// Leer todas las imágenes del directorio
fs.readdirSync(inputDir).forEach(file => {
  const filePath = path.join(inputDir, file);
  if (['.jpg', '.jpeg', '.png'].includes(path.extname(file).toLowerCase())) {
    convertToWebPAndJPG(filePath);
  }
});