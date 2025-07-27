#!/bin/bash

# Railway Build Script - Ejecutado automáticamente por Railway
echo "🏗️ Building Evolution API for Railway..."

# Instalar dependencias
echo "📦 Installing dependencies..."
npm ci --production=false

# Generar cliente Prisma
echo "🗄️ Generating Prisma client..."
npm run db:generate

# Ejecutar migraciones (solo si no es la primera vez)
if [ "$RAILWAY_ENVIRONMENT" = "production" ]; then
    echo "🔄 Running database migrations..."
    npm run db:deploy || echo "⚠️ Migrations may have already been applied"
fi

# Compilar aplicación
echo "🔨 Building application..."
npm run build

echo "✅ Build completed successfully!"
