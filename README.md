# RaidLiveArenaAutoClicker

Autoclicker for Raid: Shadow Legends Live Arena.  USE AT YOUR OWN RISK.

## Installation/Usage Instructions

1. Download & install AutoHotkey v1.x: https://www.autohotkey.com/download/
2. Open Raid and go to your champion collection.  Tag 5 champions with the tag 'Arena Build II'
![image](https://github.com/wbm1113/RaidLiveArenaAutoClicker/assets/46951987/0b83b984-6e20-4c57-a2ff-cf9a040ba216)
3. Go to the Live Arena battle screen (where you can click 'Find Opponent') and run the script (double click on the file that ends with the .ahk extension)
4. The script will automatically re-position and re-size your raid window.  You will see your cursor start automatically moving.
5. Watch the script for the first few battles to make sure it's working.
6. Leave your computer alone while the script runs.  If you want to cancel it, press CTRL+ESC

## FAQ

### How do I make the script stop?
Press CTRL+ESC to immediately terminate the script at any time.

### Can I do other things on my machine while the script runs?
No.  The script will move the mouse and send simulated clicks/keystrokes.  If you move the mouse or try to use your computer while the script is running, you will interfere with the script and the script will interfere with what you are doing.

### Will the script automatically use live arena tokens from my inbox when it runs out?
No.  It will only ever do up to 5 battles at a time.

### Will I get banned if I use it?
I don't know.

### Can the script intelligently ban/pick the right champions?
No.  The script will always pick the same 5 champions, ban your opponent's first champion, and select your second to last champion as the lead.

### Can the script intelligently play the battle for me?
No.  All battles are run on full auto.

### What platforms are supported?
Windows only.

### Why isn't it working?
It uses UI automation, which is a brittle programming technique, and I've only ever been able to test it on my own machine.

## Known issues
* The script will hang if you wait in queue too long and an opponent can't be found
* The script will hang if you hit 35 wins and you get the popup with the live arena chest rewards
* The script will only pick up to 5 champions, even in gold tier
