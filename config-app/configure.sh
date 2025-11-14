#!/bin/bash

# Scraperr Configuration Script
# This script helps configure the environment variables for Scraperr

CONFIG_FILE="/home/ncx/Proyectos/scraperr-local/.env"
BACKUP_DIR="/home/ncx/Proyectos/scraperr-local/backups"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create backups directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Function to backup current config
backup_config() {
    if [ -f "$CONFIG_FILE" ]; then
        timestamp=$(date +"%Y%m%d_%H%M%S")
        backup_file="$BACKUP_DIR/.env.backup_$timestamp"
        cp "$CONFIG_FILE" "$backup_file"
        print_status "Backed up current config to $backup_file"
    fi
}

# Function to generate a new secret key
generate_secret_key() {
    openssl rand -hex 32
}

# Function to load current config values
load_current_config() {
    if [ -f "$CONFIG_FILE" ]; then
        # Source the current .env file to get current values
        export $(cat "$CONFIG_FILE" | xargs)
    fi
}

# Function to display current configuration
show_current_config() {
    echo
    echo "Current configuration:"
    echo "======================"
    
    if [ -f "$CONFIG_FILE" ]; then
        cat "$CONFIG_FILE"
    else
        echo "No .env file found. Using default values."
    fi
    
    echo
}

# Function to update configuration
update_config() {
    print_status "Starting configuration update..."
    
    # Load current values if they exist
    load_current_config
    
    # Get current values or defaults
    CURRENT_SECRET_KEY=${SECRET_KEY:-$(generate_secret_key)}
    CURRENT_LOG_LEVEL=${LOG_LEVEL:-"INFO"}
    CURRENT_ALGORITHM=${ALGORITHM:-"HS256"}
    CURRENT_ACCESS_TOKEN_EXPIRE_MINUTES=${ACCESS_TOKEN_EXPIRE_MINUTES:-"600"}
    CURRENT_NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL:-"http://scraperr_api:8000"}
    CURRENT_SERVER_URL=${SERVER_URL:-"http://scraperr_api:8000"}
    
    # Prompt for new values
    echo
    read -p "SECRET_KEY (current: ${CURRENT_SECRET_KEY:0:10}...): " input_secret_key
    if [ -n "$input_secret_key" ]; then
        NEW_SECRET_KEY="$input_secret_key"
    else
        NEW_SECRET_KEY="$CURRENT_SECRET_KEY"
    fi
    
    read -p "LOG_LEVEL (current: $CURRENT_LOG_LEVEL) [DEBUG/INFO/WARNING/ERROR/CRITICAL]: " input_log_level
    NEW_LOG_LEVEL=${input_log_level:-$CURRENT_LOG_LEVEL}
    
    read -p "ALGORITHM (current: $CURRENT_ALGORITHM): " input_algorithm
    NEW_ALGORITHM=${input_algorithm:-$CURRENT_ALGORITHM}
    
    read -p "ACCESS_TOKEN_EXPIRE_MINUTES (current: $CURRENT_ACCESS_TOKEN_EXPIRE_MINUTES): " input_token_expire
    NEW_TOKEN_EXPIRE=${input_token_expire:-$CURRENT_ACCESS_TOKEN_EXPIRE_MINUTES}
    
    read -p "NEXT_PUBLIC_API_URL (current: $CURRENT_NEXT_PUBLIC_API_URL): " input_api_url
    NEW_API_URL=${input_api_url:-$CURRENT_NEXT_PUBLIC_API_URL}
    
    read -p "SERVER_URL (current: $CURRENT_SERVER_URL): " input_server_url
    NEW_SERVER_URL=${input_server_url:-$CURRENT_SERVER_URL}
    
    # Confirm changes
    echo
    echo "New configuration:"
    echo "=================="
    echo "SECRET_KEY: $NEW_SECRET_KEY"
    echo "LOG_LEVEL: $NEW_LOG_LEVEL"
    echo "ALGORITHM: $NEW_ALGORITHM"
    echo "ACCESS_TOKEN_EXPIRE_MINUTES: $NEW_TOKEN_EXPIRE"
    echo "NEXT_PUBLIC_API_URL: $NEW_API_URL"
    echo "SERVER_URL: $NEW_SERVER_URL"
    echo
    
    read -p "Apply these changes? (y/N): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        # Create backup
        backup_config
        
        # Write new config
        cat > "$CONFIG_FILE" << EOF
SECRET_KEY=$NEW_SECRET_KEY
LOG_LEVEL=$NEW_LOG_LEVEL
ALGORITHM=$NEW_ALGORITHM
ACCESS_TOKEN_EXPIRE_MINUTES=$NEW_TOKEN_EXPIRE
NEXT_PUBLIC_API_URL=$NEW_API_URL
SERVER_URL=$NEW_SERVER_URL
EOF
        
        print_status "Configuration updated successfully!"
        print_status "Configuration file: $CONFIG_FILE"
        print_status "Remember to restart your containers with 'make down && make up'"
    else
        print_status "Configuration update cancelled."
    fi
}

