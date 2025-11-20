# Scraperr Configuration Application

This configuration application helps you manage the environment variables and settings for your Scraperr system. It includes both a web-based UI and a command-line script.

## Directory Structure

```
scraperr-local/
├── config-app/
│   ├── index.html          # Web-based configuration UI
│   ├── configure.sh        # Command-line configuration script
│   └── README.md           # This file
├── docker-compose.yml
├── .env
├── Makefile
├── test_api.sh
├── data/
└── media/
```

## Web-Based Configuration UI

### How to Use

1. Open the web-based configuration UI by opening `config-app/index.html` in your browser:
   ```bash
   xdg-open /home/ncx/Proyectos/scraperr-local/config-app/index.html
   ```
   
2. Adjust the settings as needed:
   - SECRET_KEY: Enter a secure key (at least 32 characters) or click "Generate Secret Key"
   - LOG_LEVEL: Set the logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
   - ALGORITHM: Authentication algorithm (default is HS256)
   - ACCESS_TOKEN_EXPIRE_MINUTES: Token expiration time in minutes
   - NEXT_PUBLIC_API_URL: URL for the API (default http://scraperr_api:8000)
   - SERVER_URL: Server URL for the API (default http://scraperr_api:8000)

3. Click "Save Configuration" to generate a new .env file

4. Replace the existing .env file:
   ```bash
   # After downloading the new .env file, copy it to the main directory:
   cp /path/to/downloaded/.env /home/ncx/Proyectos/scraperr-local/.env
   ```

5. Restart your containers:
   ```bash
   cd /home/ncx/Proyectos/scraperr-local
   make down && make up
   ```

## Command-Line Configuration Script

### How to Use

1. Run the interactive configuration script:
   ```bash
   cd /home/ncx/Proyectos/scraperr-local/config-app
   ./configure.sh
   ```

2. The script provides the following options:
   - **Show current configuration**: Display the current values in your .env file
   - **Update configuration**: Interactively update any configuration value
   - **Regenerate SECRET_KEY**: Generate a new secret key while keeping other values
   - **Reset to default configuration**: Reset all values to defaults with a new secret key
   - **Validate configuration**: Check if your configuration is valid
   - **Restart containers**: Stop and start your Docker containers
   - **Exit**: Close the configuration manager

3. The script will create backups of your configuration in the `backups/` directory before making changes.

## Configuration Variables Explained

- **SECRET_KEY**: Used for signing JWT tokens. Should be a random string of at least 32 characters.
- **LOG_LEVEL**: Controls the verbosity of logs (DEBUG, INFO, WARNING, ERROR, CRITICAL).
- **ALGORITHM**: Algorithm used for JWT token encoding (typically HS256).
- **ACCESS_TOKEN_EXPIRE_MINUTES**: How long access tokens are valid in minutes.
- **NEXT_PUBLIC_API_URL**: The URL for the API that the frontend uses.
- **SERVER_URL**: The internal URL for the API service.

## Security Notes

1. Keep your SECRET_KEY secure and never share it publicly
2. Regularly rotate your SECRET_KEY for security
3. Ensure your .env file is not committed to version control
4. Use strong, randomly generated keys for production environments

## Troubleshooting

### If you encounter issues with the web UI:
- Make sure you're opening the file directly in your browser (file:// protocol)
- Some browsers may block JavaScript features when loading local files; try right-clicking and opening with Firefox if using Chrome

### If you encounter issues with the CLI script:
- Make sure the script has executable permissions: `chmod +x configure.sh`
- Ensure you're in the correct directory when running the script

### After updating configuration:
- Always restart your containers for changes to take effect
- Check container logs if services don't start correctly: `make logs`

## Additional Notes

- The configuration application updates the `.env` file in the main scraperr-local directory
- Backups of your configuration are stored in the `backups/` directory before making changes
- The web UI and command-line script both generate valid .env files that can be used interchangeably
- If you're running the Scraperr system, make sure to stop it before updating configuration: `make down`