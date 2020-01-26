#!/system/bin/sh

# load kernel modules
insmod /system/lib/modules/exfat.ko

# kernel ntfs support is ro
# comment this line to use fuse ntfs (rw)
insmod /system/lib/modules/ntfs.ko

_SLEEP_INTERVAL=2

# wait for startup
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep ${_SLEEP_INTERVAL}
done

# wait user to unlock
while dumpsys trust | grep -c "deviceLocked=1"; do
    sleep ${_SLEEP_INTERVAL}
    echo "device locked"
    echo $(dumpsys trust | grep -c "deviceLocked=1")
done

#kill vold to restart
killall vold
echo "vold restarted"
