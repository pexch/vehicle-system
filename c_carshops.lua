local hex
addEvent("vehicles:CarshopGeneratePickup", true)
addEvent("vehicles:CarshopShowMenu", true)
addEvent("vehicles:CarshopCloseMenu", true)

function generatePickup(x,y,z)
	Pickup.create(x, y, z, 3, 1274)
end
addEventHandler("vehicles:CarshopGeneratePickup", root, generatePickup)

function VehicleDetails_menu(shopname, shopdescription, vehname, vehprice)
	VehicleDetails_window = GuiWindow.create(0.37, 0.27, 0.27, 0.46, shopname.." - Purchase Vehicle", true)
    VehicleDetails_window:setMovable(false)
    VehicleDetails_window:setSizable(false)

    VehicleDetails_label = GuiLabel.create(0.04, 0.12, 0.92, 0.44, shopdescription.."\n\nVehicle: "..vehname.."\nPrice: $"..format_money(vehprice), true, VehicleDetails_window)
    VehicleDetails_label:setHorizontalAlign("center", true)
	
    VehicleDetails_purchase = GuiButton.create(0.02, 0.74, 0.95, 0.10, "Purchase", true, VehicleDetails_window)
    VehicleDetails_color = GuiButton.create(0.02, 0.62, 0.95, 0.10, "Adjust Color", true, VehicleDetails_window)
    VehicleDetails_cancel = GuiButton.create(0.02, 0.87, 0.95, 0.10, "Cancel", true, VehicleDetails_window)    
		
	VehicleDetails_window:setVisible(true)
	showCursor(true)
	
	addEventHandler("onClientGUIClick", VehicleDetails_purchase, function()
		if (source == VehicleDetails_purchase) then
			exports.cpicker:closePicker(source)
			local name = vehname
			local price = vehprice
			local color = VehicleDetails_color:getText():gsub('Chosen Colour: ', '')
			if isHex(color) then
				triggerServerEvent("vehicles:CarshopPurchase", localPlayer, shopname, name, price, color)
			else
				return outputChatBox("Please choose a color before buying.")
			end
		end
	end)
	
end
addEventHandler("vehicles:CarshopShowMenu", localPlayer, VehicleDetails_menu)

function VehicleDetails_clicks()
	if (source == VehicleDetails_color) then
		exports.cpicker:openPicker(source, "#FFAA00", "Pick a color for your vehicle:")
	elseif (source == VehicleDetails_cancel) then
		VehicleDetails_window:setVisible(false)
		exports.cpicker:closePicker(source)
		showCursor(false)
	end
end
addEventHandler("onClientGUIClick", root, VehicleDetails_clicks)

function VehicleDetails_close()
	VehicleDetails_window:setVisible(false)
	exports.cpicker:closePicker(source)
	showCursor(false)
end
addEventHandler("vehicles:CarshopCloseMenu", root, VehicleDetails_close)

addEventHandler("onColorPickerOK", localPlayer, 
function(element, hex, r, g, b)
	VehicleDetails_color:setText("Chosen Colour: "..hex)
    hex = hex:gsub('%#', '')
	VehicleDetails_color:setProperty("NormalTextColour", "FF"..hex)
end)

function format_money(number)  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end

function isHex(theHex) 
    local Hex = theHex:gsub("#", "") 
    if #Hex == 6 and tonumber(Hex, 16) then return true end 
    return false 
end 
  