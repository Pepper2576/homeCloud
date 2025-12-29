# Nextcloud Migration - December 29, 2025

## Summary

Successfully migrated Nextcloud from SD card temporary storage to 1TB SATA SSD, and configured Ethernet as primary network connection with WiFi failover.

## Migration Details

### Date
December 29, 2025

### What Was Migrated
- Nextcloud application data (~1.1GB)
- MariaDB database
- Redis cache configuration
- User files and configuration

### Storage Changes

**Before:**
- Location: SD card at `/mnt/nextcloud-data`
- Size: 1.1GB
- Performance: Limited by SD card I/O

**After:**
- Device: `/dev/sdb1` (1TB fanxiang SATA SSD)
- Location: `/mnt/nextcloud-data`
- Adapter: UGREEN USB 3.0 to SATA (Raspberry Pi compatible)
- UUID: `d285fadf-2f25-4816-9236-e369e36d682e`
- Performance: Significantly improved with SSD

### Network Changes

**Before:**
- WiFi only: 192.168.0.148 (static)

**After:**
- Primary: Ethernet (eth0) - 192.168.0.148 (static, metric 100)
- Fallback: WiFi (wlan0) - 192.168.0.149 (static, metric 200, no gateway)
- Configuration: NetworkManager (nmcli)

## Hardware Notes

### UGREEN Adapter Success
- **Model**: UGREEN USB 3.0 to SATA adapter
- **Status**: ✅ **STABLE** - No xHCI controller errors
- **Driver**: UAS (USB Attached SCSI)
- **Previous Issue**: BENFEI adapter caused USB controller crashes

### Network Setup
- Ethernet via TP-Link RE550 WiFi extender
- Connected through TP-Link TL-SG105S switch
- WiFi maintained as failover connection

## Migration Process

### Phase 1: Network Configuration
1. Configured NetworkManager for Ethernet priority
2. Set eth0 with static IP 192.168.0.148 and metric 100
3. Set wlan0 with static IP 192.168.0.149 and metric 200 (no default gateway)
4. Verified failover capability

### Phase 2: Data Backup
1. Created backup directory: `~/homelab-backup-20251229/`
2. Backed up:
   - `docker-compose.yaml`
   - `.env` files
   - `/etc/fstab`

### Phase 3: Data Migration
1. Stopped all Nextcloud containers
2. Cleared old data from SSD
3. Used rsync to migrate data:
   ```bash
   sudo rsync -avxHAX --progress --stats /mnt/nextcloud-data/ /mnt/new-ssd/
   ```
4. Verified data integrity (file counts and sizes)

### Phase 4: System Configuration
1. Unmounted temporary SSD mount
2. Mounted SSD at `/mnt/nextcloud-data` using existing fstab entry
3. Verified permissions (www-data:www-data)

### Phase 5: Testing
1. Started Docker containers
2. Verified all containers running
3. Tested web access:
   - Local: http://192.168.0.148:8080 ✅
   - Tailscale: http://100.76.88.79:8080 ✅
4. Checked logs for errors: None found
5. Verified no USB controller errors

## Post-Migration Status

### Services
- ✅ nextcloud-app: Running
- ✅ nextcloud-db: Running, MariaDB ready
- ✅ nextcloud-redis: Running

### Storage
- ✅ SSD mounted and accessible
- ✅ 890GB free space available
- ✅ No xHCI/USB errors detected

### Network
- ✅ Ethernet primary connection active
- ✅ WiFi failover configured
- ✅ Both local and Tailscale access working

## Files Modified

- `/etc/NetworkManager/system-connections/*` (via nmcli)
- `/home/pepper/homeCloud/README.md` (documentation update)
- Backup created: `~/homelab-backup-20251229/`

## Next Steps

### Immediate (Next 24 Hours)
1. Monitor system stability
2. Watch for any USB controller errors
3. Verify Nextcloud functionality under normal use
4. Keep old flash drive connected as safety backup

### After 24-Hour Stability Test
1. Remove old flash drive if SSD proven stable
2. Reformat old flash drive for other use
3. Clean up old data from SD card
4. Archive backup directory

## Rollback Plan (If Needed)

If SSD fails or issues arise:
1. Stop Docker containers
2. Restore from backup: `~/homelab-backup-20251229/`
3. Remount old storage
4. Restart containers
5. Investigate SSD/adapter issues

## Performance Notes

Expected improvements:
- Faster database queries (SSD vs SD card)
- Improved file upload/download speeds
- Better overall Nextcloud responsiveness
- Reduced wear on SD card (OS only now)

## Conclusion

Migration completed successfully with no errors. System is stable and running on SSD storage with Ethernet as primary network connection. Monitoring period of 24 hours recommended before removing old storage device.
