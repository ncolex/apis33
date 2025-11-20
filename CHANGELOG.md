# Changelog

Todos los cambios notables a este proyecto serán documentados en este archivo.

El formato se basa en el estándar de versionamiento semántico (Semantic Versioning).

## [v5.2.0] - 2025-11-14

### Añadido
- Interfaz web avanzada con sistema de autenticación robusto
- Panel de logs detallado con información en tiempo real
- Visualización de trabajos recientes con estado actualizado
- Seguimiento de progreso en tiempo real con barras de progreso dinámicas
- Contador de elementos LIVE que muestra cuántos elementos se han encontrado
- Capacidad de detener trabajos en ejecución con botones de control
- Seguimiento de múltiples trabajos simulatáneos con identificación individual
- Precisión mejorada con validación de objetos antes de la serialización

### Corregido
- Error "Body has already been consumed" al manejar respuestas HTTP
- Problemas de serialización de objetos `TimeoutError` en la base de datos
- Token JWT expirado que causaba errores de autenticación
- Validación de objetos antes de la serialización para evitar errores de tipo

### Cambiado
- Implementación robusta de manejo de respuestas HTTP para evitar lecturas múltiples
- Mejor manejo de casos especiales como objetos `TimeoutError`
- Actualización de la interfaz para mostrar estado de múltiples trabajos
- Implementación de sistema de autenticación con manejo de tokens JWT

## [v5.1.0] - 2025-11-14

### Añadido
- Interfaz combinada que incluye funcionalidades de autenticación y logs
- Sistema de notificaciones mejorado
- Panel de control avanzado con feedback visual
- Funcionalidad de detención de trabajos en ejecución
- Contador de elementos encontrados en tiempo real

## [v5.0.0] - 2025-11-14

### Añadido
- Interfaz web completamente nueva con diseño Apple-style
- Sistema de autenticación con login/logout
- Panel de logs en tiempo real
- Visualización de trabajos recientes
- Seguimiento de progreso con indicadores visuales
- Exportación de resultados como ZIP

### Cambiado
- Reestructuración completa de la interfaz de usuario
- Implementación de sistema modular para funcionalidades específicas

[Fecha actual]: YYYY-MM-DD