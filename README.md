# KDE Plasma Wallpaper Plugin For Variety

This is a Plasma wallpaper plugin for KDE Plasma 5 to support the [Variety wallpaper manager](http://peterlevi.com/variety)
application.

## Features

- Allow setting only some Plasma desktops/activities/screens to use Variety, instead of Variety controlling all the desktops.
- Add "next" and "previous" Variety actions to the desktop's right-click menu.

## Installation

1. Download [the package](https://codeload.github.com/guss77/variety-plasma-plugin/zip/refs/heads/main?file=variety-plasma-plugin.zip)
   and extract it locally somewhere.
2. Run the `install` script.

Please note that the install script will replace the Variety custom `set_wallpaper` script installed in your user account with
a version of the script that was modified to better support the Plasma Variety Wallpaper plugin, in that the new script
will not rewrite the wallpapers on all of your desktops, just the ones where you have set up the wallpaper to use this plugin.

The install script can also be used to update the installed package to a new version - when run while the package is already
installed, it will update the package and will restart the Plasma shell automatically (this is needed when updating).

## Usage

1. Make sure Variety is installed and configured.
2. Right-click the desktop where you want to show the wallpaper from Variety and select "Configure desktop and wallpaper".
3. In the category "Wallpaper", under "Wallpaper type" - choose "Variety Wallpaper", and click "OK".
