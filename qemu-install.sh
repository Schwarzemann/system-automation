#!/bin/bash

# Variables
VM_NAME="ubuntu_vm"
RAM=2048
VCPUS=2
DISK_PATH="/var/lib/libvirt/images/${VM_NAME}.qcow2"
DISK_SIZE="20G"
ISO_PATH="/path/to/ubuntu-server.iso"  # Update this path
PRESEED_URL="http://your_server/path/to/preseed.cfg"  # You'd need to host a preseed file

# Create a disk image
qemu-img create -f qcow2 $DISK_PATH $DISK_SIZE

# Install using virt-install
virt-install \
    --name $VM_NAME \
    --ram $RAM \
    --vcpus $VCPUS \
    --disk path=$DISK_PATH,device=disk \
    --os-type linux \
    --os-variant ubuntu20.04 \
    --graphics none \
    --location $ISO_PATH \
    --extra-args "auto=true url=$PRESEED_URL" \
    --wait -1

# Connect to the console
virsh console $VM_NAME
