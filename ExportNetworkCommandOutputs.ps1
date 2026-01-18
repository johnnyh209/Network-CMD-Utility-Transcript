<#
.SYNOPSIS
	Run and export network utility results
.DESCRIPTION
	This PowerShell script runs the following network command line utilities: Ipconfig, Test-Connection (ping), and Tracert.
    The results are then exported into a txt file.
#>

# Transcript Generation

$FilePath = Read-Host -Prompt "Enter a file path you would like to save this transcript to (e.g. C:\Users\Admin\Desktop)"
$FileName = Read-Host -Prompt "Enter a name for this transcript file (without any extensions)"
$NoExtensionPath = [System.IO.Path]::Combine($FilePath, $FileName)
$FullPath =  [System.IO.Path]::ChangeExtension($NoExtensionPath, ".txt")

try {
	# Terminate script if unable to save transcript file to the path designated.
	Start-Transcript -Path $FullPath -Append -ErrorAction Stop
}
catch {
	Write-Error "Unable to save transcript."
	return
}

# Retrieve device's network configuration
Write-Host "================================================="
Write-Host "       $env:COMPUTERNAME's IP Configuration      "
Write-Host "================================================="

try {
	Write-Host "Collecting $env:COMPUTERNAME IP configuration..." -ForegroundColor Cyan
	ipconfig /all | Out-String | Write-Output
}
catch {
	Write-Error "Unable to retrieve IP configuration for $env:COMPUTERNAME"
}

# Ping
Write-Host "=================="
Write-Host "       PING	      "
Write-Host "=================="

try {
	$ComputerName = Read-Host "Please enter an IP address or domain name to ping"
	Write-Host "Pinging $ComputerName..." -ForegroundColor Cyan
	Test-Connection -ComputerName $ComputerName -Count 4 -ErrorAction Stop
}
catch {
	Write-Error "Pinging $ComputerName failed."
}

# TraceRoute
Write-Host "====================="
Write-Host "     Traceroute      "
Write-Host "====================="

try {
	Write-Host "Tracing route to $ComputerName..." -ForegroundColor Cyan
	tracert $ComputerName | Out-String | Write-Output
}
catch {
	Write-Error "Tracing route to $ComputerName failed."
}

# End Transcript

Stop-Transcript
