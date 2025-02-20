#!/bin/sh

sudo echo "sudo mount -t nfs4 warehouse.chompe.rs:/mounts/$NFS_DEST /universe" >> /etc/bash.bashrc
