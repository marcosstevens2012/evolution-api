# Evolution API - Guía de Configuración

Esta guía te ayudará a configurar y ejecutar Evolution API en tu entorno local.

## 🚀 Instalación Rápida

### Opción 1: Script Automático (Recomendado)

```bash
./setup.sh
```

Este script automatizará todo el proceso de configuración.

### Opción 2: Instalación Manual

#### Prerrequisitos

- Node.js 18 o superior
- npm o yarn
- PostgreSQL (local o Docker)
- Redis (opcional, pero recomendado)

#### Pasos

1. **Instalar dependencias:**
   ```bash
   npm install
   ```

2. **Configurar variables de entorno:**
   ```bash
   cp .env.example .env
   # Edita el archivo .env con tus configuraciones
   ```

3. **Configurar base de datos:**
   ```bash
   # Generar cliente de Prisma
   npm run db:generate
   
   # Aplicar migraciones
   npm run db:deploy
   ```

4. **Compilar el proyecto:**
   ```bash
   npm run build
   ```

5. **Iniciar el servidor:**
   ```bash
   # Desarrollo
   npm run dev:server
   
   # Producción
   npm run start:prod
   ```

## 🐳 Docker

### Usar Docker Compose (Más Fácil)

```bash
# Iniciar todos los servicios
docker-compose up -d

# Ver logs
docker-compose logs -f api

# Detener servicios
docker-compose down
```

### Construir imagen personalizada

```bash
# Construir imagen
docker build -t evolution-api .

# Ejecutar contenedor
docker run -d \
  --name evolution-api \
  -p 8080:8080 \
  --env-file .env \
  evolution-api
```

## ⚙️ Configuración

### Variables de Entorno Importantes

#### Servidor
- `SERVER_PORT`: Puerto del servidor (por defecto: 8080)
- `SERVER_URL`: URL base de tu servidor
- `AUTHENTICATION_API_KEY`: Clave API para autenticación

#### Base de Datos
- `DATABASE_PROVIDER`: `postgresql` o `mysql`
- `DATABASE_CONNECTION_URI`: URI de conexión a la base de datos

#### Cache (Redis)
- `CACHE_REDIS_ENABLED`: Habilitar Redis
- `CACHE_REDIS_URI`: URI de conexión a Redis

### Configuración de Base de Datos

#### PostgreSQL (Recomendado)
```env
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_URI=postgresql://user:pass@localhost:5432/evolution?schema=public
```

#### MySQL
```env
DATABASE_PROVIDER=mysql
DATABASE_CONNECTION_URI=mysql://user:pass@localhost:3306/evolution
```

## 🔧 Comandos Útiles

### Desarrollo
```bash
# Servidor en modo desarrollo (recarga automática)
npm run dev:server

# Linting
npm run lint

# Corregir problemas de linting
npm run lint:fix
```

### Base de Datos
```bash
# Generar cliente Prisma
npm run db:generate

# Aplicar migraciones
npm run db:deploy

# Crear nueva migración (desarrollo)
npm run db:migrate:dev

# Abrir Prisma Studio
npm run db:studio
```

### Producción
```bash
# Compilar para producción
npm run build

# Iniciar servidor de producción
npm run start:prod
```

## 📊 Monitoreo y Logs

### Ver Logs
```bash
# Docker
docker-compose logs -f api

# PM2 (si usas PM2)
pm2 logs evolution-api
```

### Configuración de Logs

En el archivo `.env`:
```env
LOG_LEVEL=ERROR,WARN,DEBUG,INFO,LOG,VERBOSE,DARK,WEBHOOKS,WEBSOCKET
LOG_COLOR=true
LOG_BAILEYS=error
```

## 🔗 Integraciones

### Typebot
```env
TYPEBOT_ENABLED=true
TYPEBOT_API_VERSION=latest
```

### Chatwoot
```env
CHATWOOT_ENABLED=true
CHATWOOT_MESSAGE_READ=true
CHATWOOT_MESSAGE_DELETE=true
```

### OpenAI
```env
OPENAI_ENABLED=true
OPENAI_API_KEY_GLOBAL=tu_clave_openai
```

### Webhooks
```env
WEBHOOK_GLOBAL_ENABLED=true
WEBHOOK_GLOBAL_URL=https://tu-servidor.com/webhook
```

## 🔒 Seguridad

### API Key
Cambia la API key por defecto:
```env
AUTHENTICATION_API_KEY=tu_clave_super_secreta
```

### CORS
Configura los orígenes permitidos:
```env
CORS_ORIGIN=https://tu-frontend.com,https://otro-dominio.com
```

### SSL (Producción)
```env
SERVER_TYPE=https
SSL_CONF_PRIVKEY=/path/to/private.key
SSL_CONF_FULLCHAIN=/path/to/fullchain.pem
```

## 🌐 Uso de la API

### Crear una instancia
```bash
curl -X POST http://localhost:8080/instance/create \
  -H "apikey: B6D711FCDE4D4FD5936544120E713C81" \
  -H "Content-Type: application/json" \
  -d '{
    "instanceName": "mi-instancia",
    "qrcode": true
  }'
```

### Obtener QR Code
```bash
curl -X GET http://localhost:8080/instance/connect/mi-instancia \
  -H "apikey: B6D711FCDE4D4FD5936544120E713C81"
```

### Enviar mensaje
```bash
curl -X POST http://localhost:8080/message/sendText/mi-instancia \
  -H "apikey: B6D711FCDE4D4FD5936544120E713C81" \
  -H "Content-Type: application/json" \
  -d '{
    "number": "5521999999999",
    "text": "¡Hola desde Evolution API!"
  }'
```

## 🐛 Solución de Problemas

### Error de conexión a la base de datos
1. Verifica que PostgreSQL esté ejecutándose
2. Confirma las credenciales en `DATABASE_CONNECTION_URI`
3. Ejecuta `npm run db:generate` y `npm run db:deploy`

### Error "Cannot find module"
```bash
rm -rf node_modules package-lock.json
npm install
```

### Puerto ya en uso
```bash
# Cambiar puerto en .env
SERVER_PORT=8081

# O matar proceso que usa el puerto
sudo lsof -ti:8080 | xargs kill -9
```

### Problemas con Baileys
```bash
# Limpiar cache de instancias
rm -rf instances/*

# Reiniciar servidor
npm run dev:server
```

## 📚 Documentación Adicional

- [Documentación oficial](https://doc.evolution-api.com)
- [Colección de Postman](https://evolution-api.com/postman)
- [Discord Community](https://evolution-api.com/discord)
- [WhatsApp Group](https://evolution-api.com/whatsapp)

## 🤝 Soporte

Si encuentras problemas:

1. Revisa esta guía y la documentación oficial
2. Busca en los issues de GitHub
3. Únete a la comunidad en Discord
4. Crea un nuevo issue si es necesario

## 📄 Licencia

Evolution API está licenciado bajo Apache License 2.0 con condiciones adicionales. Ver [LICENSE](LICENSE) para más detalles.
