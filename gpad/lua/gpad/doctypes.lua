GPad.ContainerType = {}
GPad.FileTypes = {}
GPad.FileTypes.Types = {}

function GPad.FileTypes:CreateType(strName, tblContent)
	GPad.FileTypes.Types[strName] = tblContent
	
	GPad.ContainerType["Is"..strName] = function()
		return GPad.ActivePanel.TypeX == strName
	end
end

function GPad.FileTypes:GetType(strName)
	return GPad.FileTypes.Types[strName]
end

function GPad.FileTypes:RemoveType()
	GPad.FileTypes.Types[strName] = nil
end

function GPad.FileTypes:GetActivePanel()
	return GPad.ActivePanel
end
