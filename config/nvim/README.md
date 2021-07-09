# NeoVim Config

TODO add screenshont here

## Plugins

List of plugins (not all, but essential ones) that extend or change workflow in
some way.

- Linting and autocompleting
  [lsp](https://github.com/neovim/lspconfig)
  [compe]()
- Snippets
  TODO
- Fuzzy finding
  [telescope](https://github.com/nvim-telescope/telescope.nvim).

## Mappings

### Telescope
| Mappings | Action | Description |
|---|---|---|
| `<Leader>sg` | Search filenames under Git control | |
| | `Enter` | Open file at location|
| `<Leader>sd` | Search all filenames | |
| | `Enter` | Open file at location|
| `<Leader>sl` | Grep within files | |
| | `Enter` | Open file at location|
| `<Leader>sh` | Search neovim help files | |
| | `Enter` | Open help |
| `<Leader>so` | Search neovim options | |
| `<Leader>sk` | Search keymaps | |
| `<Leader>sB` | Search telescope builtins | |
| `<Leader>gw` | Grep files for word under cursor | |
| | `Enter` | Open file at location|
| `<Leader>gb` | Git branches | |
| | `Enter` | track selected branch |
| | `<C-d>` | delete selected branch |
| `<Leader>gc` | Git commits | |
| `<Leader>gd` | Git buffer commits | |
| `<Leader>gi` | Github Issues | |
| `<Leader>gr` | Github Pull Reviews | |


## Functions

Some functions, that I use. Some of which I've created myself, some were taken
from other Vim users. Feel free to use, modify, extend them.

## Language Specific Stuff

I have several autocmd groups for different languages.  The reason for not using
ft plugin, is that I may want to disable some autogroups for some languages, and
may want to use some autogroups in some languages.

Other configurations may be found  in  configuration  files  itself.   They  are
provided with comments, so it won't be big problem for you, if you  will  desire
to try my setup, to figure out what is going on here and there.  You should  pay
attention to colored marks in comment sections, like `WARNING:`, `NOTE:` etc.

If you encounter any problem with my setup, feel free to open issue,  we'll  see
what we can do here.
