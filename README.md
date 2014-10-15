# X-Economy

This is a plugin for [X-Plane](http://x-plane.com), to connect and use [FSEconomy](http://www.fseconomy.net/).
The plugin uses Sandy Barbour's [Python interface](http://www.xpluginsdk.org/python_interface.htm), so plugin may work on Mac, Linux and Windows too.


# How to install

1. Download latest version of [X-Economy](https://github.com/ksgy/x-economy/releases)
2. Download [Python 2.7.x](http://www.python.org/download/releases/)
3. Install Python 2.7.x (just follow the installer instructions)
4. Download [Python interface](http://www.xpluginsdk.org/python_interface.htm)
5. Unzip the contents of PythonInterface.zip into the "resources/plugins" folder of X-Plane
6. Now you should have a "PythonInterface" folder in the "plugins" folder
7. In the "plugins" folder create a "PythonScripts" folder
8. Copy X-Economy (PI_xfse.py) to "folderPythonScripts"
9. Start X-Plane
10. From the "Plugins" menu choose "X-Economy"->"Open"
11. Type your username and password, press "Start flight" (the weigth and fuel automatically set by the plugin!)
12. You're ready for take off

...and of course, it's highly recommended to read the [FSE Manual](https://sites.google.com/site/fseoperationsguide/) :)


# Modifying your plane so that fse recognizes it

You will need to edit your planes in XPlane to match FSE's... Kinda the same process we have right now for FS9 and FSX, but its quite different in X-Plane.

1. In FSeconomy.com, find the plane you want to fly in the Home -> List of Aircraft page and make a note of the type of plane you want.
2. Open X-Economy menu from Plugins and select "Set aircraft alias". Enter Aircraft name and press "Set"
3. Prepare your flight as you normally do and go flight...
4. After landing, taxi to parking and set parking brake (V key by default) and shut down all engines.


# Time compression in x-plane

- Time compression in v9 has to be assigned a key. In the Settings > Joystick & Equipment > Keys menu, scroll most of the way to the bottom and find the 'operation/flightmodel_speed_change' line and set an appropriate keystroke. The keystroke will cycle you through x1, x2, x4, x6, x1 and so on. Be advised though that in using time compression the flight model is making bigger jumps between frames and weird plane behavior can result. I recommend that you set the flight models per frame in the 'Settings > Operations and Warnings' menu to at least 2. Also be aware that when using time compression, X-Plane will reduce the visibility to keep the frame rate from getting too low.


# Contribution

If you'd like to add a feature, just fork X-Economy and create a [Pull Request](https://help.github.com/articles/using-pull-requests)


# Thanks

Thanks to Andrew, Nikos, Venom and all the X-Plane guys for their help and input :)


# License
The MIT License
