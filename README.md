Intel SRIOV Fuel plugin
======================


Overview
--------
Configures Neutron to have SRIOV support with Intel NICs.

Please note that only Intel 82599 cards support SRIOV and that you
need to enable VT-d support via BIOS settings. This plugin
handles creation of VFs on the compute nodes.

Terms:  
PF == Physical Function (Which is the physical card)  
VF == Virtual Function (Virtual NICs created by SRIOV)

Requirements
------------


| Requirement                    | Version/Comment                                               |
| ------------------------------ | ------------------------------------------------------------- |
| Mirantis OpenStack compatility | 6.1 or higher with OVS + VLAN                                 |


Limitations
-----------

The plugin is only compatible with OpenStack environments deployed with Neutron
for networking and using OVS + vlan.

Current plugin only allows using a single interface as PF. Next version
will support ability to define multiple interfaces as PF.


Installation Guide
------------------

Build this plugin with:

    git clone https://github.com/samos123/fuel-intel-sriov-plugin.git
    cd fuel-intel-sriov-plugin
    pip install fuel-plugin-builder
    fpb --build .

Upload the created rpm package to your Fuel master node and run `fuel plugins --instal $path_to_rpm_package`

In Fuel UI you need to define which interface name(e.g. eth1) serves as the Physical Function
for SRIOV. We will use this interface to create the VFs. Next to that you need to specify
how many VFs you would like to create. After that deploy environment as usual.



Usage guide
-----------
We need to use the CLI or API to create Instances with SRIOV ports. Horizon has no support for creating Neutron SRIOV ports.

Get the id of the neutron network where you want the SR-IOV port to be created.

    net_id=`neutron net-show net04 | grep "\ id\ " | awk '{ print $4 }'`

Create the SR-IOV port. We specify vnic\_type direct, which means that this a SR-IOV port.

    port_id=`neutron port-create $net_id --name sriov_port --binding:vnic_type direct | grep "\ id\ " | awk '{ print $4 }'`

Create the VM specifying that as 1st nic we want to use the previously created sr-iov port.

    nova boot --flavor m1.large --image ubuntu_14.04 --nic port-id=$port_id test-sriov


Authors: Sam Stoelinga
