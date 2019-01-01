bindKey("l", "down", "lights")
bindKey("k", "down", "lock")
bindKey("j", "down", "engine")
addEvent("vehicles:owned", true)

local vehicles_owned = false

function Vehicles_owned()
   Vehicles_window = GuiWindow.create(0.79, 0.34, 0.16, 0.39, "Owned Vehicles", true)
   Vehicles_window:setMovable(false)
   Vehicles_window:setSizable(false)

   Vehicles_gridlist = GuiGridList.create(0.04, 0.07, 0.91, 0.71, true, Vehicles_window)
   Vehicles_gridlist:setSortingEnabled(false)
	
   Vehicles_gridlist:addColumn("ID", 0.15)
   Vehicles_gridlist:addColumn("Vehicle", 0.8)
   Vehicles_spawn = GuiButton.create(0.06, 0.81, 0.89, 0.12, "Spawn ", true, Vehicles_window)  
  
   triggerServerEvent("vehicles:owned_list", getLocalPlayer()) 
   
   Vehicles_window:setVisible(true)
   showCursor(true)
end

function Vehicles_set(data)
	for i=1, #data do
		local row = Vehicles_gridlist:addRow()
		Vehicles_gridlist:setItemText(row, 1, data[i]['id'], false, false)
		Vehicles_gridlist:setItemText(row, 2, data[i]['vehid'] , false, false )
	end
end
addEventHandler("vehicles:owned", localPlayer, Vehicles_set)

addEventHandler("onClientGUIClick", root, function()
	if (source == Vehicles_spawn and vehicles_owned) then
		local row, index = Vehicles_gridlist:getSelectedItem()
		local selected = Vehicles_gridlist:getItemText(row, index)
		if (selected == -1) then
			outputChatBox("Please select a vehicle to spawn.", 255, 0, 0)
			return false
		else
			triggerServerEvent("vehicles:owned_spawn", localPlayer, selected)
		end
	end
end)

bindKey("F2", "down", function()
	if not vehicles_owned then
		vehicles_owned = true
		Vehicles_owned()
	else
		vehicles_owned = false
		Vehicles_window:setVisible(false)
		showCursor(false)
	end
end)