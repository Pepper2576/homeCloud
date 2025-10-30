# Home Lab Infrastructure

Self-hosted cloud infrastructure built on Raspberry Pi 4.

## Architecture

- Platform: Raspberry Pi 4 (4GB)
- OS: Raspberry Pi OS Lite (64-bit)
- Containerization: Docker & Docker Compose
- Services: Nextcloud, MariaDB
- Storage: 1TB External HDD

## Services

- Nextcloud: Self-hosted cloud storage for family photos

## Deployment

```bash
cd ~/homeCloud/nextcloud
docker-compose up -d
```

## Status

- ✅ Pi configured and stable
- ✅ Docker installed
- ✅ Nextcloud deployed
- ⏳ Tailscale remote access (planned)
