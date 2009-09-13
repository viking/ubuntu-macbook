#!/bin/bash
case $1 in
    resume)
        /etc/init.d/bluetooth stop
        /etc/init.d/bluetooth start
        ;;
    thaw)
        modprobe -r appletouch
        modprobe appletouch
        ;;
esac
