# reMouseableApp
> A macOS Applescript wrapper for Kevin Conway's [reMouseable](https://github.com/kevinconway/remouseable) to make it behave like an application in macOS.

## Overview

I'm a big fan of Kevin Conway's [reMouseable](https://github.com/kevinconway/remouseable), but I wanted a way
to make it launchable like an application from spotlight. This script gives some simple dialog options for choosing
the arguments for reMousable in an intuitive way, and allows you to save an IP address and password for ssh within the script itself.

## Installation

Follow the OSX install instructions for [reMouseable](https://github.com/kevinconway/remouseable). After renaming and making the file executable, copy it to your path. We will also do our first run of the remouseable executable now, and fix the unidentified developer warning.
```shell
cd ~/Downloads
cp remouseable `echo "$PATH" | tr ':' '\n' | head -1`
reMouseable
```
Go to `System Preferences -> Security & Privacy -> General` and click `Open Anyways`.

Download the lastest ReMouseableApp.script from github, open in in AppleScript and change the User Settings appropiately. Export the script as an application in
your Applications folder.
For the script to work correctly, you'll have to fix some permissions:
1. Go to `System Preferences -> Security & Privacy -> Privacy -> Full Disk Access` and click the checkbox next to reMouseableApp. If it doesn't appear in the list, 
   you can add it manually by clicking the '+' button. *I'm aware this is a security risk, but it's the only way I could figure out how to give the script access to
   the temporary file it creates to get the output from the reMouseable executable. This will hopefully be changed in the future.
2. Go to `System Preferences -> Security & Privacy -> Privacy -> Accessibility` and click the checkbox next to Terminal. This is necesarry for the reMouseable
   executable to control your pointer. You may have already done this when installing reMouseable.
3. Go to `System Preferences -> Notifications -> ReMouseableApp` and set the notification settings as you'd like. A notification is displayed when reMouseable has
   started succesfully and is running, I reccomened using <Banners> and <Play sound for notifications> only. reMouseableApp may only appear here after your first succesful run.
