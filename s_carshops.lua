addEvent("vehicles:CarshopPurchase", true)

-- Create Shop Vehicles, Blips and Markers
function shopsLoad()
	_marker = {}
	_vehicle = {}
	for id, getShop in pairs(shops) do
		outputDebugString("[Vehicles] Preparing Shop # "..id..".")
		Blip.create(getShop.blip[1], getShop.blip[2], getShop.blip[3], getShop.blip[4])
		for vehid, veh in pairs(getShop) do
			if (vehid == "vehs") then
				for _vehid, _veh in pairs(veh) do
					-- Set a few variables and tables beforehand
					local vehmodel = Vehicle.getModelFromName(_veh[1])
					_vehicle[vehmodel] = {}
					_marker[vehmodel] = {}
					setTimer(function()
					-- Create Vehicles for the Shop
					_vehicle[vehmodel].sample = Vehicle.create(Vehicle.getModelFromName(_veh[1]), _veh[2], _veh[3], _veh[4])
					_vehicle[vehmodel].sample:setFrozen(true)
					_vehicle[vehmodel].enter = false
					_marker[vehmodel].marker = Marker.create(_veh[2]+1.5, _veh[3], _veh[4], "cylinder", 1, 255, 255, 255, 0)
					_marker[vehmodel].marker:setData("vehicles:name", _veh[1])
					_marker[vehmodel].marker:setData("vehicles:price", _veh.price)
					_marker[vehmodel].marker:setData("vehicles:shop_name", id)
					_marker[vehmodel].marker:setData("vehicles:shop_data", getShop.information)
					triggerClientEvent("vehicles:CarshopGeneratePickup", root, _veh[2]+1.5, _veh[3], _veh[4])
					end, 1000, 1)
					addEventHandler("onPlayerJoin", root, function()
					triggerClientEvent("vehicles:CarshopGeneratePickup", root, _veh[2]+1.5, _veh[3], _veh[4])
					end)
				end
			end
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, shopsLoad)

-- Lets handle the vehicle purchases now
addEventHandler("vehicles:CarshopPurchase", root, function(id, vehicle, price, color)
	local money = source:getMoney()
	if (money < price) then source:outputChat("You do not have enough money to make this purchase.") return false end
	if shops[id] then		
		local vehicle = vehicle
		local r, g, b = getColorFromString(color)
		local acc = source:getAccount()
		local owner = acc:getName()
		local x, y, z = shops[id].spawn_location[1], shops[id].spawn_location[2], shops[id].spawn_location[3]
		if (createPlayerVehicle(vehicle, owner, r, g, b, x, y, z, 0, 0, 0)) then
			source:takeMoney(price)
			source:outputChat("Thank you for purchasing from "..id.."!", 0, 255, 0)
			source:outputChat("You have purchased a "..vehicle..".", 0, 255, 0)
			source:outputChat("Remember to use /park and /handbrake to save your vehicle's location.", 0, 255, 0)
		end
		
		triggerClientEvent(source, "vehicles:CarshopCloseMenu", source)
	end
end)


-- When a player enters a marker, output vehicle information
addEventHandler("onPlayerMarkerHit", getRootElement(), function(markerHit, matchingDimension)
	for id, marker in pairs(_marker) do 
		if (markerHit == marker.marker) then
			triggerClientEvent(source, "vehicles:CarshopShowMenu", source, marker.marker:getData("vehicles:shop_name"), marker.marker:getData("vehicles:shop_data"), marker.marker:getData("vehicles:name"), marker.marker:getData("vehicles:price"))
		end
	end
end)

-- Prevent Players from Entering Shop Vehicles
addEventHandler("onVehicleStartEnter", getRootElement(), function(thePlayer, seat, jacked)
	if (_vehicle[source:getModel()].enter == false and not getElementData(source, "vehicles:owner")) then
		cancelEvent()
	end
end)