#!/bin/bash

# Script de prueba para Evolution API
API_URL="http://localhost:8080"
API_KEY="B6D711FCDE4D4FD5936544120E713C81"

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

print_message $BLUE "🧪 Probando Evolution API..."
print_message $BLUE "================================"

# Verificar si el servidor está ejecutándose
print_message $YELLOW "📡 Verificando conexión al servidor..."
response=$(curl -s -o /dev/null -w "%{http_code}" "${API_URL}")

if [ "$response" -eq 200 ] || [ "$response" -eq 404 ]; then
    print_message $GREEN "✅ Servidor accesible en ${API_URL}"
else
    print_message $RED "❌ Servidor no accesible (HTTP $response)"
    exit 1
fi

# Probar endpoint de estado
print_message $YELLOW "🔍 Probando endpoint de estado..."
status_response=$(curl -s "${API_URL}/instance/fetchInstances" \
    -H "apikey: ${API_KEY}" \
    -H "Content-Type: application/json" \
    -w "\nHTTP_CODE:%{http_code}")

http_code=$(echo "$status_response" | tail -n1 | cut -d: -f2)
json_response=$(echo "$status_response" | sed '$d')

if [ "$http_code" -eq 200 ]; then
    print_message $GREEN "✅ API funcionando correctamente"
    print_message $BLUE "📋 Respuesta:"
    echo "$json_response" | jq '.' 2>/dev/null || echo "$json_response"
else
    print_message $RED "❌ Error en API (HTTP $http_code)"
    echo "$json_response"
fi

print_message $BLUE ""
print_message $BLUE "================================"
print_message $GREEN "🎉 Prueba completada"
print_message $BLUE ""
print_message $YELLOW "Para crear una instancia de WhatsApp:"
print_message $BLUE "curl -X POST ${API_URL}/instance/create \\"
print_message $BLUE "  -H \"apikey: ${API_KEY}\" \\"
print_message $BLUE "  -H \"Content-Type: application/json\" \\"
print_message $BLUE "  -d '{"
print_message $BLUE "    \"instanceName\": \"mi-whatsapp\","
print_message $BLUE "    \"qrcode\": true"
print_message $BLUE "  }'"
print_message $BLUE ""
print_message $YELLOW "Para obtener el QR Code:"
print_message $BLUE "curl -X GET ${API_URL}/instance/connect/mi-whatsapp \\"
print_message $BLUE "  -H \"apikey: ${API_KEY}\""
print_message $BLUE ""
