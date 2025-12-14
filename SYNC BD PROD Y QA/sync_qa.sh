#!/bin/bash
# --- CONFIGURACIÓN --
FECHA=$(date +%F)
BACKUP_PATH="/home/msgrupo/backups/db"
ARCHIVO_BACKUP="$BACKUP_PATH/backup_prod_$FECHA.sql"
# Colores para mensajes (para que se vea pro)
VERDE='\033[0;32m'
NC='\033[0m' # No Color
echo -e "${VERDE}=== INICIANDO SINCRONIZACIÓN PROD -> QA ===${NC}"
# 1. Crear carpeta de backups si no existe
mkdir -p $BACKUP_PATH
# 2. Hacer Backup de Producción
echo -e "${VERDE}[1/5] Creando Backup de Producción...${NC}"
# Usamos -h localhost para evitar el error de autenticación Peer
pg_dump -h localhost -U msgrupo_user -d msgrupo_db > $ARCHIVO_BACKUP
if [ $? -eq 0 ]; then
echo "Backup creado exitosamente: $ARCHIVO_BACKUP"
else
echo "Error al crear el backup. Abortando."
exit 1
fi
# 3. Borrar y Recrear DB de QA
echo -e "${VERDE}[2/5] Reiniciando Base de Datos de QA...${NC}"
# Usamos sudo -u postgres para tener permisos de DROP/CREATE sin contraseña
sudo -u postgres psql <<EOF
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'msgrupo_db_QA';
DROP DATABASE "msgrupo_db_QA";
CREATE DATABASE "msgrupo_db_QA" OWNER "msgrupo_user";
EOF
# 4. Restaurar Datos en QA
echo -e "${VERDE}[3/5] Restaurando datos en QA...${NC}"
psql -h localhost -U msgrupo_user -d msgrupo_db_QA < $ARCHIVO_BACKUP
# 5. Sincronizar Imágenes (Rsync)
echo -e "${VERDE}[4/5] Sincronizando imágenes...${NC}"
rsync -av --progress ~/app/backend/uploads/ ~/app-qa/backend/uploads/
# 6. Reiniciar Apps (Opcional, descomentar si es necesario)
# echo -e "${VERDE}[5/5] Reiniciando servidor QA...${NC}"
# pm2 restart all
echo -e "${VERDE}=== ¡LISTO! QA ESTÁ SINCRONIZADO ===${NC}"