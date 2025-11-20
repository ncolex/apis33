# Scraperr Enhanced Web Application

This is an advanced web interface for interacting with the Scraperr API. The application provides a modern, user-friendly interface with enhanced capabilities for managing all scraping tasks and configurations.

## Features

- **Advanced API Interaction**: Submit scraping jobs, manage existing jobs, and view results
- **AI API Key Management**: Configure Google Gemini and OpenAI API keys
- **Job Monitoring**: Track the status of all scraping jobs with loading indicators
- **Multiple Search Types**: Basic scraping, OSINT multi-service search, reverse image search
- **Export Capabilities**: Export results as JSON files in a ZIP archive
- **Platform Selection**: Choose specific platforms for multi-service searches
- **Modern UI/UX**: Apple-style design with smooth animations and feedback
- **Responsive Design**: Works on both desktop and mobile devices

## Available Interfaces

### Enhanced Interface
- File: `index-enhanced.html`
- Features: Content type selection, advanced scraping options

### Authenticated Interface
- File: `index-auth.html`
- Features: Login/logout functionality, secure access

### Interface with Logs
- File: `index-logs.html`
- Features: Detailed activity logging, system monitoring

### Combined Interface (Recommended)
- File: `combined-interface.html`
- Features: All functionality in one interface including authentication, logs, and job visualization

### Advanced Interface (Most Comprehensive)
- File: `advanced-interface.html`
- Features: All the above plus real-time progress tracking, element counters, job stopping capabilities, and improved accuracy

### Advanced Interface Fixed (Bug-Fixed Version)
- File: `advanced-interface-fixed.html`
- Features: Same as advanced interface but with bug fixes for "Body has already been consumed" errors and other stability improvements

## How to Use

### Opening the Web Application

1. Navigate to your Scraperr project directory:
   ```bash
   cd /home/ncx/Proyectos/scraperr-local
   ```

2. Open any of the available web applications in your browser:

   **Enhanced Interface (with content type selection):**
   ```bash
   xdg-open web-app/index-enhanced.html
   ```

   **Authenticated Interface (with login):**
   ```bash
   xdg-open web-app/index-auth.html
   ```

   **Interface with Logs:**
   ```bash
   xdg-open web-app/index-logs.html
   ```

   **Combined Interface (recommended - includes all features):**
   ```bash
   xdg-open web-app/combined-interface.html
   ```

   Or simply open any file directly in your browser by navigating to:
   `file:///home/ncx/Proyectos/scraperr-local/web-app/[filename].html`

### API Configuration

1. In the top section, configure the "API Base URL" field
2. By default, it's set to `http://localhost:8000` (the standard Scraperr API endpoint)
3. If your API is running on a different port or server, update this field accordingly
4. Enter your Google Gemini API key in the dedicated field
5. Enter your OpenAI API key in the dedicated field
6. Click "Save API Keys" to store them securely in browser's local storage

### Basic Scraping

1. Go to the "Scraping básico" section
2. Enter the URL you want to scrape in the "Target URL" field
3. Use example buttons to quickly select common URLs
4. Choose elements to extract using the dropdown or customize in JSON
5. Select "Scraping multipágina" if needed
6. Adjust depth and hints for LLM assistance
7. Click "Run Scraping" to start the process

### OSINT Multi-Service Search

1. Go to the "Búsqueda universal OSINT" section
2. Enter your search query in the text field
3. Select platforms to search (Google, Twitter, Facebook, etc.)
4. Click "Buscar en múltiples servicios" to start the search
5. Results from all platforms will be consolidated

### Reverse Image Search

1. Go to the "Búsqueda inversa de imagen" section
2. Enter or paste the URL of an image
3. Select image search services to use
4. Click "Buscar por imagen (scraping)" to start the search
5. Or click "Abrir pestañas" to open search pages without scraping

### Managing Results

- View detailed responses in the "Estado / respuesta" panel
- See structured previews in the "Vista previa / resumen" panel
- Export results as ZIP with "Exportar resultados ZIP"
- Clear all results with "Limpiar resultados"

## Loading Indicators and Job Status

The interface includes several visual indicators for operations in progress:
- Spinners appear during scraping operations
- Status badges show current job state (Idle, Working, OSINT, etc.)
- Job metadata updates in real-time during processing
- Success/error notifications appear for user feedback

## Security Considerations

- Authentication is required for the authenticated interface
- API keys are stored securely in browser's local storage
- Keys are not transmitted to any server unless making API requests
- Never expose your API keys in shared environments
- Use the application in trusted network environments

## Troubleshooting

### If the application doesn't connect to the API:
1. Verify the Scraperr API is running: `make logs` in the project directory
2. Check that the API URL is correct (default: http://localhost:8000)
3. Ensure your browser isn't blocking requests to localhost (some browsers do for local files)

### If you get CORS errors:
This web app runs as a static file, which may have CORS restrictions. For production, it's recommended to serve this through a web server or embed it in the actual Scraperr application.

### API Key Issues:
- Verify that your API keys for Gemini/OpenAI are correctly entered
- Check that you have the necessary permissions to use the API
- Make sure your API key hasn't expired or been revoked

### Authentication Issues:
- The demo version accepts any non-empty username/password
- In a production environment, authentication would be handled through a proper backend service