# Btrfs

This is the prefered file system for it's easy backups.

## Snapper on btrfs

Snapper is used for snapshotting and recovery.

see [snapper](https://github.com/jarneamerlinck/cheatsheet/blob/main/linux/snapper.md) for more info.

## RAID

As btrfs raid 10 is not supported from just disko
run the following command after running btrfs

add disk `/dev/sdd` to `/data`

```bash
btrfs device add /dev/sdd /data
```

and after you have added all the disks run

```bash
btrfs balance start -v -dconvert=raid10,soft /data
```

## RAID root disk is gone

´´´bash
mount -o degraded,usebackuproot /data
´´´
