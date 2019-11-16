vim-browser-tabs
================

Vim plugin to fuzzy search tabs opened in all the browser windows and switch.

![Demo](https://i.imgur.com/kTJeHp9.gif)

Installation
============

| Plugin Manager | Install with... |
| ------------- | ------------- |
| [Pathogen][1] | `git clone https://github.com/vipul-sharma20/vim-browser-tabs ~/.vim/bundle/vim-browser-tabs`<br/>Remember to run `:Helptags` to generate help tags |
| [NeoBundle][2] | `NeoBundle 'vipul-sharma20/vim-browser-tabs'` |
| [Vundle][3] | `Plugin 'vipul-sharma20/vim-browser-tabs'` |
| [Plug][4] | `Plug 'vipul-sharma20/vim-browser-tabs'` |
| [VAM][5] | `call vam#ActivateAddons([ 'vim-browser-tabs' ])` |
| [Dein][6] | `call dein#add('vipul-sharma20/vim-browser-tabs')` |
| [minpac][7] | `call minpac#add('vipul-sharma20/vim-browser-tabs')` |
| manual | copy all of the files into your `~/.vim` directory |

Configuration
=============

* This plugin mandatorily requires [fzf.vim](https://github.com/junegunn/fzf.vim). Please find the installation instruction for it [here](https://github.com/junegunn/fzf.vim#installation)

* Browser name to fetch tabs from. Eg: Chrome Browser, Brave etc.

  `let g:browser_tabs_default_browser='Brave'`

* Window layout for browser tab list result. Can be 'default' or 'floating'

  `let g:browser_tabs_window_layout='floating'`

**Note: Floating window layout support is only possible in Neovim version >= 0.4.x.**

Documentation
=============

`:h vim-browser-tabs`

or check [here][9]

Commands
========

| Command              | List                                         |
| ---                  | ---                                          |
| `GetBrowserTabs`     | Fetches all the opened tabs from the browser |

I recommend you to check documentation for better understanding

Notes
=====

* At this point, this plugin only works on MacOS since I am using a little AppleScript.
* This plugin was tested on Chrome Browser and Brave.

Therefore the next features in priority are:

* Make the plugin compatible with Linux first and then Windows.
* Add support for Firefox.

Screenshots
===========

### Floating window view

![floating](https://i.imgur.com/r2Is7jw.png)

### Default view

![default](https://i.imgur.com/5RXkn9J.png)

License
=======

MIT

[1]: https://github.com/tpope/vim-pathogen
[2]: https://github.com/Shougo/neobundle.vim
[3]: https://github.com/VundleVim/Vundle.vim
[4]: https://github.com/junegunn/vim-plug
[5]: https://github.com/MarcWeber/vim-addon-manager
[6]: https://github.com/Shougo/dein.vim
[7]: https://github.com/k-takata/minpac/
[8]: https://cricbuzz.com
[9]: doc/vim-browser-tabs.txt
