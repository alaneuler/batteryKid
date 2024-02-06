# batteryKid
To [prolong Li-ion based 
batteries](https://batteryuniversity.com/article/bu-808-how-to-prolong-lithium-based-batteries):

> Avoid completely draining the battery and avoid keeping it fully charged for long periods of time. The optimal operating range for Lithium-ion batteries is between 30% and 80% of their capacity.

However, for those who're using MacBooks as their daily workhourse, chances are that the batteries are always 100% for a long period of time.
This small menubar tool can assist in maintaining the battery health of your MacBook (only compatible with Apple Silicon).
It is free and open-source and will remain that way in the future.

batteryKid has two modes:
1. **Lite Mode** (Recommended): this mode maintains the SoC (State of Charge) at the user-selected value.
2. **Pro Mode**: this mode exposes the switches utilized by the lite mode.
   - Charging switch
   - Power source (AC) switch

**Note**:
- batteryKid requires the installation of a privileged helper for full functionality.
- After toggling the charging switch, it may take around 20 seconds for the battery status in menubar to reflect the change. The battery is already in a charging/non-charging state.

## Screenshot
### Lite Mode
<img width="346" alt="image" src="https://github.com/alaneuler/batteryKid/assets/8054939/dc87697f-9759-4c0f-afc0-f51c18608877">

### Pro Mode
<img width="317" alt="image" src="https://github.com/alaneuler/batteryKid/assets/8054939/b0494311-4d1c-4551-a6c6-3f7a4d17f994">

### Settings
<img width="522" alt="image" src="https://github.com/alaneuler/batteryKid/assets/8054939/b8153d5a-245b-492b-a6ba-1bc865260b4d">

## Uninstalling
1. Quit the app from menu bar
2. Move batteryKid.app into Trash
3. Execute following commands:
```bash
sudo launchctl unload /Library/LaunchDaemons/me.alaneuler.batteryKid.PrivilegeHelper.plist
sudo rm -rf /Library/LaunchDaemons/me.alaneuler.batteryKid.PrivilegeHelper.plist
sudo rm -rf /Library/PrivilegedHelperTools/me.alaneuler.batteryKid.PrivilegeHelper
```

## Projects Used
- [SMCKit](https://github.com/beltex/SMCKit)
- [SMJobBlessUtil-python3.py](https://gist.github.com/mikeyh/89a1e2ecc6849ff6056b7391c5216799)
- [Settings](https://github.com/sindresorhus/Settings)
- [Sparkle 2](https://github.com/sparkle-project/Sparkle/)

## Disclaimer
I do not take any responsibility for any sort of damage that may occur from using this tool!
Although it had no negative side effects for me, 
batteryKid still taps in some very low-level system functions 
that are not meant to be tampered with (private APIs).

**Use it at your own risk!**
