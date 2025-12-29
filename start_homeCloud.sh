#!/bin/bash
# Homelab Startup Script
# Ensures Tailscale and Docker containers are running

echo "🚀 Starting Homelab Services..."

# Start Tailscale (if not already running)
echo "📡 Checking Tailscale..."
if ! sudo systemctl is-active --quiet tailscaled; then
    echo "   Starting Tailscale..."
    sudo systemctl start tailscaled
    sleep 2
fi

# Bring Tailscale connection up
sudo tailscale up

# Show Tailscale status
echo "   Tailscale IP: $(tailscale ip -4)"

# Start Docker containers (if not already running)
echo "🐳 Checking Docker containers..."
cd ~/homeCloud/nextCloud

if [ "$(docker ps -q)" ]; then
    echo "   Containers already running"
else
    echo "   Starting containers..."
    pwd
    docker compose up -d
fi

# Show container status
echo ""
echo "📊 Service Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "✅ Homelab services ready!"
echo "   Local:     http://192.168.0.148:8080"
echo "   Tailscale: http://$(tailscale ip -4):8080"