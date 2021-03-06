using terms from application "Address Book"
	on action property
		return "jabber"
	end action property
	
	on action title for aPerson with screenName
		return ("Adium: Chat with " & (value of screenName as string))
	end action title
	
	on should enable action for aPerson with screenName
		return true
	end should enable action
	
	on perform action for aPerson with screenName
		set screenName to (value of screenName as string)
		using terms from application "Adium"
			(* We want a Jabber account to be online or connecting before proceeding *)
			if ((accounts of service "Jabber" whose status type is not offline) = 0) then
				tell (the first account of service "Jabber") to go online
				(* Ideally, this activate will not return until Adium is ready to make a new chat window. Just to be sure, we'll busy wait. *)
				repeat while ((accounts of service "Jabber" whose status type is not offline) = 0)
					activate
				end repeat
			end if
			(* Create the chat and find the contact it is with *)
			tell (first account of service "Jabber" whose status type is not offline)
				set myContact to make new contact with properties {name:screenName}
				make new chat with contacts {myContact} with new chat window
			end tell
			activate
		end using terms from
		return true
	end perform action
end using terms from