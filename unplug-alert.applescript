on plugged()
	set chargeState to do shell script "pmset -g batt | awk '{printf \"%s %s\\n\", $4,$5;exit}'"
	
	if (chargeState contains "AC Power") then return true
	return false
end plugged


on run {}
	set total_time to 20 as integer # in minutes
	set dalay_time to 2 as integer # in seconds
	
	repeat total_time * 60 / dalay_time times
		if (not plugged()) then
			# https://gist.github.com/youandhubris/9e292822e3db8f91df93234db092906e
			tell application "Mail"
				set theFrom to "your_email_address@example.com" # change this line
				set theTos to {"your_email_address@example.com"} # change this line
				set theCcs to {}
				set theBccs to {}
				
				set theSubject to "MacBook Unplugged!"
				set theContent to "MacBook Unplugged!"
				set theSignature to ""
				set theAttachments to {}
				set theDelay to 0
				
				set theMessage to make new outgoing message with properties {sender:theFrom, subject:theSubject, content:theContent, visible:false}
				tell theMessage
					repeat with theTo in theTos
						make new recipient at end of to recipients with properties {address:theTo}
					end repeat
					repeat with theCc in theCcs
						make new cc recipient at end of cc recipients with properties {address:theCc}
					end repeat
					repeat with theBcc in theBccs
						make new bcc recipient at end of bcc recipients with properties {address:theBcc}
					end repeat
					repeat with theAttachment in theAttachments
						make new attachment with properties {file name:theAttachment as alias} at after last paragraph
						delay theDelay
					end repeat
				end tell
				
				# set message signature of theMessage to signature theSignature
				send theMessage
			end tell
			
			repeat while not plugged()
				say "Unplugged!"
				say "STOP! Put it back!"
			end repeat
		end if
		delay dalay_time
	end repeat
end run
