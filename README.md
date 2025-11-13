# RaidLiveArenaAutoClicker

Autoclicker for Raid: Shadow Legends Live Arena.

This tool will start from the queue up screen, queue up, wait until champion select, pick your champions, ban your opponent's champ, pick your lead, run the battle on full auto, exit the post-battle screen, and repeat until you run out of tokens.

USE AT YOUR OWN RISK -- see below for discussion on whether this is bannable.

Note that if Plarium makes an update that changes the UI for Live Arena, the script will likely break for a day or two until I have a chance to fix.

## Installation/Usage Instructions

1. Download the repo and unzip to your desktop or wherever you like to put files.
2. Download & install AutoHotkey v1.x: https://www.autohotkey.com/download/.  This script will NOT work with the latest version of AHK (which is version 2.x).
3. Make sure you have desktop scaling set at 100% (if you're using a high res monitor you may be at 150% - 200% scaling, which can interfere with the script).  You can change this setting by right clicking on your desktop, selecting "Display Settings" and scrolling down to the "Scale" option.
4. Open Raid.
5. Go to Options and make sure the 'Optimize in-game UI' option is OFF as this will break the script.
6. Go to your champion collection.  Tag 8 desired champions with the tag 'Arena Build II'
![image](https://github.com/wbm1113/RaidLiveArenaAutoClicker/assets/46951987/0b83b984-6e20-4c57-a2ff-cf9a040ba216).  This is the pool of champions that the script will use at champion select.
7. Go to the Live Arena battle screen (where you can click 'Find Opponent') and run the script (double click on the file that ends with the .ahk extension).  A message box will appear with some instructions.  Read them, then click OK.
8. The script will automatically re-position and re-size your raid window.  You will see your cursor start automatically moving.
9. Watch the script for the first few battles to make sure it's working.
10. Leave your computer alone while the script runs.  If you want to cancel it, press CTRL+ESC at any time.

## FAQ

### Will I get banned if I use it?
I don't know.  I've used it for hundreds of battles over several months without any problems.  It's strictly an autoclicker,
which Plarium has historically tolerated.  If we can use BlueStacks to circumvent the multibattle system, I doubt this
tool is a problem.  That aside, be honest with yourself: if you lost your Raid account, would that really be a bad
thing for you?

### How do I make the script stop?
Press CTRL+ESC to immediately terminate the script at any time.

### Can I do other things on my machine while the script runs?
No.  The script will move the mouse and send simulated clicks/keystrokes.  If you move the mouse or try to use your computer while the script is running, you will interfere with the script and the script will interfere with what you are doing.

### What happens when I run out of tokens?
The script will automatically collect the free token bag you get for doing 5 battles.  It will also automatically use tokens that are in your inbox.  It will not use gems to automatically get more tokens.

### Can the script intelligently ban/pick the right champions?
No.  The script will always pick 5 champions mostly randomly (from the pool of champions that you tagged in the instructions above), then ban your opponent's first champion, and select your second to last champion as the lead.

### Can the script intelligently play the battle for me?
No.  All battles are run on full auto.

### What platforms are supported?
Windows only.
