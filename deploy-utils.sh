#!/bin/bash

# Script de utilidad para el mantenimiento y deploy del proyecto Scraperr

set -e  # Salir inmediatamente si un comando falla
set -u  # Tratar variables no asignadas como un error

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Funciones de utilidad
print_header() {
    echo -e "${BLUE}=======================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=======================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Función para inicializar el repositorio Git
init_git_repo() {
    print_header "Inicializando repositorio Git"
    
    if [ -d ".git" ]; then
        print_warning "El repositorio Git ya existe"
        return 0
    fi
    
    git init
    if [ $? -eq 0 ]; then
        print_success "Repositorio Git inicializado correctamente"
    else
        print_error "Error al inicializar el repositorio Git"
        return 1
    fi
}

# Función para verificar el estado del proyecto
check_project_status() {
    print_header "Verificando estado del proyecto"
    
    # Verificar que los archivos importantes existen
    if [ -f "docker-compose.yml" ] && [ -f ".env" ]; then
        print_success "Archivos de configuración principales presentes"
    else
        print_error "Archivos de configuración faltantes"
        return 1
    fi
    
    # Verificar estado de los contenedores
    if docker-compose ps --quiet | grep -q .; then
        print_success "Contenedores en ejecución detectados"
    else
        print_warning "No se detectaron contenedores en ejecución"
    fi
    
    # Verificar directorios importantes
    for dir in "web-app" "data" "media"; do
        if [ -d "$dir" ]; then
            print_success "Directorio $dir presente"
        else
            print_warning "Directorio $dir no encontrado"
        fi
    done
}

# Función para crear un commit de los cambios
create_commit() {
    print_header "Creando commit de cambios"
    
    # Agregar todos los archivos al stage
    git add .
    if [ $? -ne 0 ]; then
        print_error "Error al agregar archivos al stage"
        return 1
    fi
    
    # Hacer el commit
    git commit -m "feat: añadir interfaces web avanzadas con autenticación y logs detallados

- Implementar sistema de autenticación robusto con manejo de tokens JWT
- Agregar panel de logs detallado con información en tiempo real
- Implementar visualización de trabajos recientes con estado actualizado
- Añadir seguimiento de progreso en tiempo real con barras de progreso
- Implementar contador de elementos LIVE que muestra cuántos elementos se han encontrado
- Añadir capacidad de detener trabajos en ejecución con botones de control
- Implementar seguimiento de múltiples trabajos con identificación individual
- Mejorar precisión con validación de objetos antes de la serialización
- Corregir error 'Body has already been consumed' al manejar respuestas HTTP
- Solucionar problemas de serialización de objetos TimeoutError
- Implementar validación de objetos antes de la serialización
- Añadir documentación y ejemplos de uso"
    if [ $? -eq 0 ]; then
        print_success "Commit realizado correctamente"
    else
        print_error "Error al crear el commit"
        return 1
    fi
}

# Función para verificar estado de los servicios
check_services_status() {
    print_header "Verificando estado de los servicios"
    
    # Verificar si los servicios están corriendo
    services=$(docker-compose ps --format "table {{.Service}}\t{{.Status}}")
    echo "$services"
    
    if echo "$services" | grep -q "Up"; then
        print_success "Servicios en ejecución"
    else
        print_warning "Algunos servicios no están en ejecución"
    fi
}

# Función para exportar configuración
export_config() {
    print_header "Exportando configuración"
    
    # Crear un archivo con la configuración actual
    cat > deployment-config.txt << EOF
# Configuración de Deploy - Scraperr OSINT PWA
Fecha: $(date)
Versión: 5.2.0
Estado de los contenedores:
$(docker-compose ps)

Variables de entorno importantes:
$(grep -E '^(SECRET_KEY|NEXT_PUBLIC_API_URL|SERVER_URL)' .env || echo "No se encontraron variables clave en .env")
EOF
    
    print_success "Configuración exportada a deployment-config.txt"
}

# Función para mostrar resumen
show_summary() {
    print_header "Resumen del estado"
    echo "✓ Proyecto: Scraperr OSINT PWA - Advanced Interface"
    echo "✓ Versión: 5.2.0"
    echo "✓ Fecha de deploy: $(date)"
    echo "✓ Características implementadas:"
    echo "  - Sistema de autenticación robusto"
    echo "  - Panel de logs detallado"
    echo "  - Visualización de trabajos recientes"
    echo "  - Seguimiento de progreso en tiempo real"
    echo "  - Contador de elementos LIVE"
    echo "  - Capacidad de detener trabajos"
    echo "  - Seguimiento de múltiples trabajos"
    echo "  - Corrección de error de serialización"
    echo ""
    echo "✓ Servicios en ejecución:"
    docker-compose ps --format "table {{.Service}}\t{{.Status}}"
}

# Función principal
main() {
    print_header "Scraperr Deployment Utility"
    echo "Este script prepara el proyecto para el deploy"
    echo ""
    
    # Ejecutar todas las funciones
    init_git_repo
    echo ""
    
    check_project_status
    echo ""
    
    check_services_status
    echo ""
    
    export_config
    echo ""
    
    show_summary
    echo ""
    
    print_header "Deploy Ready!"
    echo "El proyecto está listo para ser subido a Git y desplegado."
    echo "Puedes hacerlo con los siguientes comandos:"
    echo ""
    echo "git add ."
    echo "git commit -m \"feat: añadir interfaces web avanzadas con autenticación y logs detallados\""
    echo "git push origin main"
    echo ""
    echo "Para reiniciar los servicios si es necesario:"
    echo "make down && make up"
}

# Ejecutar la función principal si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi