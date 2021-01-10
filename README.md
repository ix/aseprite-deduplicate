Deduplicate Tiles for Aseprite
====================

A Lua script (for Aseprite) which deduplicates tiles in the active sprite.

Ideal for working with fixed-grid tilesheets, this script will keep only the first instance of each tile it encounters.

![Demonstrational video](deduplicate.gif)

Installation:

_Linux:_
```
cp Deduplicate\ Tiles.lua ~/.config/aseprite/scripts/
```

_Other platforms:_
See [here](https://community.aseprite.org/t/aseprite-scripts-collection/3599)

The script will then be available from `File -> Scripts -> Deduplicate Tiles`, just use the included settings dialog to choose your preferences and you're good to go!

Have fun and report any bugs or issues on the Issues page. Future improvements may include selecting the "clear" color, outputting to a new image tab and deduplicating only a selection.