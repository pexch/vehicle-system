local connection_type = "sqlite";
local database = "data/vehicles.db";
connection = dbConnect(connection_type, database);

if connection then 
	local exec = connection:exec([[
	CREATE TABLE IF NOT EXISTS `vehicles` (
		`id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
		`owner` int(11) NOT NULL,
		`vehid` int(11) NOT NULL,
		`location` text,
		`rotation` text,
		`color` text,
		`engine` int(11) NOT NULL,
		`handbrake` int(11) NOT NULL,
		`health` int(11) NOT NULL,
		`interior` int(11) NOT NULL,
		`dimension` int(11) NOT NULL,
		`locked` int(11) NOT NULL,
		`lights` int(11) NOT NULL
		);
	]]);
	outputDebugString("[Vehicles] Connected to vehicles.db")
end
