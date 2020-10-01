# 🐟 fin.vim

![Support Vim 8.1 or above](https://img.shields.io/badge/support-Vim%208.1%20or%20above-yellowgreen.svg)
![Support Neovim 0.4 or above](https://img.shields.io/badge/support-Neovim%200.4%20or%20above-yellowgreen.svg)
[![Powered by vital.vim](https://img.shields.io/badge/powered%20by-vital.vim-80273f.svg)](https://github.com/vim-jp/vital.vim)
[![Powered by vital-Whisky](https://img.shields.io/badge/powered%20by-vital--Whisky-80273f.svg)](https://github.com/lambdalisue/vital-Whisky)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20fin-orange.svg)](doc/fin.txt)

Fin is a plugin to filter buffer content in-place without modification.
It's written in pure Vim script.

**UNDER DEVELOPMENT: It is in alpha stage. Any changes will be applied without any announcement.**

## Installation

fin.vim has no extra dependencies so use your favorite Vim plugin manager.

## Usage

```
:Fin
```

Or use with `{after}` like

```
:botright copen | Fin -after=\<CR> | cclose
```

## License

The code in fin.vim follows MIT license texted in [LICENSE](./LICENSE).
Contributors need to agree that any modifications sent in this repository follow the license.
