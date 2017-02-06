#!/bin/bash

neutron port-chain-delete PC1

neutron flow-classifier-delete FC_http
neutron flow-classifier-delete FC_udp

neutron port-pair-group-delete PG1
neutron port-pair-group-delete PG2
neutron port-pair-group-delete PG3
neutron port-pair-group-delete PG4
neutron port-pair-group-delete PG5
neutron port-pair-group-delete PG6

neutron port-pair-delete PP1
neutron port-pair-delete PP2
neutron port-pair-delete PP3
neutron port-pair-delete PP4
neutron port-pair-delete PP5
neutron port-pair-delete PP6
