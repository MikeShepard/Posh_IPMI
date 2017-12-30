$IpmiToolCmd=get-command 'c:\program files (x86)\Dell\SysMgt\bmc\ipmitool.exe' -errorAction Ignore
$IpmiHost=""
$IpmiCreds=$null 

Function Set-IPMIToolPath {
[CmdletBinding()]
Param([string]$Path)
    $IpmiToolCmd=get-command $path 
}

Function Invoke-IPMICommand {
[CmdletBinding()]
Param([string]$Command)

if($IpmiToolCmd){
& $IpmiToolCmd -I lanplus -H $IpmiHost -U $($IpmiCreds.UserName) -P $($IpmiCreds.GetNetworkCredential().password) $command.split(' ')
} else {
  write-error "IPMITool.exe not found, please use Set-IPMIToolPath to indicate its location"
}
}

Function Set-IPMI{
[CmdletBinding()]
Param([String]$HostName,
      [PSCredential]$Credential)
   $script:IpmiHost=$HostNAme
   $script:IpmiCreds=$Credential

}

function Invoke-IPMIPowerCommand{
[CmdletBinding()]
Param([string][ValidateSet('status', 'on', 'off', 'cycle', 'reset', 'diag', 'soft')]$Command)
    Invoke-IPMICommand "chassis power $Command"
}



function Enable-IPMIManualFanControl{
[CmdletBinding()]
Param()
    Invoke-IPMICommand 'raw 0x30 0x30 0x01 0x00'
}

function Disable-IPMIManualFanControl{
[CmdletBinding()]
Param()
    Invoke-IPMICommand 'raw 0x30 0x30 0x01 0x01'
}

function Set-IPMIFanSpeed{
[CmdletBinding()]
Param($Speed)
    Invoke-IPMICommand 'raw 0x30 0x30 0x02 0xff 0x{0:x2}' -f $speed 

}

function Get-IPMIFanSpeed{
[CmdletBinding()]
Param()
    Invoke-IPMICommand 'sdr type fan'
}

function Get-IPMIAmbientTemperature{
[CmdletBinding()]
Param()
    (Invoke-IPMICommand 'sdr type temperature'  | select-string 'Ambient Temp' | Select-Object -ExpandProperty line).split('|')  | Select-Object -last 1
}

#Export-ModuleMember -Function *-*
