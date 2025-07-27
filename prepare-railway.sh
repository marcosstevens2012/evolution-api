#!/bin/bash

# Script de preparación para deployment en Railway
echo "🚀 Preparando proyecto para Railway..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_message() {
    color=$1
    message=$2
    echo -e "${color}${message}${NC}"
}

print_message $BLUE "================================"
print_message $BLUE "   Preparación Railway Setup    "
print_message $BLUE "================================"

# Verificar archivos necesarios
print_message $YELLOW "📁 Verificando archivos necesarios..."

if [ -f "Procfile" ]; then
    print_message $GREEN "✅ Procfile creado"
else
    print_message $RED "❌ Procfile no encontrado"
    exit 1
fi

if [ -f "railway.json" ]; then
    print_message $GREEN "✅ railway.json creado"
else
    print_message $RED "❌ railway.json no encontrado"
    exit 1
fi

if [ -f ".env.railway" ]; then
    print_message $GREEN "✅ .env.railway creado (template para Railway)"
else
    print_message $RED "❌ .env.railway no encontrado"
    exit 1
fi

# Verificar que el proyecto compile
print_message $YELLOW "🔨 Verificando que el proyecto compile..."
npm run build

if [ $? -eq 0 ]; then
    print_message $GREEN "✅ Proyecto compila correctamente"
else
    print_message $RED "❌ Error al compilar proyecto"
    exit 1
fi

# Verificar Git
print_message $YELLOW "📦 Verificando estado de Git..."

if [ -d ".git" ]; then
    print_message $GREEN "✅ Repositorio Git encontrado"
    
    # Verificar si hay cambios sin commit
    if [ -n "$(git status --porcelain)" ]; then
        print_message $YELLOW "⚠️  Hay cambios sin commit"
        git status --short
        
        read -p "¿Deseas hacer commit de los cambios? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git add .
            git commit -m "feat: prepare for Railway deployment

- Add Procfile for Railway
- Add railway.json configuration
- Add .env.railway template
- Update package.json scripts
- Update .gitignore for Railway"
            
            print_message $GREEN "✅ Cambios committed"
        fi
    else
        print_message $GREEN "✅ Git está limpio"
    fi
else
    print_message $RED "❌ No es un repositorio Git"
    print_message $YELLOW "Inicializando repositorio Git..."
    git init
    git add .
    git commit -m "Initial commit - Evolution API ready for Railway"
    print_message $GREEN "✅ Repositorio Git inicializado"
fi

# Generar API Key segura
print_message $YELLOW "🔐 Generando API Key segura para producción..."
API_KEY=$(openssl rand -hex 32)
print_message $GREEN "✅ API Key generada: $API_KEY"

print_message $BLUE ""
print_message $GREEN "🎉 ¡Proyecto preparado para Railway!"
print_message $BLUE "================================"
print_message $BLUE ""
print_message $YELLOW "📋 Próximos pasos:"
print_message $BLUE "1. Ve a https://railway.app"
print_message $BLUE "2. Crea un nuevo proyecto desde GitHub"
print_message $BLUE "3. Agrega PostgreSQL y Redis"
print_message $BLUE "4. Configura las variables de entorno"
print_message $BLUE ""
print_message $YELLOW "🔐 API Key para Railway (guárdala):"
print_message $GREEN "$API_KEY"
print_message $BLUE ""
print_message $YELLOW "📖 Lee RAILWAY_DEPLOYMENT.md para instrucciones detalladas"
print_message $BLUE ""
print_message $YELLOW "🔗 Variables críticas para Railway:"
print_message $BLUE "AUTHENTICATION_API_KEY=$API_KEY"
print_message $BLUE "SERVER_URL=https://tu-proyecto.railway.app"
print_message $BLUE "CORS_ORIGIN=https://tu-proyecto.railway.app"
print_message $BLUE ""
