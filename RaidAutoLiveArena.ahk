#SingleInstance, Force
#Persistent
SendMode, Input
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

WinGet, raidProcessName, ProcessName, Raid: Shadow Legends
if (raidProcessName != "Raid.exe") {
    MsgBox Raid.exe window not found.  Make sure that your Raid client is open and that it is the only window with the title 'Raid: Shadow Legends'.
    ExitApp
}

global raidHwnd := 0
WinGet, raidHwnd, ID, Raid: Shadow Legends
if (! raidHwnd) {
    MsgBox No active Raid window found.
    ExitApp
}

MsgBox Auto Live Arena will start.  This program assumes you have Raid open and you're at the Live Arena queue screen.  Make sure nothing is covering the Raid window.  Don't move or resize the window while the script is running.  Press CTRL+ESC at any time to immediately force close this script.

WinMove, % "ahk_id " raidHwnd,, 0, 0, 800, 767

global LiveArenaAutomatorState := {}
LiveArenaAutomatorState.QueueUpScreen := 1
LiveArenaAutomatorState.ConfirmingQueueUp := 2
LiveArenaAutomatorState.WaitingInQueue := 3
LiveArenaAutomatorState.ChampionSelectFiltering := 4
LiveArenaAutomatorState.ChampionSelectPicking := 5
LiveArenaAutomatorState.ActiveBattleJustStarted := 6
LiveArenaAutomatorState.ActiveBattle := 7
LiveArenaAutomatorState.PostBattle := 8

global liveArenaAutomatorStateDescriptions = ["QueueUpScreen","ConfirmingQueueUp","WaitingInQueue","ChampionSelectFiltering","ChampionSelectPicking","ActiveBattleJustStarted","ActiveBattle","PostBattle"]

class LiveArenaAutomator {
    state := LiveArenaAutomatorState.QueueUpScreen
    waitingInQueueCycles := 0
    championSelectCycles := 0
    activeBattleCycles := 0

    Log(message) {
        FileAppend, % a_now " State[" liveArenaAutomatorStateDescriptions[this.state] "]: " message "`r`n", log.txt
    }

