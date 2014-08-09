--________________________________________________________--
-- FlyWithLua AddOn-Script for FS-Economy/X-Economy
-- This file has to be put into the Folder X-Plane/Resources/Plugins/FlyWithLua/Scripts
-- Teddii / 2014-07-30
-- This script will show the actual state of FSE (see attached images),
-- so you should never forget to fly without starting the flight in FSE again :-)
--
-- This is only a basic script. There are many other actions possible
-- with FlyWithLua, e.g. speak a warning text or even pause X-Plane
-- when groundspeed goes over 15kts without FSE flight started ...
-- 
-- FlyWithLua can be downloaded from: http://forums.x-plane.org/index.php?app=downloads&showfile=17468
-- User Support via X-Plane.org Forum: http://forums.x-plane.org/index.php?showforum=188
--________________________________________________________--
--History:
--
--Version 1.0 2014-07-03 Teddii
--	release
--
--Version 1.1 2014-07-30 Teddii
--	Changed text to ground/airborn 
--	FlightTime/LeaseTime are now shown in hours:min[:secs]
--
--Version 1.2 2014-08-09 Teddii
--	Added code to handle new "fse_connected" dataref
--________________________________________________________--

-- set the screen position for text messages
xPos = 50
yPos = SCREEN_HIGHT-50
--________________________________________________________--
--________________________________________________________--
--________________________________________________________--

ColorTicker=0
do_often("ColorTicker=ColorTicker+1") --count up every second

do_every_draw([[
	fse_info()
]])
--________________________________________________________--
-- Import custom datarefs from X-Economy script
DataRef("fse_connected", 	"fse/status/connected")
DataRef("fse_flying",       "fse/status/flying")
DataRef("fse_leasetime",    "fse/status/leasetime")
DataRef("fse_flighttime",   "fse/status/flighttime")
--________________________________________________________--

function fse_info()
	flightTimeString = string.format("%02i:%02i:%02i",math.floor(fse_flighttime/3600),math.floor((fse_flighttime%3600)/60),(fse_flighttime%60))
	leaseTimeString  = string.format("%02i:%02i",     math.floor(fse_leasetime/3600), math.floor((fse_leasetime%3600)/60))

	if(fse_connected) then -- check if dataref is NIL
		if(fse_connected==0) then
			if(ColorTicker%2==0) then
				draw_string(xPos, yPos, "FSE: offline", "yellow")
			else
				draw_string(xPos, yPos, "FSE: offline", "red")
			end
		else
			if(fse_flying) then -- check if dataref is NIL
				if(fse_flying == 0) then
					if(ColorTicker%2==0) then
						draw_string(xPos, yPos, "FSE: departing", "yellow")
					else
						draw_string(xPos, yPos, "FSE: departing", "blue")
					end
				elseif(fse_flying == 1) then
					draw_string(xPos, yPos, "FSE: enroute "..flightTimeString.." ("..leaseTimeString.." left)", "white")
				else
					draw_string(xPos, yPos, "FSE: ERROR "..fse_flying, "red") -- never happens - just in case ...
				end
			end
		end -- endif "connected"
	end -- endif fse_connected exist
end -- end function fse_info()
--________________________________________________________--
