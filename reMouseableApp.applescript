----------------User Settings-------------------------
#reMarkable version, set to false for reMarkable 1, set to true for reMarkable 2
set reMarkable2 to true
#IP address used for ssh to your reMarkable tablet.
set storedSSHip to "<put your ip here>"
#Port for ssh, default is 22.
set SSHport to ":22"
#SSH password of remarkable found in Help > Copyright and Licenses
set storedSSHpassword to "<put your password here>"
#set to true for passwordless entry using ssh keys. Default is false
set useSSHauthSock to false
#if useSSHauthSock = true, this must be set. Default is "$SSH_AUTH_SOCK"
set sshSocket to "$SSH_AUTH_SOCK"
--------------------------------------------------------

set Command to "remouseable"
if reMarkable2 then set Command to Command & " --event-file='/dev/input/event1'"

display dialog "Opening reMousable..." buttons {"Custom SSH settings", "Force USB", "Stored SSH settings"} default button 3
if the button returned of the result is "Custom SSH settings" then
	#prompt for sshIP and password. Prompts will default to the USB ip address and stored SSH password.
	set sshIPDialog to display dialog "IP address:" default answer "10.11.99.1" buttons {"OK"} default button 1
	set sshIP to text returned of sshIPDialog
	set sshPasswordDialog to display dialog "SSH Password:" default answer storedSSHpassword buttons {"OK"} default button 1
	set sshPassword to text returned of sshPasswordDialog
else if the button returned of the result is "Force USB" then
	#ssh settings if remarkable is connected by USB
	set sshIP to "10.11.99.1"
	set sshPassword to storedSSHpassword
else
	#default ssh settings here, set above
	set sshIP to storedSSHip
	set sshPassword to storedSSHpassword
end if

set sshIP to " --ssh-ip=" & sshIP & SSHport
set sshPassword to " --ssh-password=" & sshPassword
if useSSHauthSock then
	set Command to Command & sshIP & " --ssh-socket=" & sshSocket
else
	set Command to Command & sshIP & sshPassword
end if

set tempFile to ((POSIX path of (path to temporary items from user domain)) & "rmapp.tmp")
set tempFile to quoted form of tempFile
do shell script "echo '' > " & tempFile

if application "Terminal" is running then
	tell application "Terminal"
		# do script without "in window" will open a new window        
		set terminalWindow to do script with command Command & " 2>&1 | tee " & tempFile
		set terminalWindow_id to id of front window
	end tell
else
	tell application "Terminal"
		# window 1 is guaranteed to be recently opened window
		set terminalWindow to do script with command Command & " 2>&1 | tee " & tempFile in window 1
		set terminalWindow_id to id of front window
	end tell
end if

repeat 5 times
	set reMouseableState to (do shell script "cat " & tempFile)
	if reMouseableState contains "connected" then
		tell application "Terminal"
			set miniaturized of window id terminalWindow_id to true
		end tell
		tell application "Finder" to activate
		display notification "To quit, close the minimized Terminal window." with title "reMouseable Started..."
		return "reMouseable Started..."
	else if reMouseableState contains "panic" then
		tell me to activate
		display dialog "reMousable failed to establish a connection. See Terminal window for more info." buttons {"OK"} default button 1 with icon stop
		tell application "Terminal" to activate
		return "reMouseable failed to start..."
	end if
	delay 1
end repeat

tell me to activate
display dialog "reMousable state unknown. See Terminal window for more info." buttons {"OK"} default button 1 with icon stop
tell application "Terminal" to activate
