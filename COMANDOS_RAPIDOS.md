# Evolution API - Comandos Rápidos

## Configuración Inicial Completada ✅

Tu Evolution API está ahora configurado y funcionando correctamente.

### 🚀 Estado del Servidor
- **URL**: http://localhost:8080
- **API Key**: `B6D711FCDE4D4FD5936544120E713C81`
- **Base de Datos**: PostgreSQL (local)
- **Cache**: Local (sin Redis)

### 📋 Comandos de Gestión

#### Iniciar/Detener Servidor
```bash
# Modo desarrollo (con recarga automática)
npm run dev:server

# Modo producción
npm run start:prod

# Detener servidor
Ctrl + C
```

#### Base de Datos
```bash
# Generar cliente Prisma
npm run db:generate

# Aplicar migraciones
npm run db:deploy

# Abrir Prisma Studio (interfaz web)
npm run db:studio
```

#### Compilación
```bash
# Compilar proyecto
npm run build

# Linting
npm run lint
npm run lint:fix
```

### 🔌 Comandos de API

#### 1. Crear Instancia de WhatsApp
```bash
curl -X POST http://localhost:8080/instance/create \
  -H "apikey: B6D711FCDE4D4FD5936544120E713C81" \
  -H "Content-Type: application/json" \
  -d '{
    "instanceName": "mi-whatsapp",
    "qrcode": true
  }'
```

#### 2. Obtener QR Code
```bash
curl -X GET http://localhost:8080/instance/connect/mi-whatsapp \
  -H "apikey: B6D711FCDE4D4FD5936544120E713C81"
```

#### 3. Listar Instancias
```bash
curl -X GET http://localhost:8080/instance/fetchInstances \
  -H "apikey: B6D711FCDE4D4FD5936544120E713C81"
```

#### 4. Enviar Mensaje de Texto
```bash
curl -X POST http://localhost:8080/message/sendText/mi-whatsapp \
  -H "apikey: B6D711FCDE4D4FD5936544120E713C81" \
  -H "Content-Type: application/json" \
  -d '{
    "number": "5521999999999",
    "text": "¡Hola desde Evolution API!"
  }'
```

#### 5. Enviar Imagen
```bash
curl -X POST http://localhost:8080/message/sendMedia/mi-whatsapp \
  -H "apikey: B6D711FCDE4D4FD5936544120E713C81" \
  -H "Content-Type: application/json" \
  -d '{
    "number": "5521999999999",
    "media": "https://example.com/imagen.jpg",
    "caption": "Imagen de prueba"
  }'
```

#### 6. Obtener Información de la Instancia
```bash
curl -X GET http://localhost:8080/instance/connectionState/mi-whatsapp \
  -H "apikey: B6D711FCDE4D4FD5936544120E713C81"
```

#### 7. Eliminar Instancia
```bash
curl -X DELETE http://localhost:8080/instance/delete/mi-whatsapp \
  -H "apikey: B6D711FCDE4D4FD5936544120E713C81"
```

### 🌐 Interfaz Web

La API incluye una interfaz web de gestión accesible en:
- **URL Manager**: http://localhost:8080/manager
- **Documentación**: http://localhost:8080/docs (si está habilitada)

### 📊 Logs y Monitoreo

#### Ver logs en tiempo real
```bash
# Si usas el modo desarrollo
# Los logs aparecerán directamente en la terminal

# Si usas PM2
pm2 logs evolution-api

# Si usas Docker
docker-compose logs -f api
```

#### Configurar nivel de logs
En el archivo `.env`, modifica:
```env
LOG_LEVEL=ERROR,WARN,DEBUG,INFO,LOG,VERBOSE,DARK,WEBHOOKS,WEBSOCKET
LOG_COLOR=true
LOG_BAILEYS=error
```

### 🔧 Configuración Avanzada

#### Habilitar Webhooks
```env
WEBHOOK_GLOBAL_ENABLED=true
WEBHOOK_GLOBAL_URL=https://tu-servidor.com/webhook
```

#### Habilitar Redis (recomendado para producción)
```env
CACHE_REDIS_ENABLED=true
CACHE_REDIS_URI=redis://localhost:6379/6
CACHE_LOCAL_ENABLED=false
```

#### Configurar SSL (HTTPS)
```env
SERVER_TYPE=https
SSL_CONF_PRIVKEY=/path/to/private.key
SSL_CONF_FULLCHAIN=/path/to/fullchain.pem
```

### 🐳 Docker (Alternativo)

Si prefieres usar Docker:
```bash
# Iniciar todos los servicios
docker-compose up -d

# Ver logs
docker-compose logs -f api

# Detener servicios
docker-compose down
```

### ⚠️ Importante para Producción

1. **Cambia la API Key**: 
   ```env
   AUTHENTICATION_API_KEY=tu_clave_super_secreta_y_larga
   ```

2. **Configura CORS correctamente**:
   ```env
   CORS_ORIGIN=https://tu-dominio.com,https://otro-dominio.com
   ```

3. **Habilita HTTPS** para usar en producción

4. **Configura Redis** para mejor rendimiento

5. **Configura un proxy reverso** (nginx, apache) si es necesario

### 🆘 Solución de Problemas

#### Error de conexión a la base de datos
```bash
# Verificar que PostgreSQL esté ejecutándose
brew services list | grep postgresql

# Recrear base de datos si es necesario
dropdb evolution
createdb evolution
npm run db:deploy
```

#### Puerto ocupado
```bash
# Cambiar puerto en .env
SERVER_PORT=8081

# O matar proceso que usa el puerto
sudo lsof -ti:8080 | xargs kill -9
```

#### Problemas con dependencias
```bash
rm -rf node_modules package-lock.json
npm install
npm run build
```

### 📚 Recursos Adicionales

- **Documentación Oficial**: https://doc.evolution-api.com
- **Postman Collection**: https://evolution-api.com/postman
- **GitHub**: https://github.com/EvolutionAPI/evolution-api
- **Discord**: https://evolution-api.com/discord
- **WhatsApp Group**: https://evolution-api.com/whatsapp

---

*¡Tu Evolution API está listo para usar! 🎉*
