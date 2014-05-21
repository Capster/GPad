local function add_line(panelEditor, strType, strIcon, strContent, numErrorCode)
	if GPad.Output then
		--GPad.Output:Clear()
		local emitter = GPad.Output:AddLine( strType, strContent or "Unknown Error", numErrorCode or "" )
		emitter:SetIcon(strIcon)
		emitter.OnRightClick = function(line)
			local menu = DermaMenu()
			menu:AddOption("Copy to clipboard", function()
				SetClipboardText(emitter:GetColumnText(2))
			end):SetIcon ("icon16/page_white_copy.png")
			if ValidPanel(panelEditor) then
				menu:AddOption("Goto error line", function() 
						panelEditor:GoErrorLine()
				end):SetIcon ("icon16/arrow_right.png")
			end
			menu:Open()
		end
	end
end

function GPad.Error(panelEditor, strError, numErrorCode)
	add_line(panelEditor, "Error", "icon16/cancel.png", strError, numErrorCode)
end

function GPad.Warning(panelEditor, strWarning, numWarningCode)
	add_line(panelEditor, "Warning", "icon16/error.png", strWarning, numWarningCode)
end

function GPad.PrintDebug(panelEditor, strDebug, numDebugId)
	add_line(panelEditor, "Debug", "icon16/cog.png", strDebug, numDebugId)
end