# Charfiles

> My personal macOS dotfiles and configuration management system

A comprehensive dotfiles repository for macOS featuring automated installation, modern terminal tooling, and a carefully curated development environment.

## ✨ Features

- 🚀 **One-command installation** - Automated setup script with progress indicators
- 📦 **Homebrew package management** - All dependencies defined in Brewfile
- 🔗 **Intelligent symlinking** - Automatic config file management with backup
- 🎨 **Modern terminal stack** - Neovim, Tmux, Zsh with Zim framework
- 🛠️ **Developer tools** - Git, GitHub CLI, build tools, and more
- 🎯 **Window management** - Rectangle for keyboard-driven window control

## 📦 What's Included

### Terminal & Shell
- **Zsh** with [Zim framework](https://github.com/zimfw/zimfw) - Fast, modular plugin manager
- **Starship** - Modern, customizable prompt
- **Ghostty**, **WezTerm**, **Warp** - Multiple terminal emulator options

### Development Tools
- **Neovim** - Modern Vim-based editor with Lua configuration
- **Tmux** - Terminal multiplexer with custom theme and plugins
- **Git** - Version control with custom configuration
- **GitHub CLI** - GitHub from the command line

### CLI Utilities
- **bat** - Cat clone with syntax highlighting
- **eza** - Modern ls replacement
- **fzf** - Fuzzy finder
- **ripgrep** - Fast search tool
- **btop** - System monitor
- **gum** - Beautiful shell scripts
- **fastfetch** - System information tool
- **zoxide** - Smart directory jumper

### Languages & Build Tools
- Python 3.13
- Lua with LuaRocks
- Crystal
- GCC

### Applications
- **Rectangle** - Window management
- **OBS** - Screen recording
- **LocalSend** - Cross-platform file sharing
- **Podman Desktop** - Container management

## 🚀 Installation

### Prerequisites

- macOS (Apple Silicon or Intel)
- Admin/sudo access

### Quick Install

**Option 1: One-line install (recommended)**

```bash
# Using curl
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Charlynder/Charfiles/main/install.sh)"

# Or using wget
bash -c "$(wget -qO- https://raw.githubusercontent.com/Charlynder/Charfiles/main/install.sh)"
```

**Option 2: Clone and install**

```bash
# Clone the repository
git clone https://github.com/Charlynder/Charfiles.git
cd Charfiles

# Run the installation script
chmod +x install.sh
./install.sh
```

### What the installer does

1. ✅ Installs Homebrew (if needed)
2. ✅ Installs gum for beautiful UI
3. ✅ Installs all packages from Brewfile
4. ✅ Creates `~/.config` directory
5. ✅ Clones repository to `~/.charfiles`
6. ✅ Creates symlinks for all configurations
7. ✅ Backs up existing configs automatically
8. ✅ Installs Zim framework for zsh
9. ✅ Cleans up installation files

## 📁 Structure

```
Charfiles/
├── bat/                    # bat (cat alternative) config & themes
├── fastfetch/              # System info tool config
├── ghostty/                # Ghostty terminal config
├── git/                    # Git global configuration
├── macTerminal/            # macOS Terminal.app profile
├── nvim/                   # Neovim configuration (Lua)
├── rectangle/              # Rectangle window manager settings
├── tmux/                   # Tmux config with plugins
├── zim/                    # Zim framework configuration
├── zsh/                    # Zsh config, aliases, and themes
├── Brewfile               # Homebrew dependencies
├── CHANGELOG              # Version history
└── install.sh             # Installation script
```

## 🔗 Symlink Map

After installation, configurations are symlinked as follows:

### Config Directory (`~/.config/`)
```
~/.config/bat/          → ~/.charfiles/bat/
~/.config/fastfetch/    → ~/.charfiles/fastfetch/
~/.config/ghostty/      → ~/.charfiles/ghostty/
~/.config/macTerminal/  → ~/.charfiles/macTerminal/
~/.config/nvim/         → ~/.charfiles/nvim/
~/.config/rectangle/    → ~/.charfiles/rectangle/
~/.config/tmux/         → ~/.charfiles/tmux/
~/.config/zsh/          → ~/.charfiles/zsh/
```

### Home Directory Dotfiles
```
~/.zshrc        → ~/.charfiles/zsh/.zshrc
~/.aliases.zsh  → ~/.charfiles/zsh/aliases.zsh
~/.zimrc        → ~/.charfiles/zim/.zimrc
~/.gitconfig    → ~/.charfiles/git/.gitconfig
~/.tmux.conf    → ~/.charfiles/tmux/tmux.conf
```

## ⚙️ Post-Installation

After installation, you'll need to:

1. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

2. **Review configurations** in `~/.config/` and customize as needed

3. **Update Zim plugins** (if you modified `.zimrc`):
   ```bash
   zimfw install
   ```

4. **Sync Neovim plugins**:
   ```bash
   nvim
   # Lazy.nvim will auto-install plugins on first launch
   ```

## 🔄 Updating

To update your configurations:

```bash
cd ~/.charfiles
git pull origin main
```

Configuration changes will be reflected immediately since everything is symlinked.

To update packages:

```bash
brew update && brew upgrade
```

## 🛡️ Backup Strategy

The install script automatically backs up existing configurations:

- Existing configs are renamed with timestamp: `config.backup.YYYYMMDD_HHMMSS`
- Symlinks are safely removed before creating new ones
- Your original configurations are never deleted

## 🎨 Customization

### Zsh
- Edit `~/.charfiles/zsh/.zshrc` for shell configuration
- Edit `~/.charfiles/zsh/aliases.zsh` for custom aliases
- Modify `~/.charfiles/zim/.zimrc` for Zim plugins

### Neovim
- Main config: `~/.charfiles/nvim/init.lua`
- Lua modules: `~/.charfiles/nvim/lua/`

### Tmux
- Config: `~/.charfiles/tmux/tmux.conf`
- Plugins managed via TPM

### Git
- Edit `~/.charfiles/git/.gitconfig` for Git settings

## 🐛 Troubleshooting

### Homebrew not in PATH
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon
# or
eval "$(/usr/local/bin/brew shellenv)"     # Intel
```

### Zim not loading
```bash
zimfw install
```

### Tmux plugins not working
```bash
# Inside tmux, press:
prefix + I  # Install plugins (usually Ctrl+b then Shift+i)
```

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [Zim Framework](https://github.com/zimfw/zimfw) - Zsh plugin manager
- [Homebrew](https://brew.sh) - Package manager for macOS
- [Neovim](https://neovim.io) - Modern text editor
- [Tmux](https://github.com/tmux/tmux) - Terminal multiplexer
- [Charm](https://charm.sh) - Beautiful CLI tools (gum)
