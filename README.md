# DisableVBS-DeviceGuard

A batch script that fully disables **Virtualization-based Security (VBS)** and
**Device Guard / Memory Integrity** on Windows.

Use it when VBS is blocking nested virtualization (running VMs that need
hardware acceleration such as Intel VT-x/EPT or AMD-V/RVI) and toggling the
usual Windows settings hasn't stuck. This is the heavy-handed option: it stages
Microsoft's `SecConfig.efi` tool on the EFI partition and adds a one-time boot
entry that turns VBS off at the firmware level.

## Requirements

- Windows 10/11 with administrator access.
- A UEFI system with an accessible EFI System Partition.
- The reboot below is expected. The script triggers it on purpose.

## Usage

1. Run `DisableVBS&DeviceGuard.bat` **as Administrator**. It will reboot the PC.
2. During the reboot, Windows shows one or two confirmation prompts asking you to
   approve disabling VBS / Device Guard. Confirm with **F3** (or whichever key the
   screen indicates).
3. After Windows loads, verify it worked. Open a command prompt and run:

   ```cmd
   systeminfo
   ```

   Near the bottom you should see:

   ```
   Virtualization-based security: Status: Not enabled
   ```

## If it didn't work

VBS often stays on because **Secure Boot** re-enables it. Disable Secure Boot,
then rerun the script:

1. Reboot and enter your firmware setup (usually `Del`, `F2`, or `F10` during
   startup, depending on the vendor).
2. Find the **Secure Boot** option and set it to *Disabled*.
3. Save, exit, and run the script again.

## Notes

- Some anti-cheat and security software (e.g. Riot Vanguard) forces VBS back on.
  If VBS keeps re-enabling after a successful run, that software is the likely
  cause; uninstalling it and rerunning, or reinstalling Windows, may be
  required.
- The script edits boot configuration and the EFI partition. Read it before
  running it, and make sure you understand what it does on your system.

## What the script does

1. Deletes the registry policy values under `DeviceGuard` that can force VBS on.
2. Mounts the EFI System Partition and copies `SecConfig.efi` onto it.
3. Creates a one-time boot entry (via `bcdedit`) that launches `SecConfig.efi`
   with the `DISABLE-LSA-ISO,DISABLE-VBS` options and sets `vsmlaunchtype off`.
4. Unmounts the EFI partition and reboots into the confirmation prompt.

The mechanism follows Microsoft's documented procedure for disabling VBS.
