# Vehicle System 0.26d 
#### (Required Resource(s): [cpicker](https://community.multitheftauto.com/index.php?p=resources&s=details&id=3247))

![alt text](https://i.imgur.com/jfHD7fP.png)
> A freeroam-rpg based vehicle system with a variety of features. This version is much more expandable, also open-source so you can freely edit, adjust and configure to your own needs.
#
> Features
- Ability to purchase a car.
- Automatically fetch shops from table, and assign vehicles with prices.
- A panel located on F2 which shows your vehicles and lets you spawn them to you.
- Use the following features of /engine, /handbrake, /park and /lights. These are also binded on J - Engine, L - Lights.
- Players can enter your vehicles if they are not locked.
- Carshop Structure improved, more RPG feeling with icons next to them and generated GUI's.
- Shops expanded, now includes a Bike Shop and 2 more Carshop Locations in Los Santos; this can be configured in ```g_carshops.lua```.
>Commands
- /lock or Press K: This locks your vehicle, if you are near your vehicle it will also lock it.
- /lights or Press L: This allows you to turn on/off your vehicle lights.
- /engine or Press J: This will allow you toggle your engine.
- /park: This allows you to park your vehicle, which saves it's current position in-case of server/script restarts.
- /handbrake: This allows you to put a handbrake on your vehicle, it'll disable player vehicle pushing.
- F2: Toggles menu which shows your owned vehicles and allows you to spawn them with you in it.

#
>Configuration
1. To install the script simply drag and drop it in your ```resources``` folder and press start, make sure you also download the required resource - [cpicker](https://community.multitheftauto.com/index.php?p=resources&s=details&id=3247) - 
In your mtaserver.conf add the following resource: ```<resource src="vehicle-system" startup="1" protected="0" />```
2. If you'd like to add more shops, there's an example left in ```g_shops.lua``` simply copy and paste that to add more shops.

>Bugs

If you find any bugs, please contact me,
Discord: FlyingSpoon#6633

##### Screenshots
![alt text](https://i.imgur.com/BDgjRLN.png)
![alt text](https://i.imgur.com/qrunw4H.png)
