# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Self-hosted cloud infrastructure running on Raspberry Pi 4 (4GB RAM) using Docker Compose. The primary service is Nextcloud for family photo storage, backed by MariaDB and Redis, with Tailscale for remote access.

## Common Commands

### Starting Services

**Primary startup script (recommended):**
```bash
/home/pepper/homeCloud/start_homeCloud.sh
```
This script automatically:
- Checks and starts Tailscale VPN service
- Starts Docker containers if not already running
- Displays Tailscale IP and service status

**Manual Docker operations:**
```bash
cd ~/homeCloud/nextCloud
docker compose up -d              # Start all services
docker compose down               # Stop all services
docker compose restart            # Restart all services
docker compose logs -f            # View logs (follow mode)
docker compose logs nextcloud-app # View specific service logs
```

**Service monitoring:**
```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
docker stats                      # Resource usage
```

### Access URLs

- Local network: `http://192.168.0.148:8080`
- Tailscale remote: `http://<tailscale-ip>:8080`
- Get Tailscale IP: `tailscale ip -4`

## Architecture

### Service Stack (3-tier containerized architecture)

1. **nextcloud-app** (Presentation Layer)
   - Image: `nextcloud:latest`
   - Port: 8080:80
   - Data volume: `/mnt/nextcloud-data/nextcloud:/var/www/html`
   - PHP memory limit: 512M
   - Upload limit: 512M

2. **nextcloud-db** (Data Layer)
   - Image: `mariadb:10.11`
   - Database: `nextcloud` (user: `nextcloud`)
   - Data volume: `/mnt/nextcloud-data/db:/var/lib/mysql`
   - Transaction isolation: READ-COMMITTED
   - Binary logging enabled (ROW format)

3. **nextcloud-redis** (Cache Layer)
   - Image: `redis:alpine`
   - Used for session storage and caching

All services run on an isolated `nextcloud-network` Docker bridge network with `restart: unless-stopped` policy.

### Data Storage

- **Nextcloud files**: `/mnt/nextcloud-data/nextcloud/`
- **Database**: `/mnt/nextcloud-data/db/`
- **External storage**: 1TB HDD (mounted at `/mnt/`)

### Network & Remote Access

- **Tailscale VPN**: Provides secure remote access without port forwarding
- **Trusted domains**: Configured via `NEXTCLOUD_TRUSTED_DOMAINS` env var (includes local IP, hostname, and Tailscale IP)

## Configuration Management

### Environment Variables

Configuration is managed through `.env` files (NOT committed to git):

- **Root level**: `/home/pepper/homeCloud/.env`
- **Service level**: `/home/pepper/homeCloud/nextCloud/.env`

**Required variables in nextCloud/.env:**
```
MYSQL_ROOT_PASSWORD=<password>
MYSQL_PASSWORD=<password>
NEXTCLOUD_ADMIN_USER=<username>
NEXTCLOUD_ADMIN_PASSWORD=<password>
NEXTCLOUD_TRUSTED_DOMAINS=<space-separated list>
```

**Important**: Never commit `.env` files. They are excluded via `.gitignore`.

## Platform Details

- **Hardware**: Raspberry Pi 4 (4GB RAM)
- **OS**: Raspberry Pi OS Lite (64-bit)
- **Architecture**: ARM64
- **Container Runtime**: Docker with Docker Compose

## Troubleshooting

**Container issues:**
```bash
cd ~/homeCloud/nextCloud
docker compose ps                 # Check container status
docker compose logs <service>     # View service logs
docker compose restart <service>  # Restart specific service
```

**Tailscale connectivity:**
```bash
sudo systemctl status tailscaled  # Check Tailscale daemon
sudo tailscale status             # Show connection status
sudo tailscale up                 # Reconnect if needed
```

**Storage issues:**
```bash
df -h /mnt/nextcloud-data/        # Check disk usage
docker system df                  # Check Docker disk usage
```