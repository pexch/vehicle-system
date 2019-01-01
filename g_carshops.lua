version="0.26" -- Leave this, it checks with the online version, stay up to date.

shops = {
	--[[
	["Your Shop Name"] = {
		blip = {x,y,z}, -- Blip Location
		information = "Your Shop Name: A description about your shop",
		spawn_location = {x,y,z}, -- Spawn location after player purchases their vehicle
		
		["vehs"] = { -- Table for vehicles
			x, y, z = Of where shop vehicle will be spawned, price is the how much it will cost
			{"Vehicle Name", x, y, z, price = 15000},	
			-- You can view vehicle names here: https://wiki.multitheftauto.com/wiki/Vehicle_IDs#Aircrafts
		},
	}
	]]--
	
	["Grotti"] = {
		-- X, Y, Z, Icon
		blip = {2127.28711, -1144.65015, 24.765824, 55},
		-- Information about the shop
		information = "Grotti Cars: Luxury Cars at your service. Pick your favourite today, and get it delivered to you within seconds.",
		-- Spawn Location After Purchasing
		spawn_location = {557.18512, -1267.67297, 17.24219},
		
		["vehs"] = {
			-- Carname, X, Y, Z, Price
			-- First Line
			{"Banshee", 521.91510, -1289.17407, 16.76052, price = 80000},
			{"Bullet", 525.91510, -1289.17407, 16.76052, price = 45000},
			{"Cheetah", 529.91510, -1289.17407, 16.76052, price = 60000},
			{"Comet", 533.91510, -1289.17407, 16.76052, price = 35000},
			{"Elegy", 537.91510, -1289.17407, 16.76052, price = 48000},
			{"Flash", 541.91510, -1289.17407, 16.76052, price = 35000},
			{"Hotknife", 545.91510, -1289.17407, 16.76052, price = 30000},
			{"Hotring Racer", 549.91510, -1289.17407, 16.76052, price = 80000},
			{"Infernus", 553.91510, -1289.17407, 16.76052, price = 95000},
			{"Jester", 557.91510, -1289.17407, 16.76052, price = 65000},
			-- Second Line
			{"Stratum", 525.91510, -1283.17407, 16.76052, price = 25000},
			{"Sultan", 529.91510, -1283.17407, 16.76052, price = 58000},
			{"Super GT", 533.91510, -1283.17407, 16.76052, price = 30000},
			{"Turismo", 537.91510, -1283.17407, 16.76052, price = 90000},
			{"Uranus", 541.91510, -1283.17407, 16.76052, price = 19000},
			{"Windsor", 545.91510, -1283.17407, 16.76052, price = 19500},
			{"ZR-350", 549.91510, -1283.17407, 16.76052, price = 40000},
		},
	},
	
	["Coutt"] = {
		-- X, Y, Z, Icon
		blip = {551.03027, -1277.20056, 16.76653, 55},
		-- Information about the shop
		information = "Coutt and Schutz: Grab yourself a bargain today, no need to wait get it delivered to you instantly. All our cars are checked, and are very affordable!",
		-- Spawn Location After Purchasing
		spawn_location = {2123.33472, -1118.99072, 25.33809},
		["vehs"] = {
			-- Carname, X, Y, Z, Price
			-- First Line
			{"Admiral", 2118.39941, -1146.26379, 24.4903, price = 25000},
			{"Alpha", 2122.39941, -1146.26379, 24.4903, price = 25000},
			{"Blista Compact", 2126.39941, -1146.26379, 24.4903, price = 25000},
			{"Bravura", 2130.39941, -1146.26379, 24.4903, price = 25000},
			{"Elegant", 2134.39941, -1146.26379, 24.4903, price = 25000},
			-- Second Line
			{"Emperor", 2118.39941, -1138.26379, 24.8, price = 25000},
			{"Club", 2122.39941, -1138.26379, 24.8, price = 25000},
			{"Merit", 2126.39941, -1138.26379, 25, price = 25000},
			{"Euros", 2130.39941, -1138.26379, 25.2, price = 25000},
			{"Fortune", 2134.39941, -1138.26379, 25.4, price = 25000},
			-- Third Line
			{"Stafford", 2118.39941, -1131.26379, 25, price = 25000},
			{"Willard", 2122.39941, -1131.26379, 25, price = 25000},
			{"Vincent", 2126.39941, -1131.26379, 25.3, price = 25000},
			{"Primo", 2130.39941, -1131.26379, 25.3, price = 25000},
			{"Tampa", 2134.39941, -1131.26379, 25.3, price = 25000},
		},
	},
	
	["Los Santos Bikes"] = {
		-- X, Y, Z, Icon
		blip = {1885.75696, -1863.92102, 13.57699, 55},
		-- Information about the shop
		information = "Los Santos Bikes: Find your favourite bike for the cheapest possible price, all bikes are refurbished and are like new!",
		-- Spawn Location After Purchasing
		spawn_location = {1879.12256, -1862.72034, 13.57831},
		
		["vehs"] = {
			-- Carname, X, Y, Z, Price
			-- First Line
			{"BF-400", 1871.62439, -1877.14917, 13.48080, price = 15000},
			{"Bike", 1874.62439, -1877.14917, 13.48080, price = 15000},
			{"BMX", 1878.62439, -1877.14917, 13.48080, price = 15000},
			{"Faggio", 1882.62439, -1877.14917, 13.48080, price = 15000},
			{"FCR-900", 1886.62439, -1877.14917, 13.48080, price = 15000},
			{"Freeway", 1890.62439, -1877.14917, 13.48080, price = 15000},
			-- Second Line
			{"Mountain Bike", 1874.62439, -1873.14917, 13.48080, price = 15000},
			{"NRG-500", 1878.62439, -1873.14917, 13.48080, price = 15000},
			{"PCJ-600", 1882.62439, -1873.14917, 13.48080, price = 15000},
			{"Sanchez", 1886.62439, -1873.14917, 13.48080, price = 15000},
			{"Wayfarer", 1890.62439, -1873.14917, 13.48080, price = 18000},
	
		},
	},
}