# Scraperr Combined Web Interface

Esta es una interfaz web combinada que integra las mejores características de todas las interfaces disponibles en el proyecto Scraperr. Proporciona una experiencia completa con autenticación, logs detallados, y una vista mejorada de los trabajos.

## Características

- **Sistema de Autenticación**: Pantalla de login/logout para proteger el acceso
- **Panel de Logs Detallado**: Registros en tiempo real de todas las actividades
- **Visualización de Trabajos**: Lista actualizable de trabajos recientes con estado
- **Interfaz Completa**: Todas las funcionalidades de scraping en una sola interfaz
- **Diseño Moderno**: Estilo Apple con indicadores visuales y feedback

## Cómo Usar

### Abrir la Interfaz Combinada

1. Navega al directorio del proyecto:
   ```bash
   cd /home/ncx/Proyectos/scraperr-local
   ```

2. Abre la interfaz combinada en tu navegador:
   ```bash
   xdg-open web-app/combined-interface.html
   ```

   O abre directamente el archivo en tu navegador:
   `file:///home/ncx/Proyectos/scraperr-local/web-app/combined-interface.html`

### Autenticación

1. Al cargar la página, verás la pantalla de autenticación
2. Introduce cualquier nombre de usuario y contraseña (en esta versión de demostración, cualquier valor no vacío funciona)
3. Haz clic en "Iniciar Sesión" para acceder a la aplicación
4. Para cerrar sesión, haz clic en el botón "Cerrar Sesión" en la sección de "Jobs & Docs rápidos"

### Funcionalidades Principales

#### Configuración de API
- Configura la "API Base URL" (por defecto `http://localhost:8000`)
- Guarda tus claves de API de Gemini y OpenAI

#### Scraping Básico
- Ingresa la URL objetivo
- Selecciona los tipos de contenido a descargar
- Personaliza los elementos a extraer
- Ajusta la profundidad y sugerencias para el LLM
- Ejecuta el scraping

#### Búsqueda OSINT
- Realiza búsquedas en múltiples plataformas
- Selecciona las plataformas objetivo
- Visualiza resultados consolidados

#### Panel de Logs
- Registros detallados de todas las actividades
- Filtrado de información importante
- Opción para descargar los logs

#### Lista de Trabajos
- Visualización de trabajos recientes
- Estados actualizados en tiempo real
- Información detallada de cada trabajo

## Solución de Problemas

### Si la aplicación no se conecta a la API:
1. Verifica que Scraperr API esté corriendo: `make logs`
2. Asegúrate de que la URL de la API sea correcta (por defecto: `http://localhost:8000`)
3. Confirma que tu navegador no esté bloqueando solicitudes a localhost

### Si los logs no se muestran:
- La interfaz registra automáticamente todas las acciones importantes
- Puedes limpiar o descargar los logs según necesites