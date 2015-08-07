#!/bin/bash



sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="nomdmonddf nomdmonisw intel_iommu=on"/g' /etc/default/grub

update-grub

# Enable VFs
echo $intel_sriov_number_vfs > /sys/class/net/$intel_sriov_pf_devname/device/sriov_numvfs

echo "echo '$intel_sriov_number_vfs' > /sys/class/net/$intel_sriov_pf_devnam/device/sriov_numvfs" >> /etc/rc.local

grep -q -F "pci_passthrough_whitelist={ 'devname': '$intel_sriov_pf_devnam', 'physical_network': 'physnet2'}" /etc/nova/nova.conf || \
    sed -i "/DEFAULT/a pci_passthrough_whitelist={ 'devname': '$intel_sriov_pf_devnam', 'physical_network': 'physnet2'}" /etc/nova/nova.conf


