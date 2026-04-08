#!/usr/bin/env bash
set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

CONTAINER_NAME="paperclip-postgres"
POSTGRES_PASSWORD="paperclip"
POSTGRES_DB="paperclip"
POSTGRES_PORT="5432"

echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Paperclip PostgreSQL Test Environment${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo

# Check if docker is available
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: docker is not installed or not in PATH${NC}"
    exit 1
fi

# Function to stop and remove existing container
cleanup() {
    if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo -e "${BLUE}Stopping and removing existing container...${NC}"
        docker stop "$CONTAINER_NAME" >/dev/null 2>&1 || true
        docker rm "$CONTAINER_NAME" >/dev/null 2>&1 || true
    fi
}

# Function to start postgres
start_postgres() {
    echo -e "${BLUE}Starting PostgreSQL container...${NC}"
    docker run -d \
        --name "$CONTAINER_NAME" \
        -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
        -e POSTGRES_DB="$POSTGRES_DB" \
        -p "${POSTGRES_PORT}:5432" \
        postgres:16-alpine

    echo -e "${GREEN}✓ PostgreSQL container started${NC}"
    echo

    # Wait for postgres to be ready
    echo -e "${BLUE}Waiting for PostgreSQL to be ready...${NC}"
    for i in {1..30}; do
        if docker exec "$CONTAINER_NAME" pg_isready -U postgres >/dev/null 2>&1; then
            echo -e "${GREEN}✓ PostgreSQL is ready${NC}"
            break
        fi
        if [ $i -eq 30 ]; then
            echo -e "${RED}Error: PostgreSQL failed to start${NC}"
            exit 1
        fi
        sleep 1
    done
}

# Function to display connection info
show_info() {
    echo
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  PostgreSQL is running!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo
    echo "Database URL:"
    echo -e "${BLUE}postgresql://postgres:${POSTGRES_PASSWORD}@localhost:${POSTGRES_PORT}/${POSTGRES_DB}${NC}"
    echo
    echo "To use with paperclip:"
    echo -e "${BLUE}export DATABASE_URL=\"postgresql://postgres:${POSTGRES_PASSWORD}@localhost:${POSTGRES_PORT}/${POSTGRES_DB}\"${NC}"
    echo -e "${BLUE}./result/bin/paperclip run${NC}"
    echo
    echo "To stop the container:"
    echo -e "${BLUE}docker stop ${CONTAINER_NAME}${NC}"
    echo
    echo "To remove the container:"
    echo -e "${BLUE}docker rm ${CONTAINER_NAME}${NC}"
    echo
    echo "To view logs:"
    echo -e "${BLUE}docker logs -f ${CONTAINER_NAME}${NC}"
    echo
}

# Main script
case "${1:-start}" in
    start)
        cleanup
        start_postgres
        show_info
        ;;

    stop)
        echo -e "${BLUE}Stopping PostgreSQL container...${NC}"
        docker stop "$CONTAINER_NAME" >/dev/null 2>&1 || true
        echo -e "${GREEN}✓ Container stopped${NC}"
        ;;

    remove|clean)
        cleanup
        echo -e "${GREEN}✓ Container removed${NC}"
        ;;

    restart)
        cleanup
        start_postgres
        show_info
        ;;

    logs)
        docker logs -f "$CONTAINER_NAME"
        ;;

    shell)
        docker exec -it "$CONTAINER_NAME" psql -U postgres -d "$POSTGRES_DB"
        ;;

    info)
        show_info
        ;;

    test)
        cleanup
        start_postgres

        echo -e "${BLUE}Building paperclip...${NC}"
        nix build .#paperclip

        echo
        echo -e "${BLUE}Running paperclip with PostgreSQL...${NC}"
        export DATABASE_URL="postgresql://postgres:${POSTGRES_PASSWORD}@localhost:${POSTGRES_PORT}/${POSTGRES_DB}"
        timeout 10 ./result/bin/paperclip run || true
        ;;

    *)
        echo "Usage: $0 {start|stop|remove|restart|logs|shell|info|test}"
        echo
        echo "Commands:"
        echo "  start   - Start PostgreSQL container (default)"
        echo "  stop    - Stop the container"
        echo "  remove  - Stop and remove the container"
        echo "  restart - Restart the container"
        echo "  logs    - View container logs"
        echo "  shell   - Open psql shell"
        echo "  info    - Show connection information"
        echo "  test    - Start postgres, build paperclip, and test"
        exit 1
        ;;
esac
