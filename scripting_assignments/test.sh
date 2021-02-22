#!/bin/bash
ff=$1
sudo netstat -tunepl | awk '$0~"$ff" {print $0}'
