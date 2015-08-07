#!/bin/bash



## Enable SRIOV in neutron-server
sed -i "s/mechanism_drivers =openvswitch/mechanism_drivers =openvswitch,sriovnicswitch/g" /etc/neutron/plugins/ml2/ml2_conf.ini

sed -i "s/# agent_required =.*/agent_required=false/g" /etc/neutron/plugins/ml2/ml2_conf_sriov.ini

# Suggest adding all supported Intel known VF pci vendor devs here. It's not good for user experience
# to first have to know the pci address before a deployment.
sed -i "s/# supported_pci_vendor_devs.*=.*/supported_pci_vendor_devs = 8086:10ed,8086:10fb,15b3:1004,8086:10ca/g" /etc/neutron/plugins/ml2/ml2_conf_sriov.ini

# Reviewers: Does this work in CentOS?
service neutron-server restart


## Enable nova-scheduler to support PciDevice filter.

sed -i "s/scheduler_default_filters=Differ.*$/scheduler_default_filters=DifferentHostFilter,RetryFilter,AvailabilityZoneFilter,RamFilter,CoreFilter,DiskFilter,ComputeFilter,ComputeCapabilitiesFilter,ImagePropertiesFilter,ServerGroupAntiAffinityFilter,ServerGroupAffinityFilter,PciPassthroughFilter" /etc/nova/nova.conf

grep -q -F 'scheduler_available_filters=nova.scheduler.filters.pci_passthrough_filter.PciPassthroughFilter' /etc/nova/nova.conf || \
    sed -i '/scheduler_available_filters/a scheduler_available_filters=nova.scheduler.filters.pci_passthrough_filter.PciPassthroughFilter' /etc/nova/nova.conf

service nova-scheduler restart
