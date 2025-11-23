# Charfiles

> My personal macOS dotfiles and configuration management system.

A comprehensive dotfiles repository for macOS featuring automated installation and a curated development environment. **This repository manages configurations for Neovim, Tmux, Ghostty, Bat, Git, and Fastfetch.**

## ✨ Features

- 🚀 **One-command installation** - Automated setup script (`install.sh`)
- 📦 **Homebrew package management** - Dependencies defined in `Brewfile`
- 🎨 **Unified Aesthetic** - Rose Pine theme integrated across applications
- 🛠️ **Neovim IDE** - Fully configured with LSP, Treesitter, Harpoon, and Autoclose
- ⚡ **Tmux Power** - Enhanced with FZF, SessionX, and Which-Key

## 📦 Configuration Stack

### Terminal & Shell Utilities
- **Ghostty** - Terminal emulator configuration
- **fastfetch** - System info tool (configured with custom Crab ASCII art)
- **bat** - Cat clone with custom **Rose Pine** themes

### Development Environment
- **Neovim** - Lua-based configuration using **Lazy.nvim**
  - *Key Configs:* LSP, Treesitter, Autoclose, Harpoon, Tmux Navigator
- **Tmux** - Terminal multiplexer
  - *Plugins:* Rose Pine Theme, FZF integration, SessionX (session manager), FZF-URL, Which-Key
- **Git** - Version control configuration

## 🚀 Installation

### Prerequisites

- macOS
- Admin/sudo access

### Setup

    # Clone the repository
    git clone [https://github.com/Charlynder/Charfiles.git](https://github.com/Charlynder/Charfiles.git)
    cd Charfiles

    # Run the installation script
    chmod +x install.sh
    ./install.sh

### What the installer does

- ✅ Installs Homebrew dependencies from `Brewfile`
- ✅ Creates the `~/.config` directory if missing
- ✅ Symlinks configuration folders from `src/` to your system paths
- ✅ Backs up any existing configuration files before linking

## 📁 Repository Structure

The configurations are modularized under the `src/` directory.

    Charfiles/
    ├── Brewfile               # Homebrew dependencies
    ├── CHANGELOG              # Version history
    ├── install.sh             # Installation script
    ├── README.md              # This file
    └── src
        ├── bat
        │   ├── config
        │   └── themes         # Rose Pine themes
        ├── fastfetch
        │   ├── ascii          # Custom art (crab.txt)
        │   └── config.jsonc
        ├── ghostty
        │   └── config
        ├── git
        ├── nvim
        │   ├── init.lua       # Entry point
        │   └── lua            # Plugins, LSP, Keymaps, Options
        └── tmux
            └── plugins        # Rose Pine, SessionX, FZF, Which-Key

## 🔗 Symlink Map

The `install.sh` script maps the internal `src` directories to the standard configuration paths.

### Config Directory (`~/.config/`)

    ~/.config/bat/        → ~/.charfiles/src/bat/
    ~/.config/fastfetch/  → ~/.charfiles/src/fastfetch/
    ~/.config/ghostty/    → ~/.charfiles/src/ghostty/
    ~/.config/nvim/       → ~/.charfiles/src/nvim/
    ~/.config/tmux/       → ~/.charfiles/src/tmux/

### Home Directory Files

    ~/.gitconfig          → ~/.charfiles/src/git/.gitconfig

## 🎨 Theme Information

This dotfiles suite is built around the **Rose Pine** color palette.

- **Bat:** Custom themes located in `src/bat/themes/`:
  - `rose-pine.tmTheme`
  - `rose-pine-moon.tmTheme`
  - `rose-pine-dawn.tmTheme`
- **Tmux:** Rose Pine status bar configured in `src/tmux/plugins/rose-pine/`

## ⚙️ Post-Installation

After running the install script:

1. **Neovim**: Open `nvim`. The **Lazy** package manager will automatically bootstrap and install all plugins defined in `src/nvim/lua/plugins.lua`.
   - *Note:* Language Servers (LSP) configured in `lua/lsp-config.lua` may need to be installed via Mason or Homebrew depending on your setup.
2. **Tmux**: Start a tmux session and press `prefix + I` to install/reload the plugins defined in the configuration (TPM).

## 🛡️ Backup Strategy

The install script automatically backs up existing configurations:

- Existing configs are renamed with a timestamp: `config.backup.YYYYMMDD_HHMMSS`
- Symlinks are safely removed before creating new ones
- Your original configurations are **never** deleted, only moved.

## 🐛 Troubleshooting

### Tmux plugins not loading

If `tmux-sessionx` or the theme isn't appearing:
1. Ensure you are inside a tmux session.
2. Press `prefix + I` (Install plugins).
3. Sourcing the config manually: `tmux source ~/.config/tmux/tmux.conf`

### Neovim LSP not attaching

Ensure the language servers are installed. Check the status with the command `:LspInfo` inside Neovim.

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [Homebrew](https://brew.sh) - Package manager for macOS
- [Neovim](https://neovim.io) - Modern text editor
- [Tmux](https://github.com/tmux/tmux) - Terminal multiplexer
- [Rose Pine](https://rosepinetheme.com/) - The color scheme used across bat and tmux
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Neovim plugin manager