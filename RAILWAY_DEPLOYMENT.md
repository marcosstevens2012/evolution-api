# 🚀 Guía de Despliegue en Railway

## 📋 Preparación

### 1. Preparar el Repositorio
```bash
# Asegurar que todos los archivos estén listos
git add .
git commit -m "Preparar para deployment en Railway"
git push origin main
```

### 2. Archivos Creados para Railway
- ✅ `Procfile` - Comando de inicio
- ✅ `railway.json` - Configuración de build
- ✅ `.env.railway` - Variables de entorno para producción

## 🛤️ Despliegue en Railway

### Paso 1: Crear Proyecto en Railway
1. Ve a [railway.app](https://railway.app)
2. Conecta tu cuenta de GitHub
3. Clic en "New Project"
4. Selecciona "Deploy from GitHub repo"
5. Busca y selecciona tu repositorio `evolution-api`

### Paso 2: Agregar PostgreSQL
1. En tu proyecto de Railway, clic en "New Service"
2. Selecciona "Database" → "PostgreSQL"
3. Railway automáticamente creará la variable `DATABASE_URL`

### Paso 3: Agregar Redis (Recomendado)
1. Clic en "New Service" → "Database" → "Redis"
2. Railway automáticamente creará la variable `REDIS_URL`

### Paso 4: Configurar Variables de Entorno

Ve a la pestaña "Variables" de tu servicio y agrega:

#### 🔐 Variables Críticas (CAMBIAR VALORES)
```env
AUTHENTICATION_API_KEY=TU_CLAVE_SUPER_SECRETA_DE_32_CARACTERES_MINIMO
SERVER_URL=https://tu-proyecto.railway.app
CORS_ORIGIN=https://tu-proyecto.railway.app,https://tu-dominio-frontend.com
```

#### 🌐 Variables de Servidor
```env
SERVER_TYPE=https
NODE_ENV=production
```

#### 📊 Variables de Cache
```env
CACHE_REDIS_ENABLED=true
CACHE_REDIS_PREFIX_KEY=evolution_prod
CACHE_REDIS_SAVE_INSTANCES=true
CACHE_LOCAL_ENABLED=false
```

#### 📝 Variables de Logs (Optimizadas)
```env
LOG_LEVEL=ERROR,WARN,INFO,LOG
LOG_COLOR=false
LOG_BAILEYS=error
```

#### ⚙️ Variables de Configuración
```env
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_CLIENT_NAME=evolution_railway
DEL_INSTANCE=300
DEL_TEMP_INSTANCES=true
EVENT_EMITTER_MAX_LISTENERS=100
```

#### 📱 Variables de WhatsApp
```env
WA_BUSINESS_TOKEN_WEBHOOK=evolution_railway
WA_BUSINESS_VERSION=v20.0
WA_BUSINESS_LANGUAGE=es_ES
CONFIG_SESSION_PHONE_CLIENT=Evolution API Railway
QRCODE_LIMIT=30
QRCODE_COLOR=#175197
```

#### 🔗 Variables de WebHooks
```env
WEBHOOK_EVENTS_INSTANCE_CREATE=true
WEBHOOK_EVENTS_INSTANCE_DELETE=true
WEBHOOK_EVENTS_QRCODE_UPDATED=true
WEBHOOK_EVENTS_MESSAGES_UPSERT=true
WEBHOOK_EVENTS_SEND_MESSAGE=true
WEBHOOK_EVENTS_CONTACTS_UPSERT=true
WEBHOOK_EVENTS_CHATS_UPSERT=true
WEBHOOK_EVENTS_CONNECTION_UPDATE=true
WEBHOOK_EVENTS_ERRORS=true
```

#### 🗄️ Variables de Base de Datos
```env
DATABASE_SAVE_DATA_INSTANCE=true
DATABASE_SAVE_DATA_NEW_MESSAGE=true
DATABASE_SAVE_MESSAGE_UPDATE=true
DATABASE_SAVE_DATA_CONTACTS=true
DATABASE_SAVE_DATA_CHATS=true
DATABASE_SAVE_DATA_LABELS=true
DATABASE_SAVE_DATA_HISTORIC=true
DATABASE_SAVE_IS_ON_WHATSAPP=true
DATABASE_SAVE_IS_ON_WHATSAPP_DAYS=7
DATABASE_DELETE_MESSAGE=true
```

#### 🚫 Variables Deshabilitadas (Agregar si necesitas)
```env
TYPEBOT_ENABLED=false
CHATWOOT_ENABLED=false
OPENAI_ENABLED=false
RABBITMQ_ENABLED=false
WEBSOCKET_ENABLED=false
PUSHER_ENABLED=false
S3_ENABLED=false
PROVIDER_ENABLED=false
```

### Paso 5: Deploy
1. Railway automáticamente detectará el `Procfile` y `railway.json`
2. Iniciará el proceso de build y deploy
3. Espera a que termine el deploy (puede tomar 5-10 minutos)

## 🔍 Verificación Post-Deploy

### 1. Verificar Deploy
```bash
curl -X GET https://tu-proyecto.railway.app/instance/fetchInstances \
  -H "apikey: TU_API_KEY"
```

### 2. Logs de Railway
- Ve a la pestaña "Deployments" para ver logs de build
- Ve a la pestaña "Observability" para logs en tiempo real

### 3. Crear Primera Instancia
```bash
curl -X POST https://tu-proyecto.railway.app/instance/create \
  -H "apikey: TU_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "instanceName": "produccion-whatsapp",
    "qrcode": true
  }'
```

## ⚡ Optimizaciones para Railway

### 1. Configuración del Build
Railway ejecutará automáticamente:
```bash
npm ci
npm run db:generate
npm run build
```

### 2. Health Checks
Railway verificará automáticamente que tu app responda en el puerto asignado.

### 3. Escalabilidad
- Railway maneja automáticamente el escalado
- Usa Redis para cachear sesiones entre reinicios

## 🛡️ Seguridad en Producción

### ✅ Lista de Verificación de Seguridad

1. **API Key Fuerte**
   ```env
   AUTHENTICATION_API_KEY=ABC123XYZ789...mínimo32caracteres
   ```

2. **CORS Específico**
   ```env
   CORS_ORIGIN=https://tu-dominio.com,https://app.tu-dominio.com
   ```

3. **HTTPS Forzado**
   ```env
   SERVER_TYPE=https
   ```

4. **Logs Optimizados**
   ```env
   LOG_LEVEL=ERROR,WARN,INFO,LOG
   ```

## 🔧 Comandos Útiles Post-Deploy

### Probar API
```bash
# Reemplaza TU_PROYECTO y TU_API_KEY
export API_URL="https://TU_PROYECTO.railway.app"
export API_KEY="TU_API_KEY"

# Probar conexión
curl -X GET "$API_URL/instance/fetchInstances" -H "apikey: $API_KEY"

# Crear instancia
curl -X POST "$API_URL/instance/create" \
  -H "apikey: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"instanceName": "prod", "qrcode": true}'

# Obtener QR
curl -X GET "$API_URL/instance/connect/prod" -H "apikey: $API_KEY"
```

### Variables de Entorno Locales para Testing
```bash
# Crear .env.production.local para probar contra Railway
SERVER_URL=https://tu-proyecto.railway.app
AUTHENTICATION_API_KEY=tu_api_key_de_railway
```

## 🚨 Troubleshooting

### Error: Build Failed
- Verifica que `railway.json` esté en la raíz
- Asegúrate de que todas las dependencias estén en `package.json`

### Error: App Crashed
- Ve a Railway Logs en tiempo real
- Verifica variables de entorno críticas

### Error: Database Connection
- Verifica que PostgreSQL esté agregado al proyecto
- La variable `DATABASE_URL` debe estar disponible automáticamente

### Error: Redis Connection
- Agrega servicio Redis en Railway
- La variable `REDIS_URL` debe estar disponible automáticamente

## 📱 Manager Web

Una vez desplegado, podrás acceder al manager web en:
```
https://tu-proyecto.railway.app/manager
```

## 💡 Tips de Railway

1. **Custom Domain**: Puedes agregar tu dominio personalizado en Project Settings
2. **Environment Variables**: Se aplican automáticamente sin reinicio
3. **Scaling**: Railway escala automáticamente basado en uso
4. **Metrics**: Monitorea CPU, memoria y red en tiempo real
5. **Rollbacks**: Puedes hacer rollback a deployments anteriores fácilmente

---

🎉 **¡Tu Evolution API estará funcionando en Railway!**

URL de ejemplo: `https://evolution-api-production.railway.app`
