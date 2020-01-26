#!/system/bin/sh

# load kernel module
insmod /system/lib/modules/exfat.ko
insmod /system/lib/modules/ntfs.ko

_SLEEP_INTERVAL=2

# store selinux state
ENFORCE=$(getenforce)

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

# set permissive state for vold restart
setenforce 0

#kill vold to restart
killall vold
echo "vold restarted"

sleep ${_SLEEP_INTERVAL}

#restore old selinux state
setenforce $ENFORCE
