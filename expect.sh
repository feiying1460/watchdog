#!/usr/local/bin/expect

#  expect.sh
#  Used in connection with watchdog.sh to reboot a router via telnet.
#
#  by Kirk Coombs (kcoombs@coombscloud.com)
#  Version 1.0 (May 19, 2017)
#    - Initial release

set timeout 60
set user USER
set password PASSWORD

spawn /usr/bin/telnet 192.168.1.1
expect "Login:" { send "$user\r" }
expect "Password:" { send "$password\r" }
expect " > " { send "reboot\r" }
interact
