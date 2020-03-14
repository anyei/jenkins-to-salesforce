#!/bin/sh
sudo update-ca-certificates 
exec /sbin/tini -- /usr/local/bin/jenkins.sh
