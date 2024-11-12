# HideWindowsUpdate.ps1
# Run this script as Administrator to completely hide Windows Update in Settings

# Create the necessary registry keys and set values to hide Windows Update options
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "DisableWindowsUpdateAccess" -Value 1 -PropertyType DWord

# Disable the Windows Update service completely
Stop-Service -Name wuauserv -Force
Set-Service -Name wuauserv -StartupType Disabled

# Disable the Windows Update Medic Service to prevent re-enabling of updates
Stop-Service -Name WaaSMedicSvc -Force
Set-Service -Name WaaSMedicSvc -StartupType Disabled

# Disable Automatic Updates from Group Policy to hide options
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1 -PropertyType DWord
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Value 1 -PropertyType DWord

# Set UpdateOrchestrator service to Disabled
Stop-Service -Name UsoSvc -Force
Set-Service -Name UsoSvc -StartupType Disabled

# Remove the "Windows Update" entry from Settings > Update & Security
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "SettingsPageVisibility" -Value "hide:windowsupdate" -PropertyType String

Write-Output "Windows Update option has been completely hidden in Settings."
