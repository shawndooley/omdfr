#! /bin/sh
#
# fake_serial.sh
# Copyright (C) 2017 Shawn Dooley <shawn@shawndooley.net>
#
# Distributed under terms of the MIT license.
#



socat -d -d pty,raw,echo=0 pty,raw,echo=0
