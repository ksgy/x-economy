--________________________________________________________--
-- FlyWithLua AddOn-Script for FS-Economy/X-Economy
-- This file has to be put into the Folder X-Plane/Resources/Plugins/FlyWithLua/Scripts
-- Teddii / 2014-07-03
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

-- set the screen position for text messages
xPos = 50
yPos = SCREEN_HIGHT-50
--________________________________________________________--

ColorTicker=0
do_often("ColorTicker=ColorTicker+1") --count up every second

do_every_draw([[
	fse_info()
]])
--________________________________________________________--
-- Import custom datarefs from X-Economy script
DataRef("fse_flying", "fse/status/flying")
DataRef("fse_leasetime", "fse/status/leasetime")
--________________________________________________________--

function fse_info()
	if(fse_flying) then
		if(fse_flying == 0) then
			if(ColorTicker%2==0) then
				draw_string(xPos, yPos, "FSE: NOT FLYING", "yellow")
			else
				draw_string(xPos, yPos, "FSE: NOT FLYING", "blue")
			end
		elseif(fse_flying == 1) then
			draw_string(xPos, yPos, "FSE: FLYING ("..(math.floor(fse_leasetime/360)/10).."hrs left)", "white")
		else
			draw_string(xPos, yPos, "FSE: ERROR "..fse_flying, "red") -- never happens - just in case ...
		end
	end
end
--________________________________________________________--
