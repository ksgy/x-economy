--________________________________________________________--
-- FlyWithLua AddOn-Script for FS-Economy/X-Economy
-- This file has to be put into the Folder X-Plane/Resources/Plugins/FlyWithLua/Scripts
-- Teddii / 2014-07-30
-- This script will show a small interface to interact with the X-Economy Script.
-- It's only shown, if your mouse hover over the area of the interface.
-- You might what to change the position of the interface below.
--
-- This script is based on Carsten Lynker's "quick settings.lua", that came with FlyWithLua.
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
--Version 1.0 2014-07-30 Teddii
--	release
--
--Version 1.1 2014-08-09 Teddii
--	Added code to handle new "fse_connected" dataref
--	Added an option to always show the interface when "departing"
--
--Version 1.2 2014-08-19 Teddii
--	Removed the code fragment that draws a box in the lower left corner
--
--Version 1.3 2014-11-30 Teddii
--	Added code to handle new "fse_airborne" dataref
--
--Version 1.4 2014-12-19 Teddii
--	Added code to show a warning, if gear is not compatible with new XFSE client
--
--Version 1.5 2014-12-20 Teddii
--	Added menu entry "plugins/FlyWithLua_Macros/Always show FSE-Interface on ground" to switch visibility on/off
--
--Version 1.6 2015-01-09 Teddii
--	Added some code to work around the DataRef Update issue
--  Added menu entry to switch off window while "departing"
--	Removed code to show a warning, if gear is not compatible with new XFSE client
--________________________________________________________--

--position of the interface
local XMin=50
local YMin=770 --770 is also good

--set your lease time left warning in seconds
local LeaseTimeLeftWarnSecs=1800

--set to "false" if you want to see the interface only when hovering the mouse over it
gAlwaysShowFseInterfaceOnGround=true
gAlwaysShowFseInterfaceDeparting=true

--________________________________________________________--
--________________________________________________________--
--________________________________________________________--
--________________________________________________________--
--________________________________________________________--
--________________________________________________________--
--________________________________________________________--
--________________________________________________________--
--________________________________________________________--

add_macro("Always show FSE-Interface when on ground", "gAlwaysShowFseInterfaceOnGround=true", "gAlwaysShowFseInterfaceOnGround=false", "activate")
add_macro("Always show FSE-Interface when departing", "gAlwaysShowFseInterfaceDeparting=true", "gAlwaysShowFseInterfaceDeparting=false", "activate")
--________________________________________________________--


require "graphics"
--________________________________________________________--

