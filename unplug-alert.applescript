on run {}
	set total_time to 20 as integer # in minutes
	set dalay_time to 3 as integer # in seconds
	set alert_num to 10
	
	repeat total_time * 60 / dalay_time times
		set chargeState to do shell script "pmset -g batt | awk '{printf \"%s %s\\n\", $4,$5;exit}'"
		
		if (chargeState does not contain "AC Power") then
			# https://gist.github.com/youandhubris/9e292822e3db8f91df93234db092906e
			tell application "Mail"
				set theFrom to "alirezahabib@icloud.com" # change this line
				set theTos to {"alirezahabib@icloud.com"} # change this line
				set theCcs to {}
				set theBccs to {}
				
				set theSubject to "Unplugged!"
				set theContent to "Unplugged!"
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
			
			repeat alert_num times
				say "Unplugged!"
			end repeat
		end if
		delay dalay_time
	end repeat
end run