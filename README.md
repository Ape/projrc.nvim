# projrc.nvim

**projrc.nvim** is a Neovim plugin for loading project-specific configuration
files in an extended exrc style. It searches for a `.nvim.lua` file in the
parent directories of your current file, prompts you to confirm loading it, and
persists your trust decisions across sessions.

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use 'Ape/projrc.nvim'
```

## Usage

The plugin automatically sets up an autocommand on `BufEnter` to search for
`.nvim.lua` files in parent directories of your current file.

## Security Considerations

Loading local configuration files can introduce security risks. Only use this
plugin in trusted project directories and verify the contents of any local
configuration files.

## License

This project is licensed under the [MIT License](LICENSE).
