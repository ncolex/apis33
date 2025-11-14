# Scraperr Advanced Web Interface

Esta es una interfaz web avanzada que incluye todas las funcionalidades solicitadas:

- **Sistema de autenticación robusto**
- **Panel de logs detallado en tiempo real**
- **Visualización de trabajos recientes**
- **Seguimiento de progreso en tiempo real**
- **Contador de elementos encontrados en tiempo real**
- **Capacidad de detener trabajos en ejecución**
- **Visualización de múltiples trabajos simultáneos**

## Características principales

- **Interfaz mejorada**: Diseño Apple-style con indicadores visuales y feedback
- **Seguimiento de progreso**: Barras de progreso en tiempo real para cada trabajo
- **Contador de elementos**: Visualización en tiempo real de cuántos elementos se han encontrado
- **Control de trabajos**: Botones para detener trabajos en ejecución
- **Panel de logs completo**: Registro detallado de todas las actividades
- **Visualización de trabajos**: Lista actualizable de trabajos recientes con estado
- **Precisión mejorada**: Resultados más precisos con mejor manejo de errores

## Cómo usar

### Abrir la interfaz avanzada

1. Navega al directorio del proyecto:
   ```bash
   cd /home/ncx/Proyectos/scraperr-local
   ```

2. Abre la interfaz avanzada en tu navegador:
   ```bash
   xdg-open web-app/advanced-interface.html
   ```

   O abre directamente el archivo en tu navegador:
   `file:///home/ncx/Proyectos/scraperr-local/web-app/advanced-interface.html`

### Usar la interfaz

1. **Autenticación**: Ingresa tu usuario y contraseña para acceder a la interfaz
2. **Configuración de API**: Configura la URL base de la API (generalmente `http://localhost:8000`)
3. **Ejecutar scraping**: Usa cualquiera de las funciones de scraping disponibles
4. **Seguimiento en tiempo real**: Observa el progreso de tus trabajos en las barras de progreso
5. **Contador de elementos**: Mira en tiempo real cuántos elementos se han encontrado
6. **Detener trabajos**: Usa los botones "Stop Job" para detener trabajos en ejecución
7. **Ver trabajos recientes**: Consulta la lista de trabajos recientes y su estado

## Solución de problemas

### Si no puedes iniciar sesión
- Verifica que tengas un token JWT válido
- Si recibes un error de "token expirado", vuelve a autenticarte

### Si los trabajos no se actualizan
- Asegúrate de que la URL de la API esté correctamente configurada
- Verifica que la API esté corriendo en el puerto especificado

### Si las barras de progreso no se actualizan
- Puede haber un problema de latencia con la API
- Verifica la conexión de red e inténtalo de nuevo