# Function to regenerate secret key
regenerate_secret_key() {
    NEW_SECRET_KEY=$(generate_secret_key)
    
    # Load current config
    load_current_config
    
    # Update with new key, keeping other values
    cat > "$CONFIG_FILE" << EOF
SECRET_KEY=$NEW_SECRET_KEY
LOG_LEVEL=${LOG_LEVEL:-"INFO"}
ALGORITHM=${ALGORITHM:-"HS256"}
ACCESS_TOKEN_EXPIRE_MINUTES=${ACCESS_TOKEN_EXPIRE_MINUTES:-"600"}
NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL:-"http://scraperr_api:8000"}
SERVER_URL=${SERVER_URL:-"http://scraperr_api:8000"}
EOF
    
    print_status "New SECRET_KEY generated and saved to $CONFIG_FILE"
    print_status "Remember to restart your containers with 'make down && make up'"
}

# Function to reset to default values
reset_config() {
    read -p "Reset to default configuration? This will generate a new SECRET_KEY. (y/N): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        NEW_SECRET_KEY=$(generate_secret_key)
        
        # Create backup
        backup_config
        
        # Write default config
        cat > "$CONFIG_FILE" << EOF
SECRET_KEY=$NEW_SECRET_KEY
LOG_LEVEL=INFO
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=600
NEXT_PUBLIC_API_URL=http://scraperr_api:8000
SERVER_URL=http://scraperr_api:8000
EOF
        
        print_status "Configuration reset to defaults with new SECRET_KEY"
        print_status "Configuration file: $CONFIG_FILE"
        print_status "Remember to restart your containers with 'make down && make up'"
    else
        print_status "Reset cancelled."
    fi
}

# Main menu function
show_menu() {
    echo
    echo "Scraperr Configuration Manager"
    echo "=============================="
    echo "1. Show current configuration"
    echo "2. Update configuration"
    echo "3. Regenerate SECRET_KEY"
    echo "4. Reset to default configuration"
    echo "5. Validate configuration"
    echo "6. Restart containers"
    echo "7. Exit"
    echo
}

# Function to validate configuration
validate_config() {
    echo
    echo "Validating configuration..."
    
    if [ ! -f "$CONFIG_FILE" ]; then
        print_error "Configuration file $CONFIG_FILE does not exist!"
        return 1
    fi
    
    # Source the config file to access variables
    source "$CONFIG_FILE"
    
    # Validate SECRET_KEY length
    if [ ${#SECRET_KEY} -lt 32 ]; then
        print_warning "SECRET_KEY should be at least 32 characters long"
    else
        print_status "SECRET_KEY length is sufficient"
    fi
    
    # Validate LOG_LEVEL
    case $LOG_LEVEL in
        DEBUG|INFO|WARNING|ERROR|CRITICAL)
            print_status "LOG_LEVEL is valid: $LOG_LEVEL"
            ;;
        *)
            print_error "LOG_LEVEL is invalid: $LOG_LEVEL"
            ;;
    esac
    
    # Validate ACCESS_TOKEN_EXPIRE_MINUTES
    if [[ $ACCESS_TOKEN_EXPIRE_MINUTES =~ ^[0-9]+$ ]] && [ $ACCESS_TOKEN_EXPIRE_MINUTES -gt 0 ]; then
        print_status "ACCESS_TOKEN_EXPIRE_MINUTES is valid: $ACCESS_TOKEN_EXPIRE_MINUTES"
    else
        print_error "ACCESS_TOKEN_EXPIRE_MINUTES is invalid: $ACCESS_TOKEN_EXPIRE_MINUTES"
    fi
    
    print_status "Configuration validation completed"
    echo
}

# Function to restart containers
restart_containers() {
    echo
    read -p "Restart Scraperr containers? This will stop and start them. (y/N): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        cd /home/ncx/Proyectos/scraperr-local
        print_status "Stopping containers..."
        docker-compose down
        print_status "Starting containers..."
        docker-compose up -d
        print_status "Containers restarted!"
        echo
        docker-compose ps
    else
        print_status "Restart cancelled."
    fi
}

# Main script logic
if [ ! -f "/home/ncx/Proyectos/scraperr-local/docker-compose.yml" ]; then
    print_error "Scraperr docker-compose.yml not found in /home/ncx/Proyectos/scraperr-local/"
    print_error "Please ensure you're running this script from the correct context"
    exit 1
fi

# Main interactive loop
while true; do
    show_menu
    read -p "Select an option [1-7]: " option
    
    case $option in
        1)
            show_current_config
            ;;
        2)
            update_config
            ;;
        3)
            regenerate_secret_key
            ;;
        4)
            reset_config
            ;;
        5)
            validate_config
            ;;
        6)
            restart_containers
            ;;
        7)
            echo "Exiting configuration manager."
            break
            ;;
        *)
            print_error "Invalid option. Please select 1-7."
            ;;
    esac
done