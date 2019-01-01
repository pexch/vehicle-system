addEvent("vehicles:owned_list", true)
addEvent("vehicles:owned_spawn", true)

-- Get player's owned vehicles
function getOwnedVehicles()
	local acc = client:getAccount()
	local owner = acc:getName()
	
	local _result = {}
	local query = connection:query("SELECT * FROM vehicles WHERE owner=?", owner)
	_result = query:poll(-1)
	query:free()
	if (#_result > 0) then
		triggerClientEvent(client, "vehicles:owned", client, _result)
	else
		triggerClientEvent(client, "vehicles:owned", client, {})	
	end
end
addEventHandler("vehicles:owned_list", root, getOwnedVehicles)

-- Spawn player's vehicle from F2
function spawnOwnedVehicles(vehid)
	local acc = client:getAccount()
	local owner = acc:getName()
	local location = client:getPosition()
	
	local query = connection:query("SELECT * FROM vehicles WHERE id=? AND owner=?", vehid, owner)
	local result = query:poll(-1)
	if (#result > 0) then
		if client:isInVehicle() then client:outputChat("You must exit your vehicle before spawning another one.", 255, 0, 0) return false end
		for id, veh in ipairs(getElementsByType('vehicle')) do
			if (veh:getData("vehicles:id") == tonumber(vehid)) then
				veh:setPosition(location.x, location.y, location.z)
				client:warpIntoVehicle(veh)
				query:free()
			end
		end
	else
		client:outputChat("[Error] Something went wrong, please contact an Administrator.", 255, 0, 0)
	end
end
addEventHandler("vehicles:owned_spawn", root, spawnOwnedVehicles)

-- Insert data into database and create the vehicle, whilst warping the player into it
function createPlayerVehicle(id, owner, r, g, b, x, y, z, rotX, rotY, rotZ)
	if (id and x and y and z) then
		local q = connection:query([[
		INSERT INTO vehicles 
		(owner, vehid, location, rotation, color, engine, handbrake, health, interior, dimension, locked, lights) 
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
		]], owner, id, toJSON({x,y,z}), toJSON({rotX,rotY,rotZ}), toJSON({r,g,b}), 0, 0, 1000, 0, 0, 0, 0)
		local result, num_rows, insert_id = q:poll(-1)
		if q then
			local shop_veh = Vehicle.create(Vehicle.getModelFromName(id), x, y, z)
			shop_veh:setColor(r,g,b)
			source:warpIntoVehicle(shop_veh)
			shop_veh:setData("vehicles:id", insert_id)
			shop_veh:setData("vehicles:owner", owner)
			shop_veh:setData("vehicles:engine", 0)
			shop_veh:setData("vehicles:handbrake", 0)
			shop_veh:setData("vehicles:locked", 0)
			shop_veh:setData("vehicles:lights", 0)
			q:free()
			return true
		end
	else
		source:outputChat("[Error] Failed to generate vehicle, please contact an Administrator.", 255, 0, 0)
		return false
	end
end

-- Load all vehicles on script start up
addEventHandler("onResourceStart", root, function()
	-- Check script version
	local fetch = fetchRemote("https://raw.githubusercontent.com/FlyingSpoo9/vehicle-system/master/version", function(git_version)
		local git_version = git_version:gsub("%+s","")
		if (tonumber(git_version) == tonumber(version)) then
			return
		else
			print( "\n" );
			print( "====================================" );
			print( "= VEHICLE SYSTEM IS OUTDATED!"  );
			print( "====================================" );
			print( "= Your version: ".. version );
			print( "= Current version: ".. git_version );
			print( "= Download: https://github.com/FlyingSpoo9/vehicle-system" );
			print( "====================================" ); 
			
		end
	end)

	local query = connection:query("SELECT * FROM vehicles")
	local result, num_affected_rows, last_insert_id = query:poll(-1)
	outputDebugString("[Vehicles] Loading stored vehicles...")
	
	setTimer(function()
	for _, vehicle in ipairs(result) do
		local id = vehicle.id
		local owner = vehicle.owner
		local vehid = Vehicle.getModelFromName(vehicle.vehid)
		local location = fromJSON(vehicle.location)
		local color = fromJSON(vehicle.color)
		local engine = vehicle.engine
		local handbrake = vehicle.handbrake
		local health = vehicle.health
		local interior = vehicle.interior
		local dimension = vehicle.dimension
		local rotation = fromJSON(vehicle.rotation)
		local locked = vehicle.locked
		local lights = vehicle.lights
						
		local temp = Vehicle.create(vehid, location[1], location[2], location[3])
		temp:setColor(color[1], color[2], color[3])
		temp:setHealth(health)
		temp:setRotation(rotation[1], rotation[2], rotation[3])
		temp:setInterior(interior)
		temp:setDimension(dimension)
		
		temp:setData("vehicles:id", id)
		temp:setData("vehicles:owner", owner)
		temp:setData("vehicles:engine", engine)
		temp:setData("vehicles:handbrake", handbrake)
		temp:setData("vehicles:locked", locked)
		temp:setData("vehicles:lights", lights)
		
		-- Set Vehicle Locked 
		if (locked == 0) then
			temp:setLocked(false)
		elseif (locked == 1) then
			temp:setLocked(true)
		end
		-- Set Engine State
		if (engine == 0) then
			temp:setEngineState(false)
		elseif (engine == 1) then
			temp:setEngineState(true)
		end
		-- Set Handbrake
		if (handbrake == 0) then
			temp:setFrozen(false)
		elseif (handbrake == 1) then
			temp:setFrozen(true)
		end
		-- Set Lights
		if (lights == 0) then
			temp:setOverrideLights(1)
		elseif (lights == 1) then
			temp:setOverrideLights(2)
		end
		--
	end
	end, 1000, 1)
end)

addEventHandler("onVehicleEnter", root, function(player)
	local vehicle = source:getName()
	player:outputChat("This vehicle belongs to "..source:getData("vehicles:owner")..". (("..vehicle.."))", 245, 227, 147)
	-- Setting the engine state to prevent engine automatically starting if its off
	if source:getData("vehicles:engine") == 1 then
		source:setEngineState(true)
	elseif source:getData("vehicles:engine") == 0 then
		source:setEngineState(false)
	end
end)

-- Commands 
-- /lights [Turn your vehicle lights on/off]
addCommandHandler("lights", function(player,cmd)
	local acc = player:getAccount()
	local owner = acc:getName()
	local vehicle = Ped.getOccupiedVehicle(player)
	if vehicle then
		setPlayerVehicleLights(player, vehicle)
	else
		player:outputChat("You are not in any vehicle.", 255, 0, 0)
	end
end)

function setPlayerVehicleLights(player, vehicle)
	if (vehicle:getData("vehicles:lights") == 1) then
		vehicle:setData("vehicles:lights", 0)
		vehicle:setOverrideLights(1)
		player:outputChat("You have turned off your lights.", 245, 227, 147)
		connection:exec("UPDATE vehicles SET lights=? WHERE id=? AND owner=?", 0, vehicle:getData("vehicles:id"), vehicle:getData("vehicles:owner"))
	elseif (vehicle:getData("vehicles:lights") == 0) then
		vehicle:setData("vehicles:lights", 1)
		vehicle:setOverrideLights(2)
		player:outputChat("You have turned on your lights.", 245, 227, 147)
		connection:exec("UPDATE vehicles SET lights=? WHERE id=? AND owner=?", 1, vehicle:getData("vehicles:id"), vehicle:getData("vehicles:owner"))	
	end 
end

-- /park [Saves the position of your vehicle]
addCommandHandler("park", function(player,cmd)
	local veh = Ped.getOccupiedVehicle(player)
	if (veh) then
		local acc = player:getAccount()
		local owner = acc:getName()
		local location = player:getPosition()
		local rotation = player:getRotation()
		local int = player:getInterior()
		local dim = player:getDimension()
		local loc = toJSON({location.x,location.y,location.z})
		local rot = toJSON({rotation.x,rotation.y,rotation.z})
		if (veh:getData("vehicles:owner") == owner) then
			local id = getElementData(veh, "vehicles:id")
			if connection:exec("UPDATE vehicles SET location=?, rotation=?, interior=?, dimension=? WHERE id=? AND owner=?", loc, rot, int, dim, id, owner) then
				player:outputChat("You have parked your vehicle.", 0, 255, 0)
			end
		end
	else
		player:outputChat("You must be in a vehicle to use this command.", 255, 0, 0)
	end
end)

-- /handbrake [Freezes your vehicle in that position] 
addCommandHandler("handbrake", function(player,cmd)
	local acc = player:getAccount()
	local owner = acc:getName()
	local vehicle = Ped.getOccupiedVehicle(player)
	if vehicle then
		setPlayerVehicleHandbrake(player, vehicle)
	else
		player:outputChat("You are not in any vehicle.", 255, 0, 0)
	end
end)

function setPlayerVehicleHandbrake(player, vehicle)
	if (vehicle:getData("vehicles:handbrake") == 1) then
		vehicle:setData("vehicles:handbrake", 0)
		vehicle:setFrozen(false)
		player:outputChat("You have released your handbrake.", 245, 227, 147)
		connection:exec("UPDATE vehicles SET handbrake=? WHERE id=? AND owner=?", 0, vehicle:getData("vehicles:id"), vehicle:getData("vehicles:owner"))
	elseif (vehicle:getData("vehicles:handbrake") == 0) then
		vehicle:setData("vehicles:handbrake", 1)
		vehicle:setFrozen(true)
		player:outputChat("You have applied your handbrake.", 245, 227, 147)
		connection:exec("UPDATE vehicles SET handbrake=? WHERE id=? AND owner=?", 1, vehicle:getData("vehicles:id"), vehicle:getData("vehicles:owner"))	
	end 
end

-- /engine [Turns off your vehicle engine]
addCommandHandler("engine", function(player,cmd)
	local acc = player:getAccount()
	local owner = acc:getName()
	local vehicle = Ped.getOccupiedVehicle(player)
	if vehicle then
		if (vehicle:getData("vehicles:owner") == owner) then
			setPlayerVehicleEngine(player, vehicle)
		else
			player:outputChat("You do not have any keys for this vehicle.", 255, 0, 0)
		end
	else
		player:outputChat("You are not in any vehicle.", 255, 0, 0)
	end
end)

function setPlayerVehicleEngine(player, vehicle)
	if (vehicle:getData("vehicles:engine") == 1) then
		vehicle:setData("vehicles:engine", 0)
		vehicle:setEngineState(false)
		player:outputChat("You have turned off your engine.", 245, 227, 147)
		connection:exec("UPDATE vehicles SET engine=? WHERE id=? AND owner=?", 0, vehicle:getData("vehicles:id"), vehicle:getData("vehicles:owner"))
	elseif (vehicle:getData("vehicles:engine") == 0) then
		vehicle:setData("vehicles:engine", 1)
		vehicle:setEngineState(true)
		player:outputChat("You have turned on your engine.", 245, 227, 147)
		connection:exec("UPDATE vehicles SET engine=? WHERE id=? AND owner=?", 1, vehicle:getData("vehicles:id"), vehicle:getData("vehicles:owner"))	
	end
end

-- /lock [Locks your vehicle]
addCommandHandler("lock", function(player,cmd) 
	local acc = player:getAccount()
	local owner = acc:getName()
	local vehicle = getNearestVehicle(player,5) or Ped.getOccupiedVehicle(player)
	if (vehicle:getData("vehicles:owner") == owner) then
		setPlayerVehicleLocked(player, vehicle)
	else
		player:outputChat("You're not near any of your vehicles.", 255, 0, 0)
	end
end)

function setPlayerVehicleLocked(player, vehicle)
	local vehname = vehicle:getName()
	if (vehicle:getData("vehicles:locked") == 1) then
		vehicle:setData("vehicles:locked", 0)
		vehicle:setLocked(false)
		player:outputChat("You have unlocked your "..vehname..".", 245, 227, 147)
		connection:exec("UPDATE vehicles SET locked=? WHERE id=? AND owner=?", 0, vehicle:getData("vehicles:id"), vehicle:getData("vehicles:owner"))
	elseif (vehicle:getData("vehicles:locked") == 0) then
		vehicle:setData("vehicles:locked", 1)
		vehicle:setLocked(true)
		player:outputChat("You have locked your "..vehname..".", 245, 227, 147)
		connection:exec("UPDATE vehicles SET locked=? WHERE id=? AND owner=?", 1, vehicle:getData("vehicles:id"), vehicle:getData("vehicles:owner"))
	end
end

function getNearestVehicle(player,distance)
	local tempTable = {}
	local lastMinDis = distance-0.0001
	local nearestVeh = false
	local pos = player:getPosition()
	local pint = player:getInterior()
	local pdim = player:getDimension()

	for _,v in pairs(getElementsByType("vehicle")) do
		local vint,vdim = getElementInterior(v),getElementDimension(v)
		if vint == pint and vdim == pdim then
			local posn = v:getPosition()
			local dis = getDistanceBetweenPoints3D(pos.x, pos.y, pos.z, posn.x, posn.y, posn.z)
			if dis < distance then
				if dis < lastMinDis then 
					lastMinDis = dis
					nearestVeh = v
				end
			end
		end
	end
	return nearestVeh
end
 