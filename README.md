# Configuration for NeoVim based personal IDE

## Installation of new language

To add new LSP it is required to:
- add it to nvim-lspconfig.lua 
- add the same one to `ensure_install` section of mason.lua
- finally, add language name to treesitter.lua 

## Installation of new formatter

To add new formatter it is required to:
- add it to conform.lua
- add the same one to `ensure_install` section of mason.lua 
