@echo off
REM Disable VBS and Device Guard. Run as Administrator. This will REBOOT the PC.
REM During the reboot, confirm the prompt(s) with F3 (or the key shown on screen).

REM 1) Remove any policy keys that force VBS/Device Guard back on.
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "RequirePlatformSecurityFeatures" /f
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /f
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequirePlatformSecurityFeatures" /f

REM 2) Mount the EFI System Partition and stage the SecConfig tool on it.
REM    One drive letter is used everywhere below. S: is chosen to avoid clashing
REM    with common drive letters; change it if S: is already in use on your PC.
mountvol S: /s
copy %WINDIR%\System32\SecConfig.efi S:\EFI\Microsoft\Boot\SecConfig.efi /Y

REM 3) Create a one-time boot entry that launches SecConfig to disable VBS.
bcdedit /create {0cb3b571-2f2e-4343-a879-d86a476d7215} /d "DebugTool" /application osloader
bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} path "\EFI\Microsoft\Boot\SecConfig.efi"
bcdedit /set {bootmgr} bootsequence {0cb3b571-2f2e-4343-a879-d86a476d7215}
bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} loadoptions DISABLE-LSA-ISO,DISABLE-VBS
bcdedit /set vsmlaunchtype off
bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} device partition=S:

REM 4) Unmount the EFI partition and reboot into the confirmation prompt.
mountvol S: /d
shutdown /r /t 0
