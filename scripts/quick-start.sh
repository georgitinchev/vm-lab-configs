#!/bin/bash
[ $# -eq 0 ] && { echo "Usage: $0 <ubuntu|kali>"; exit 1; }
export VM_TYPE="$1"
vagrant up
