# Scraperr Enhanced Configuration Application

This is a comprehensive configuration application for managing all possible configuration options for the Scraperr system, including API keys, database settings, and advanced options.

## Features

- **Complete Configuration Management**: Manage all environment variables for Scraperr
- **Multiple Configuration Sections**: Organized into General, API Keys, Database, and Advanced settings
- **API Key Management**: Secure storage for all major AI service API keys
- **Database Configuration**: Support for multiple database types (PostgreSQL, MySQL, etc.)
- **Advanced Settings**: Performance, security, and storage configurations
- **Auto-save**: Configuration is saved in browser's local storage
- **Export Functionality**: Download the configuration as a .env file
- **Secret Key Generation**: Built-in generator for secure secret keys
- **Responsive Design**: Works on both desktop and mobile devices

## How to Use

### Opening the Configuration Application

1. Navigate to your Scraperr project directory:
   ```bash
   cd /home/ncx/Proyectos/scraperr-local
   ```

2. Open the enhanced configuration application in your browser:
   ```bash
   xdg-open config-app/index-enhanced.html
   ```
   
   Or simply open the file directly in your browser by navigating to:
   `file:///home/ncx/Proyectos/scraperr-local/config-app/index-enhanced.html`

### Configuration Sections

#### 1. General Settings
- **SECRET_KEY**: Generate or enter your application secret key (32+ characters)
- **LOG_LEVEL**: Set the logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
- **ALGORITHM**: Authentication algorithm (default is HS256)
- **ACCESS_TOKEN_EXPIRE_MINUTES**: Token expiration time in minutes
- **URLs**: Configure API and frontend URLs

#### 2. API Keys
Manage API keys for various services:
- OpenAI (GPT, Whisper)
- Google Gemini
- xAI Grok
- Anthropic (Claude)
- OpenRouter
- Hugging Face
- Cloud services (AWS, Google Cloud, Azure)

#### 3. Database Configuration
- **DB_TYPE**: Select your database type (PostgreSQL, MySQL, SQLite, MongoDB)
- **Connection Details**: Host, port, username, password, database name
- **DATABASE_URL**: Optional full connection string

#### 4. Advanced Settings
- **Performance**: Workers, timeouts, concurrent requests, rate limits
- **Security**: JWT secrets, session secrets, encryption keys, reCAPTCHA
- **Storage**: Type, file size limits, allowed file types

### Saving Configuration

1. Enter your configuration values in the appropriate fields
2. Click "Guardar Configuración" (Save Configuration) to store in browser
3. Click "Descargar .env" (Download .env) to download the configuration file
4. Replace the existing `.env` file in your Scraperr project directory

### Loading Saved Configuration

The application automatically loads your previously saved configuration when you open it.

## Security Considerations

- API keys are stored only in your browser's local storage
- Never share your .env file or API keys publicly
- Use strong, unique keys for each service
- Regularly rotate your API keys for security
- The application does not transmit keys to any server

## Troubleshooting

### If you see authentication errors:
1. Verify that your API keys are correctly entered
2. Check that you have permissions to use the services
3. Ensure your API key hasn't expired or been revoked
4. Check that you're using the correct API endpoint

### Configuration not saving:
1. Make sure your browser has local storage enabled
2. Check that you have sufficient disk space
3. Clear your browser cache and try again

### Issues with the .env file:
1. Verify that the file has the correct syntax
2. Make sure there are no special characters that need escaping
3. Check that the file is saved in the correct project directory
4. Ensure the file has the right permissions (usually 600)

## Updating Your Scraperr Setup

After downloading the new .env file:

1. Replace the existing `.env` file in `/home/ncx/Proyectos/scraperr-local/`
2. Restart your Docker containers:
   ```bash
   cd /home/ncx/Proyectos/scraperr-local
   make down && make up
   ```
   
Or using Docker Compose directly:
```bash
docker-compose down && docker-compose up -d
```

## Support

If you experience issues with the configuration application, please check:

1. The browser console for JavaScript errors
2. Make sure JavaScript is enabled in your browser
3. Verify that your browser is up to date
4. Try using a different browser if issues persist