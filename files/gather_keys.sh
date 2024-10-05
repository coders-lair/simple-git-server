#!/bin/sh

find /home/git/.ssh/authorized_keys.d/ -type f -exec cat \{\} \; -exec echo \;
