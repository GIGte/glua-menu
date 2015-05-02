# glua-menu
This is a remake of GMod's standard menu which does not use HTML, it is written completely in Lua.

The reason is that HTML makes the menu slower and less responsive.

Initially, the work was not planned as a serious project, so it is not pretending to be something new or to give you an experience of a complete product.

The goal is to make a menu similar to the standard one but using Lua solely.

Only the most essential is done by now:
 - Main screen (100%)
 - New game page (80%)
 - Addons (30%)

##Installation
Go to %STEAMAPPS%/GarrysMod/garrysmod/lua/menu

You can either<br>
 1) copy the files inside this folder or<br>
 2) clone the repo right to lua/menu directory.<br>

Mind that in both cases you will have to replace menu.lua which can be recovered by Steam (on game update or cache checking).

##Misc
Use _menu_swap_ command to switch between the old and the new menu. The current menu is saved and opened on the next game start.