DataRef("fse_connected", 	"fse/status/connected")
DataRef("fse_flying",       "fse/status/flying")
DataRef("fse_airborne",     "fse/status/airborne")
DataRef("fse_leasetime",    "fse/status/leasetime")
DataRef("fse_flighttime",   "fse/status/flighttime")
dataref("datRAlt", 			"sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
--________________________________________________________--

XMax=XMin+130
YMax=YMin+80
showCancelC = false
--________________________________________________________--

-- it seems that the datarefs are only read when there's a do_every_frame() or do_often() action defined!
-- work around: this adds a dummy handler that does basically nothing, but triggers reading of the DRs
do_every_frame("fse_interface_do()")
function fse_interface_do() end

--________________________________________________________--

do_on_mouse_click("fse_interface_events()")
do_every_draw("fse_interface_info()")
--________________________________________________________--

local mouseHover
function fse_interface_info()
	mouseHover=true
	-- does we have to draw anything?
	if MOUSE_X < XMin or MOUSE_X > XMax or MOUSE_Y < YMin or MOUSE_Y > YMax then
		mouseHover=false
	end

	if(mouseHover==false) then
		if(fse_flying==0 and gAlwaysShowFseInterfaceOnGround==false) then
			return
		end
		if(fse_flying==1 and gAlwaysShowFseInterfaceDeparting==false) then
			return
		end
		if(fse_airborne==1 and fse_leasetime>=LeaseTimeLeftWarnSecs) then
			return
		end
	end
	
	-- init the graphics system
	XPLMSetGraphicsState(0,0,0,1,1,0,0)

	-- draw transparent backgroud
	graphics.set_color(0, 0, 0, 0.5)
	graphics.draw_rectangle(XMin, YMin, XMax, YMax)

	--if(datOnGround~=0) then
	--	draw_string_Helvetica_10(XMin+5, YMin+85, "Plane is ON GROUND!")
	--end
	
	-- draw lines around the hole block
	if(fse_connected==0) then
		graphics.set_color(0.8, 0.8, 0.8, 0.5) 	 --grey
	else
		if(fse_flying==0) then
			graphics.set_color(1, 0, 0, 0.5) 	 --red
		elseif(fse_airborne==0) then -- fse_flying==0 AND fse_airborne==0
			if(datRAlt<20)
			then
				graphics.set_color(1, 1, 0, 0.5) --yellow
			else
				graphics.set_color(1, 0, 0, 0.5) --red
			end
		elseif(fse_leasetime<LeaseTimeLeftWarnSecs) then -- fse_flying==0 AND fse_airborne==0
			graphics.set_color(1, 1, 0, 0.5) 	 --yellow
		else -- flying and airborne =1
			graphics.set_color(0, 1, 0, 0.5)
		end
	end
	graphics.set_width(2)
	graphics.draw_line(XMin, YMin, XMin, YMax)
	graphics.draw_line(XMin, YMax, XMax, YMax)
	graphics.draw_line(XMax, YMax, XMax, YMin)
	graphics.draw_line(XMax, YMin, XMin, YMin)

	graphics.draw_line(XMin, 	YMin+30, XMax-1,  YMin+30) 	--hor
	graphics.draw_line(XMin+35, YMin+1,  XMin+35, YMin+30)	--vert1
	graphics.draw_line(XMin+40, YMin+1,  XMin+40, YMin+30)	--vert2
	graphics.draw_line(XMin+80, YMin+1,  XMin+80, YMin+30)	--vert3

	graphics.set_color(1, 1, 1, 0.8)

	if(fse_connected==0) then
			draw_string_Helvetica_10(XMin+5, YMin+67,     "Status            : offline")
	else
		if(fse_flying==0) then
			draw_string_Helvetica_10(XMin+5, YMin+67,     "Status            : on ground")
		else
			if(fse_airborne==0) then
				draw_string_Helvetica_10(XMin+5, YMin+67, "Status            : departing")
			else
				draw_string_Helvetica_10(XMin+5, YMin+67, "Status            : enroute")
			end
			str=string.format("Flight Time      : %02i:%02i:%02i",math.floor(fse_flighttime/3600),math.floor((fse_flighttime%3600)/60),(fse_flighttime%60))
			draw_string_Helvetica_10(XMin+5, YMin+52, str)
			str=string.format("Lease Time left: %02i:%02i:%02i",math.floor(fse_leasetime/3600),math.floor((fse_leasetime%3600)/60),(fse_leasetime%60))
			draw_string_Helvetica_10(XMin+5, YMin+37, str)
		end
	end
	
	if(fse_connected==0) then
			draw_string_Helvetica_10(XMin+88, YMin+11, "LOGIN")
	else
		if(fse_flying==0) then
			draw_string_Helvetica_10(XMin+5, YMin+17, "Start")
			draw_string_Helvetica_10(XMin+5, YMin+5,  "Flight")
			showCancelC=false
		else
			draw_string_Helvetica_10(XMin+45, YMin+17, "Cancel")
			draw_string_Helvetica_10(XMin+45, YMin+5,  " ARM")
		end
		if(showCancelC) then
			draw_string_Helvetica_10(XMin+85, YMin+17, "Cancel")
			draw_string_Helvetica_10(XMin+85, YMin+5,  "Confirm")
		end
	end

end
--________________________________________________________--

function fse_interface_events()
	-- we will only react once
	if MOUSE_STATUS ~= "down" then
		return
	end
	
	if MOUSE_X > XMin+5 and MOUSE_X < XMin+35 and MOUSE_Y > YMin+5 and MOUSE_Y < YMin+25 then
		command_once("fse/flight/start")
		RESUME_MOUSE_CLICK = false
	end
	if MOUSE_X > XMin+50 and MOUSE_X < XMin+70 and MOUSE_Y > YMin+5 and MOUSE_Y < YMin+25 then
		command_once("fse/flight/cancelArm")
		showCancelC=true
		RESUME_MOUSE_CLICK = false
	end
	if MOUSE_X > XMin+90 and MOUSE_X < XMin+120 and MOUSE_Y > YMin+5 and MOUSE_Y < YMin+25 then
		if(fse_connected==0) then
			command_once("fse/server/connect")
		else
			command_once("fse/flight/cancelConfirm")
		end
		RESUME_MOUSE_CLICK = false
	end
	if MOUSE_X > XMin+5 and MOUSE_X < XMax-5 and MOUSE_Y > YMin+35 and MOUSE_Y < YMax-5 then
		command_once("fse/window/toggle")
		RESUME_MOUSE_CLICK = false
	end
end
--________________________________________________________--
