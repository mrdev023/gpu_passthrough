#!/bin/bash
# sudo virsh attach-device "$1" "$2.xml"

DOMAIN=$1
COMMAND="detach-device"

#
# This is a bit ugly. udev passes us the USB bus number and
# device number with leading zeroes. E.g.:
#   BUSNUM=001 DEVNUM=022
# This causes libvirt to assume that the numbers are octal.
# To work around this, we need to strip the leading zeroes.
# The easiest way is to ask bash to convert the numbers from
# base 10:
#
BUSNUM=$((10#$2))
DEVNUM=$((10#$3))

#
# Now we have all the information we need to update the VM.
# Run the appropriate virsh-command, and ask it to read the
# update XML from stdin.
#
echo "Running virsh ${COMMAND} ${DOMAIN} for USB bus=${BUSNUM} device=${DEVNUM}:" >&2
virsh "${COMMAND}" "${DOMAIN}" /dev/stdin <<END
<hostdev mode='subsystem' type='usb'>
  <source>
    <address bus='${BUSNUM}' device='${DEVNUM}' />
  </source>
</hostdev>
END
