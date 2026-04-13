#!/bin/bash
set -e

VM_TYPE=${1:-ubuntu}
EXPORT_DIR="$HOME/VMware-Labs"

if [ ! -d ".vagrant/machines/default/vmware_fusion" ] && [ ! -d ".vagrant/machines/default/vmware_workstation" ]; then
  echo "Error: VM not found. Run: VM_TYPE=$VM_TYPE vagrant up"
  exit 1
fi

# Determine provider directory
if [ -d ".vagrant/machines/default/vmware_fusion" ]; then
  PROVIDER_DIR=".vagrant/machines/default/vmware_fusion"
else
  PROVIDER_DIR=".vagrant/machines/default/vmware_workstation"
fi

mkdir -p "$EXPORT_DIR"
EXPORT_PATH="$EXPORT_DIR/$VM_TYPE-vm"

echo "Halting $VM_TYPE VM..."
vagrant halt 2>/dev/null || true

echo "Exporting to $EXPORT_PATH..."
rm -rf "$EXPORT_PATH"
mkdir -p "$EXPORT_PATH"

# Find UUID folder and copy contents
UUID_DIR=$(find "$PROVIDER_DIR" -mindepth 1 -maxdepth 1 -type d | head -1)
if [ -d "$UUID_DIR" ]; then
  cp -r "$UUID_DIR"/* "$EXPORT_PATH/" 2>/dev/null || true
fi

VMX=$(find "$EXPORT_PATH" -name "*.vmx" -type f | head -1)
if [ -z "$VMX" ]; then
  echo "Error: VMX file not found"
  exit 1
fi

echo "✓ Exported: $VMX"
echo ""
echo "Open in VMware:"
echo "  macOS: File > Open > $VMX"
echo "  Windows: File > Open > $VMX"
echo ""

read -p "Clean up Vagrant files? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Destroying Vagrant VM and cleaning up..."
  vagrant destroy -f
  rm -rf .vagrant
  echo "✓ Vagrant files cleaned up"
else
  echo "Vagrant files kept. To clean manually: vagrant destroy && rm -rf .vagrant"
fi
