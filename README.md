DisableVBS-DeviceGuard

Use this script to disable VBS and Device Guard if everything you have tried so far did not work or you just want the nuclear option from the start.

Useful if you need to run VMs with virtualized Intel VT-x/EPT or AMD-V/RVI and have tried everything so far.

How to do:

    Run this script as Administrator (it will restart your PC).

    While rebooting, you should see a prompt or 2 asking to confirm you want to disable VBS and Device Guard.

    Confirm with F3 (or the specified button).

    To check if it worked, open cmd and run systeminfo. You should see at the bottom "Virtualization-based security: Status: Not enabled".

If it did NOT work,

    You might need to go into BIOS settings and DISABLE Secure Boot.

    To do that, restart your PC and spam Del or F2 or whatever key you use to get into the BIOS and search for Secure Boot and disable it.

    Now, rerun the script and it should work.

Hope this helps!

P.S.: Some antivirus/Vanguard software might keep forcing VBS on. In that case, you could uninstall those programs and try again, or you may need to reinstall Windows.

