# macOSBatteryManager
To [prolong Li-ion based 
batteries](https://www.apple.com/batteries/maximizing-performance/):

> Do not use the battery fully, and do not leave the battery at 100% for 
an extended period of time. The best operating environment for Li-ion 
batteries is between 30% and 80% power.

However, for those who're using MacBooks as their daily workhourse chances 
are that the batteries are always 100% for a long period of time.

This tiny menu bar tool can help you maintain battery of your MacBook in a health state. Supports currently only Application Silicon. It has two modes:
1. Pro Mode
2. Lite Mode

Note: After toggling the charging switch, it may take some time (about 20 seconds or so) for battery status to change. Your battery is in fact already in charging state or non-charging state.

## Screenshot
<img width="328" alt="image" 
src="https://user-images.githubusercontent.com/8054939/204074543-e33cef53-77d8-4f31-b610-4f028c6eda82.png">
<img width="328" alt="image" 
src="https://user-images.githubusercontent.com/8054939/204074570-4e361b83-62a4-4b64-af40-7f2c566ecbf7.png">

## Uninstalling
1. Quit the app from menu bar
2. Move macOSBatteryManager.app into Trash
3. Execute following commands:
```bash
sudo launchctl unload 
/Library/LaunchDaemons/me.alaneuler.mbm.PrivilegeHelper.plist
sudo rm -rf /Library/LaunchDaemons/me.alaneuler.mbm.PrivilegeHelper.plist
sudo rm -rf 
/Library/PrivilegedHelperTools/me.alaneuler.mbm.PrivilegeHelper
```

## License
This project is under the MIT License.

## TODO
- [ ] Uninstall menu
- [ ] Discharge functionality

## Used Projects
- [SMCKit](https://github.com/beltex/SMCKit)
- 
[SMJobBlessUtil-python3.py](https://gist.github.com/mikeyh/89a1e2ecc6849ff6056b7391c5216799)

## Disclaimer
I do not take any responsibility for any sort of damage in result of using 
this tool! Although it had no negative side effects for me, 
macOSBatteryManager still taps in some very low level system functions 
that are not meant to be tampered with (private APIs).

**Use it at your own risk!**
