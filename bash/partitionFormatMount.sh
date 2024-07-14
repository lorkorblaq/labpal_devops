#!/bin/bash

# Variables
DISK="/dev/nvme1n1"
PARTITION="${DISK}p1"
MOUNT_POINT="/mnt/new_volume"
FSTAB_FILE="/etc/fstab"

# Check if the disk exists
if [ ! -b "$DISK" ]; then
  echo "Disk $DISK does not exist. Exiting."
  exit 1
fi

# Create a new partition
echo "Creating a new partition on $DISK..."
(
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | fdisk $DISK

# Check if the partition was created
if [ ! -b "$PARTITION" ]; then
  echo "Failed to create partition $PARTITION. Exiting."
  exit 1
fi

# Format the partition
echo "Formatting the partition $PARTITION..."
mkfs.ext4 $PARTITION

# Create a mount point
echo "Creating mount point at $MOUNT_POINT..."
mkdir -p $MOUNT_POINT

# Mount the partition
echo "Mounting $PARTITION to $MOUNT_POINT..."
mount $PARTITION $MOUNT_POINT

# Verify the mount
echo "Verifying the mount..."
df -h | grep $PARTITION

# Update /etc/fstab to make the mount permanent
echo "Updating /etc/fstab..."
if ! grep -q "$PARTITION" "$FSTAB_FILE"; then
  echo "$PARTITION  $MOUNT_POINT  ext4  defaults  0  2" >> $FSTAB_FILE
  echo "Updated $FSTAB_FILE with $PARTITION."
else
  echo "$PARTITION is already in $FSTAB_FILE."
fi

echo "Process completed successfully."
