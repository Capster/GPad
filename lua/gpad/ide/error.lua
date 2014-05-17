local function add_line(strType, strIcon, strContent, numErrorCode)
	if GPad.Output then
		--GPad.Output:Clear()
		local emitter = GPad.Output:AddLine( strType, strContent or "Unknown Error", numErrorCode or "" )
		emitter:SetIcon(strIcon)
		emitter.OnRightClick = function(line)
			local menu = DermaMenu()
			menu:AddOption("Copy to clipboard", function()
				SetClipboardText(emitter:GetColumnText(2))
			end):SetIcon ("icon16/page_white_copy.png")
			
			menu:AddOption("Goto error line", function() 
				line:GoErrorLine()
			end):SetIcon ("icon16/arrow_right.png")
			menu:Open()
		end
	end
end

function GPad.Error(strError, numErrorCode)
	add_line("Error", "icon16/cancel.png", strError, numErrorCode)
end

function GPad.Warning(strWarning, numWarningCode)
	add_line("Warning", "icon16/error.png", strWarning, numWarningCode)
end

function GPad.PrintDebug(strDebug, numDebugId)
	add_line("Debug", "icon16/cog.png", strDebug, numDebugId)
end