#!/bin/bash

# Script de inicialización para Evolution API
echo "🚀 Configurando Evolution API..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes coloreados
print_message() {
    color=$1
    message=$2
    echo -e "${color}${message}${NC}"
}

# Verificar si Node.js está instalado
check_node() {
    if ! command -v node &> /dev/null; then
        print_message $RED "❌ Node.js no está instalado. Por favor, instala Node.js 18 o superior."
        exit 1
    fi
    
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        print_message $RED "❌ Se requiere Node.js 18 o superior. Versión actual: $(node -v)"
        exit 1
    fi
    
    print_message $GREEN "✅ Node.js $(node -v) detectado"
}

# Verificar si npm está instalado
check_npm() {
    if ! command -v npm &> /dev/null; then
        print_message $RED "❌ npm no está instalado"
        exit 1
    fi
    print_message $GREEN "✅ npm $(npm -v) detectado"
}

# Instalar dependencias
install_dependencies() {
    print_message $BLUE "📦 Instalando dependencias..."
    npm install
    if [ $? -eq 0 ]; then
        print_message $GREEN "✅ Dependencias instaladas correctamente"
    else
        print_message $RED "❌ Error al instalar dependencias"
        exit 1
    fi
}

# Verificar y crear archivo .env
setup_env() {
    if [ ! -f .env ]; then
        print_message $YELLOW "⚠️  Archivo .env no encontrado, copiando desde .env.example..."
        cp .env.example .env
        print_message $GREEN "✅ Archivo .env creado"
    else
        print_message $GREEN "✅ Archivo .env ya existe"
    fi
}

# Verificar Docker
check_docker() {
    if command -v docker &> /dev/null; then
        print_message $GREEN "✅ Docker detectado"
        if command -v docker-compose &> /dev/null || docker compose version &> /dev/null; then
            print_message $GREEN "✅ Docker Compose detectado"
            return 0
        else
            print_message $YELLOW "⚠️  Docker Compose no detectado"
            return 1
        fi
    else
        print_message $YELLOW "⚠️  Docker no detectado"
        return 1
    fi
}

# Configurar base de datos
setup_database() {
    print_message $BLUE "🗄️  Configurando base de datos..."
    
    # Verificar si PostgreSQL está disponible localmente
    if command -v psql &> /dev/null; then
        print_message $GREEN "✅ PostgreSQL detectado localmente"
    else
        print_message $YELLOW "⚠️  PostgreSQL no detectado localmente"
        
        if check_docker; then
            print_message $BLUE "🐳 Iniciando servicios con Docker..."
            docker-compose up -d postgres redis
            sleep 5
        else
            print_message $RED "❌ Se requiere PostgreSQL o Docker para la base de datos"
            exit 1
        fi
    fi
    
    # Generar cliente de Prisma
    print_message $BLUE "🔧 Generando cliente de Prisma..."
    npm run db:generate
    
    # Aplicar migraciones
    print_message $BLUE "🔄 Aplicando migraciones de base de datos..."
    npm run db:deploy
    
    if [ $? -eq 0 ]; then
        print_message $GREEN "✅ Base de datos configurada correctamente"
    else
        print_message $RED "❌ Error al configurar la base de datos"
        exit 1
    fi
}

# Verificar configuración
verify_config() {
    print_message $BLUE "🔍 Verificando configuración..."
    
    # Verificar variables de entorno críticas
    source .env
    
    if [ -z "$DATABASE_CONNECTION_URI" ]; then
        print_message $RED "❌ DATABASE_CONNECTION_URI no está configurada en .env"
        exit 1
    fi
    
    if [ -z "$AUTHENTICATION_API_KEY" ]; then
        print_message $RED "❌ AUTHENTICATION_API_KEY no está configurada en .env"
        exit 1
    fi
    
    print_message $GREEN "✅ Configuración básica verificada"
}

# Compilar el proyecto
build_project() {
    print_message $BLUE "🔨 Compilando proyecto..."
    npm run build
    
    if [ $? -eq 0 ]; then
        print_message $GREEN "✅ Proyecto compilado correctamente"
    else
        print_message $RED "❌ Error al compilar el proyecto"
        exit 1
    fi
}

# Función principal
main() {
    print_message $BLUE "================================"
    print_message $BLUE "   Evolution API Setup Script   "
    print_message $BLUE "================================"
    
    check_node
    check_npm
    setup_env
    install_dependencies
    setup_database
    verify_config
    build_project
    
    print_message $GREEN "================================"
    print_message $GREEN "🎉 ¡Setup completado exitosamente!"
    print_message $GREEN "================================"
    print_message $BLUE ""
    print_message $BLUE "Para iniciar el servidor:"
    print_message $YELLOW "  Desarrollo: npm run dev:server"
    print_message $YELLOW "  Producción: npm run start:prod"
    print_message $BLUE ""
    print_message $BLUE "Para usar con Docker:"
    print_message $YELLOW "  docker-compose up -d"
    print_message $BLUE ""
    print_message $BLUE "El servidor estará disponible en:"
    print_message $GREEN "  http://localhost:8080"
    print_message $BLUE ""
    print_message $BLUE "API Key para autenticación:"
    print_message $GREEN "  $AUTHENTICATION_API_KEY"
    print_message $BLUE ""
}

# Ejecutar función principal
main
