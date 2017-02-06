#!/bin/bash

# Create Port Pairs
neutron port-pair-create --ingress=p1in --egress=p1out PP1
neutron port-pair-create --ingress=p2in --egress=p2out PP2
neutron port-pair-create --ingress=p3in --egress=p3out PP3
neutron port-pair-create --ingress=p4in --egress=p4out PP4
neutron port-pair-create --ingress=p5in --egress=p5out PP5
neutron port-pair-create --ingress=p6in --egress=p6out PP6

# Create Port Groups
neutron port-pair-group-create --port-pair PP1 PG1
neutron port-pair-group-create --port-pair PP2 PG2
neutron port-pair-group-create --port-pair PP3 PG3
neutron port-pair-group-create --port-pair PP4 PG4
neutron port-pair-group-create --port-pair PP5 PG5
neutron port-pair-group-create --port-pair PP6 PG6

# Create Flow Classifiers
SOURCE_IP=$(openstack port show source_vm_port -f value -c fixed_ips|grep "ip_address='[0-9]*\."|cut -d"'" -f2)
DEST_IP=$(openstack port show dest_vm_port -f value -c fixed_ips|grep "ip_address='[0-9]*\."|cut -d"'" -f2)

neutron flow-classifier-create \
    --ethertype IPv4 \
    --source-ip-prefix ${SOURCE_IP}/32 \
    --destination-ip-prefix ${DEST_IP}/32 \
    --protocol tcp \
    --destination-port 80:80 \
    --logical-source-port source_vm_port \
    FC_http

# UDP flow classifier (catch all UDP traffic from source_vm to dest_vm, like traceroute)
neutron flow-classifier-create \
    --ethertype IPv4 \
    --source-ip-prefix ${SOURCE_IP}/32 \
    --destination-ip-prefix ${DEST_IP}/32 \
    --protocol udp \
    --logical-source-port source_vm_port \
    FC_udp

neutron flow-classifier-create \
    --ethertype IPv4 \
    --source-ip-prefix ${SOURCE_IP}/32 \
    --destination-ip-prefix ${DEST_IP}/32 \
    --protocol icmp \
    --logical-source-port source_vm_port \
    FC_icmp

# Create Port Chains
#neutron port-chain-create --port-pair-group PG1 --flow-classifier FC_udp --flow-classifier FC_http PC1
#neutron port-chain-create --port-pair-group PG1 --port-pair-group PG2 --flow-classifier FC_udp --flow-classifier FC_http PC1
#neutron port-chain-create --port-pair-group PG1 --port-pair-group PG2 --port-pair-group PG3 --flow-classifier FC_udp --flow-classifier FC_http PC1
#neutron port-chain-create --port-pair-group PG1 --port-pair-group PG2 --port-pair-group PG3 --port-pair-group PG4 --flow-classifier FC_udp --flow-classifier FC_http PC1
#neutron port-chain-create --port-pair-group PG1 --port-pair-group PG2 --port-pair-group PG3 --port-pair-group PG4 --port-pair-group PG5 --flow-classifier FC_udp --flow-classifier FC_http PC1
neutron port-chain-create --port-pair-group PG1 --port-pair-group PG2 --port-pair-group PG3 --port-pair-group PG4 --port-pair-group PG5 --port-pair-group PG6 --flow-classifier FC_icmp PC1