    Update() {        
        Tooltip % "State: " this.state

        this.Log("Start of update loop")

        if (this.state == LiveArenaAutomatorState.QueueUpScreen) {
            this.SendClickToRaidScreen(370, 165) ; active window, clear claim reward screen if needed
            queueScreenIndicatorCheck := this.SearchRaidScreen("QueueUpScreenIndicator")

            if (queueScreenIndicatorCheck.found) {
                this.Log("Queue screen indicator check passed, clicking 'Find Opponent' and advancing to ConfirmingQueueUp")
                this.SendClickToRaidScreen(750, 155) ; collect bag of tokens if available
                Sleep 1000
                this.SendClickToRaidScreen(400, 460) ; click the OK button if needed
                Sleep 1000
                this.SendClickToRaidScreen(374, 709) ; find opponent button
                this.state := LiveArenaAutomatorState.ConfirmingQueueUp
            }

            Sleep 2000
            return
        }

        if (this.state == LiveArenaAutomatorState.ConfirmingQueueUp) {
            inQueueCheck := this.SearchRaidScreen("InQueueCancelButton")

            if (inQueueCheck.found) {
                this.Log("InQueueCancelButton check passed, advancing to WaitingInQueue")
                this.state := LiveArenaAutomatorState.WaitingInQueue
                this.waitingInQueueCycles := 0
            } else {
                this.Log("InQueueCancelButton check failed, reverting to QueueUpScreen")

                refillButtonCheck := this.SearchRaidScreen("RefillConfirmButton")
                if (refillButtonCheck.found) {
                    this.SendClickToRaidScreen(400, 490)
                }

                this.state := LiveArenaAutomatorState.QueueUpScreen
            }

            Sleep 2000
            return
        }

        if (this.state == LiveArenaAutomatorState.WaitingInQueue) {
            if (this.waitingInQueueCycles > 30) {
                this.ErrorOut("Timed out while waiting in queue")
            }

            inQueueCheck := this.SearchRaidScreen("InQueueCancelButton")
            
            if (inQueueCheck.found) {
                this.Log("InQueueCancelButton check passed, continuing to wait")
                this.waitingInQueueCycles++
            } else {
                this.Log("InQueueCancelButton check failed, advancing to ChampionSelectFiltering")
                this.state := LiveArenaAutomatorState.ChampionSelectFiltering
                Sleep 10000
            }

            Sleep 2000
            return
        }

        if (this.state == LiveArenaAutomatorState.ChampionSelectFiltering) {
            this.SendClickToRaidScreen(42, 510) ; ? filter button
            Sleep 400
            this.SendClickToRaidScreen(565, 581) ; expand champion tags
            Sleep 400
            this.SendClickToRaidScreen(575, 685) ; arena build II button in filter screen
            Sleep 400
            this.SendClickToRaidScreen(507, 722) ; hide button in filter screen

            this.state := LiveArenaAutomatorState.ChampionSelectPicking
            this.championSelectCycles := 0

            this.Log("Finished selecting filters.  Advancing to ChampionSelectPicking")
            return
        }

        if (this.state == LiveArenaAutomatorState.ChampionSelectPicking) {
            if (this.championSelectCycles > 150) {
                this.ErrorOut("Timed out in champion select")
            }

            opponentLeftCheck := this.SearchRaidScreen("OpponentLeftAtChampSelectIndicator")
            if (opponentLeftCheck.found) {
                this.SendKeystrokeToRaidScreen("{ESC}")
                this.state := LiveArenaAutomatorState.QueueUpScreen
                Sleep 2000
                return
            }

            inBattleCheck := this.SearchRaidScreen("PauseButtonBar")

            if (inBattleCheck.found && inBattleCheck.coordinates[1] > 700 && inBattleCheck.coordinates[2] < 60) {
                this.Log("inBattleCheck passed.  Transitioning state to ActiveBattleJustStarted")
                this.state := LiveArenaAutomatorState.ActiveBattleJustStarted
            } else {
                this.Log("inBattleCheck failed.  Sending champion select pick clicks.")

                this.championSelectCycles++

                ; deselect anything currently selected within own champions
                this.SendClickToRaidScreen(241, 356)
                this.SendClickToRaidScreen(172, 310)
                this.SendClickToRaidScreen(171, 398)
                this.SendClickToRaidScreen(100, 309)
                this.SendClickToRaidScreen(99, 398)

                inBattleCheck := this.SearchRaidScreen("PauseButtonBar")
                if (inBattleCheck.found && inBattleCheck.coordinates[1] > 700 && inBattleCheck.coordinates[2] < 60) {
                    this.Log("inBattleCheck passed.  Transitioning state to ActiveBattleJustStarted")
                    this.state := LiveArenaAutomatorState.ActiveBattleJustStarted
                    return
                }

                ; click through all champion selections
                this.SendClickToRaidScreen(39, 620)
                this.SendClickToRaidScreen(39, 691)
                this.SendClickToRaidScreen(100, 624)
                this.SendClickToRaidScreen(101, 697)
                this.SendClickToRaidScreen(160, 623)
                this.SendClickToRaidScreen(160, 695)
                this.SendClickToRaidScreen(230, 623)
                this.SendClickToRaidScreen(230, 695)

                inBattleCheck := this.SearchRaidScreen("PauseButtonBar")
                if (inBattleCheck.found && inBattleCheck.coordinates[1] > 700 && inBattleCheck.coordinates[2] < 60) {
                    this.Log("inBattleCheck passed.  Transitioning state to ActiveBattleJustStarted")
                    this.state := LiveArenaAutomatorState.ActiveBattleJustStarted
                    return
                }

                ; click opponent lead (to ban it), confirm
                this.SendClickToRaidScreen(600, 310)
                this.SendClickToRaidScreen(682, 696)

                inBattleCheck := this.SearchRaidScreen("PauseButtonBar")
                if (inBattleCheck.found && inBattleCheck.coordinates[1] > 700 && inBattleCheck.coordinates[2] < 60) {
                    this.Log("inBattleCheck passed.  Transitioning state to ActiveBattleJustStarted")
                    this.state := LiveArenaAutomatorState.ActiveBattleJustStarted
                    return
                }
            }

            Sleep 2000
            return
        }

        if (this.state == LiveArenaAutomatorState.ActiveBattleJustStarted) {
            this.Log("Sending autobattle hotkey to Raid.  Advancing to ActiveBattle")

            Sleep 5000
            this.SendKeystrokeToRaidScreen("T")
            this.state := LiveArenaAutomatorState.ActiveBattle
            this.activeBattleCycles := 0
            
            Sleep 2000
            return
        }

        if (this.state == LiveArenaAutomatorState.ActiveBattle) {
            if (this.activeBattleCycles > 500) {
                this.ErrorOut("Timed out in active battle")
            }

            this.activeBattleCycles++

            endOfBattleCheck := this.SearchRaidScreen("VictoryIndicator")
            if (endOfBattleCheck.found) {
                this.Log("End of battle indicator detected.  Advancing to PostBattle")
                this.state := LiveArenaAutomatorState.PostBattle
                Sleep 1000
                return
            }

            endOfBattleCheck := this.SearchRaidScreen("DefeatIndicator")
            if (endOfBattleCheck.found) {
                this.Log("End of battle indicator detected.  Advancing to PostBattle")
                this.state := LiveArenaAutomatorState.PostBattle
                Sleep 1000
                return
            }

            endOfBattleCheck := this.SearchRaidScreen("OpponentLeftIndicator")
            if (endOfBattleCheck.found) {
                this.Log("End of battle indicator detected.  Advancing to PostBattle")
                this.state := LiveArenaAutomatorState.PostBattle
                Sleep 1000
                return
            }

            Sleep 5000
            return
        }

        if (this.state == LiveArenaAutomatorState.PostBattle) {
            this.Log("Sending ESC to screen.  Circling back to QueueUpScreen after 5 sec wait")
            this.SendKeystrokeToRaidScreen("{ESC}")
            this.state := LiveArenaAutomatorState.QueueUpScreen
            Sleep 5000
            return
        }
    }

    SearchRaidScreen(imageFile) {
        WinGetPos, x, y, w, h, % "ahk_id " raidHwnd
        ImageSearch, outX, outY, % x, % y, % x + w, % y + h, % "*30 " imageFile ".png"

        found := ErrorLevel == 0

        this.Log("Searching for '" imageFile "'.  Result: " found " at " outX ", " outY)

        return {found: found, coordinates: [outX, outY]}
    }

    SendClickToRaidScreen(clickX, clickY, thenSleep := 200) {
        WinGetPos, x, y, w, h, % "ahk_id " raidHwnd
        WinActivate, % "ahk_id " raidHwnd
        MouseMove, % clickX + x, % clickY + y
        SendInput {Click}

        Sleep % thenSleep
        Sleep 50

        this.Log("Clicked " clickX ", " clickY)
    }

    SendKeystrokeToRaidScreen(key) {
        WinActivate, % "ahk_id " raidHwnd
        SendInput % key
        this.Log("Pressed key " key)
    }

    ErrorOut(message) {
        this.Log("Erroring out: " message)
        MsgBox, % message
        ExitApp
    }
}

automator := new LiveArenaAutomator()
SetTimer, UpdateLoop, 500
return

UpdateLoop:
automator.Update()
return

^Esc::
ExitApp