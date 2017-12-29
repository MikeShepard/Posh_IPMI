(& $ipmitool -I lanplus -H 192.168.86.99 -U root -P root sdr type temperature | select-string 'Ambient Temp' | select -ExpandProperty line).split('|')  | Select-Object -last 1

#enable manual fan control
& $ipmitool -I lanplus -H 192.168.86.99 -U root -P root raw 0x30 0x30 0x01 0x00

#Disable / Return to automatic fan control:

& $ipmitool -I lanplus -H 192.168.86.99 -U root -P P@ssW*rd raw 0x30 0x30 0x01 0x01

#set Fans to 2160RPM (not much sound)
& $ipmitool -I lanplus -H 192.168.86.99 -U root -P root raw 0x30 0x30 0x02 0xff 0x08

& $ipmitool -I lanplus -H 192.168.86.99 -U root -P root chassis power soft

 & $ipmitool -I lanplus -H 192.168.86.99 -U root -P root sdr type Fan
<#FAN 1 RPM        | 30h | ok  |  7.1 | 2160 RPM
FAN 2 RPM        | 31h | ok  |  7.1 | 2040 RPM
FAN 3 RPM        | 32h | ok  |  7.1 | 2160 RPM
FAN 4 RPM        | 33h | ok  |  7.1 | 2040 RPM
FAN 5 RPM        | 34h | ok  |  7.1 | 2160 RPM
Fan Redundancy   | 75h | ok  |  7.1 | Fully Redundant
#>

#& $ipmi