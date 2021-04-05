# glua-menu
This is a remake of GMod's standard menu. It is written completely in Lua and does not involve HTML.

The reason is that HTML makes the menu slower and less responsive.

Initially, the work was not planned as a serious project, so it is not pretending to be something new or to give you an experience of a complete product.

The goal is to make a menu similar to the standard one but using Lua solely.

Many things are done already:
 - Main screen (100%)
 - New game page (90%)
 - Server browser (80%)
 - Addons (30%)

What is not done:
 - Saves, Demos pages
 - Trending addons
 - Kinect support

## Installation
Go to %STEAMAPPS%/GarrysMod/garrysmod/lua/menu

There are two ways to install the menu:<br>
 1) copy the files inside this folder or<br>
 2) clone the repo right to lua/menu directory.

Mind that in both cases you will have to replace menu.lua which can be recovered by Steam (when you get an update or do a cache checking).

## Misc
Use _menu_swap_ command to switch between the old and the new menu. The current menu is saved and opened on the next game start.
