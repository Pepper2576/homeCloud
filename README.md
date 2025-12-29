# Home Lab Infrastructure

Self-hosted cloud infrastructure built on Raspberry Pi 4.

## Architecture

- Platform: Raspberry Pi 4 (4GB)
- OS: Raspberry Pi OS Lite (64-bit)
- Containerization: Docker & Docker Compose
- Services: Nextcloud, MariaDB, Redis
- Storage: 1TB fanxiang SATA SSD via UGREEN USB 3.0 adapter
- Network: Ethernet (primary) via TP-Link RE550 + TL-SG105S switch, WiFi fallback
- Remote Access: Tailscale VPN

## Storage Configuration

- Primary Storage: `/dev/sdb1` - 1TB SSD mounted at `/mnt/nextcloud-data`
- Adapter: UGREEN USB 3.0 to SATA (Raspberry Pi compatible)
- Filesystem: ext4
- UUID: `d285fadf-2f25-4816-9236-e369e36d682e`
- Data Size: ~1.1GB (Nextcloud files + MariaDB database)

## Network Configuration

- Primary: Ethernet (eth0) - Static IP 192.168.0.148 (metric 100)
- Fallback: WiFi (wlan0) - Static IP 192.168.0.149 (metric 200, no gateway)
- Tailscale IP: 100.76.88.79

## Services

- Nextcloud: Self-hosted cloud storage for family photos
- MariaDB 10.11: Database backend
- Redis: Session cache
- Tailscale: Secure remote access

## Deployment

```bash
cd ~/homeCloud/nextCloud
docker compose up -d
```

Or use the startup script:
```bash
~/homeCloud/start_homeCloud.sh
```

## Access URLs

- Local (Ethernet): http://192.168.0.148:8080
- Tailscale Remote: http://100.76.88.79:8080

## Status

- ✅ Pi configured and stable
- ✅ Docker installed
- ✅ Nextcloud deployed on SSD storage
- ✅ Tailscale remote access active
- ✅ Ethernet primary network with WiFi failover
- ✅ Migrated from 114GB USB flash to 1TB SSD (2025-12-29)
