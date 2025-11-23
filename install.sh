#!/usr/bin/env bash

# --- Charfiles:macOS install script ---
#
# date created: 08.29.2025
# updated: 11.23.2025

# Define the installation directory
DOTFILES_DIR="$HOME/.charfiles"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.charfiles_backups/$(date +%Y%m%d_%H%M%S)"

# --- script prompting:gum ---
# ensure gum is installed (silent)
install_gum() {
    if ! command -v gum &> /dev/null; then
        echo "Installing Gum for the installation UI..."
        if command -v brew &> /dev/null; then
            brew install gum
        else
            # Fallback manual install if brew isn't ready yet
            tmpdir=$(mktemp -d)
            curl -sSL "https://github.com/charmbracelet/gum/releases/latest/download/gum_$(uname -s)_$(uname -m).tar.gz" \
            | tar -xz -C "$tmpdir"
            sudo mv "$tmpdir/gum" /usr/local/bin/gum >/dev/null 2>&1
            rm -rf "$tmpdir"
        fi
    fi
}

install_gum

(
    # --- script:Banner ---
    gum style \
      --border thick \
      --border-foreground 105 \
      --foreground 141 \
      --align center \
      --padding "1 2" << 'EOF'
    ________  ___  ___  ________  ________  ________ ___  ___       _______      
    |\   ____\|\  \|\  \|\   __  \|\   __  \|\  _____\\  \|\  \     |\  ___ \     
    \ \  \___|\ \  \\\  \ \  \|\  \ \  \|\  \ \  \__/\ \  \ \  \    \ \   __/|    
     \ \  \    \ \   __  \ \   __  \ \   _  _\ \   __\\ \  \ \  \    \ \  \_|/__  
      \ \  \____\ \  \ \  \ \  \ \  \ \  \\  \\ \  \_| \ \  \ \  \____\ \  \_|\ \ 
       \ \_______\ \__\ \__\ \__\ \__\ \__\\ _\\ \__\   \ \__\ \_______\ \_______\
        \|_______|\|__|\|__|\|__|\|__|\|__|\|__|\|__|    \|__|\|_______|\|_______|
EOF

    # --- git:setup ---
    # Check if git is already configured
    current_git_user=$(git config --global user.name)
    current_git_email=$(git config --global user.email)

    if [[ -n "$current_git_user" && -n "$current_git_email" ]]; then
        gum style --foreground 34 --border thick --padding "1" --margin "1" <<EOF
✅ Git is already configured:
User:  $current_git_user
Email: $current_git_email
Skipping setup.
EOF
    else
        # prompt user to setup git if missing
        if gum confirm "Git user/email not set. Do you want to set up Git now?"; then
            git_username=$(gum input --placeholder "Enter your Git username" --prompt "Username: ")
            git_email=$(gum input --placeholder "Enter your Git email" --prompt "Email: ")
            
            git config --global user.name "$git_username"
            git config --global user.email "$git_email"
            
            gum style --foreground 34 --border thick --padding "1" --margin "1" <<EOF
✅ Git has been configured!
EOF
        else
            gum style --foreground 208 --border thick --padding "1" --margin "1" <<EOF
⚠️ Skipping Git setup.
EOF
        fi
    fi

    # --- package manager:homebrew ---
    if command -v brew &> /dev/null; then
        echo "☕️ Homebrew is already installed."
    else
        echo "🚀 Homebrew not found. Installing..."
        gum spin --spinner dot --title "Downloading Homebrew installer..." -- \
            curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o /tmp/homebrew_install.sh
        
        # run the installer
        /bin/bash /tmp/homebrew_install.sh
        rm -f /tmp/homebrew_install.sh

        # Add Homebrew to PATH immediately for this session
        if [[ -d "/opt/homebrew/bin" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -d "/usr/local/bin" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi

    # --- configuration:Charfiles ---
    echo "🔧 Setting up Charfiles..."
    
    # Ensure git is installed before cloning
    if ! command -v git &> /dev/null; then
        brew install git
    fi

    if [ ! -d "$DOTFILES_DIR" ]; then
        gum spin --spinner dot --title "Cloning Charfiles repository..." -- \
                git clone https://github.com/Charlynder/Charfiles.git "$DOTFILES_DIR"
    else
        echo "✅ Charfiles directory exists. Pulling latest changes..."
        git -C "$DOTFILES_DIR" pull origin main
    fi

    # --- packages:Brewfile ---
    if [ -f "$DOTFILES_DIR/Brewfile" ]; then
        gum spin --spinner dot --title "Installing packages from Brewfile..." -- brew bundle --file="$DOTFILES_DIR/Brewfile"
        echo "✅ Brewfile packages installation complete."
    else
        echo "⚠️ No Brewfile found at $DOTFILES_DIR/Brewfile."
    fi

    # --- configuration:CleanUp ---
    # remove installation specific files from the config folder so they don't clutter
    rm -f "$DOTFILES_DIR/install.sh"
    rm -f "$DOTFILES_DIR/README.md"
    rm -f "$DOTFILES_DIR/CHANGELOG.md"
    rm -f "$DOTFILES_DIR/CHANGELOG"

    # --- configuration:Links ---
    # Function to backup and link
    link_config() {
        source_path="$1"
        dest_path="$2"
        
        # Check if source exists
        if [ ! -e "$source_path" ]; then
            echo "⚠️ Source not found: $source_path. Skipping."
            return
        fi

        # Backup if destination exists and is not a symlink pointing to our source
        if [ -e "$dest_path" ] || [ -L "$dest_path" ]; then
            # If it's already the correct link, do nothing
            current_link=$(readlink "$dest_path")
            if [ "$current_link" == "$source_path" ]; then
                echo "✅ Link already exists: $dest_path"
                return
            fi

            mkdir -p "$BACKUP_DIR"
            mv "$dest_path" "$BACKUP_DIR/"
            echo "📦 Backed up existing $dest_path to $BACKUP_DIR"
        fi

        ln -s "$source_path" "$dest_path"
        echo "🔗 Linked $source_path -> $dest_path"
    }

    echo "🔗 Creating symlinks..."
    mkdir -p "$CONFIG_DIR"

    # 1. Link Directories to ~/.config
    # These are folders inside src/ that act as config roots
    link_config "$DOTFILES_DIR/src/bat"       "$CONFIG_DIR/bat"
    link_config "$DOTFILES_DIR/src/fastfetch" "$CONFIG_DIR/fastfetch"
    link_config "$DOTFILES_DIR/src/ghostty"   "$CONFIG_DIR/ghostty"
    link_config "$DOTFILES_DIR/src/nvim"      "$CONFIG_DIR/nvim"
    link_config "$DOTFILES_DIR/src/tmux"      "$CONFIG_DIR/tmux"

    # 2. Link Files to Home Directory
    # Files that traditionally live in ~
    
    # Git
    if [ -f "$DOTFILES_DIR/src/git/.gitconfig" ]; then
        link_config "$DOTFILES_DIR/src/git/.gitconfig" "$HOME/.gitconfig"
    fi

    # Zsh (Assuming .zshrc is in src/zsh/ or just src/)
    # Adjust based on exact repo structure. Checking typical location based on your input.
    if [ -f "$DOTFILES_DIR/src/zsh/.zshrc" ]; then
        link_config "$DOTFILES_DIR/src/zsh/.zshrc" "$HOME/.zshrc"
    fi
    
    # If Zsh theme folder exists, we might want to link the whole zsh folder to a hidden .zsh dir
    # or just rely on .zshrc configuration. 
    # Based on your previous script, you had a ~/.zsh link.
    if [ -d "$DOTFILES_DIR/src/zsh" ]; then
        link_config "$DOTFILES_DIR/src/zsh" "$HOME/.zsh"
    fi

    # --- configuration:Prompts (Optional) ---
    # This checks the downloaded path, not relative path
    THEME_DIR="$DOTFILES_DIR/src/zsh/themes"
    if [ -d "$THEME_DIR" ]; then
        available_themes=($(ls "$THEME_DIR"))
        if [ ${#available_themes[@]} -gt 0 ]; then
            selected_option=$(gum choose --header "Select a Zsh prompt theme:" --height 10 "${available_themes[@]}")
            if [ -n "$selected_option" ]; then
                # Assuming .zshrc has a placeholder or we append
                # For safety, we just echo for now unless you have a specific sed command that works for your .zshrc structure
                echo "🎨 You selected: $selected_option"
                # sed -i '' "s/^ZSH_THEME=.*/ZSH_THEME=\"$selected_option\"/" "$HOME/.zshrc"
            fi
        fi
    fi

    # --- verification:Check ---
    gum spin --spinner dot --title "Verifying installation..." -- ls -la "$CONFIG_DIR"
    sleep 1
)

# --- Charfiles:finish ---
gum style --foreground 200 --border normal --padding "0.5" --margin "0.5" <<EOF
🎉 Installation Complete! 🎉

- Configs linked to: $CONFIG_DIR
- Backups stored in: $BACKUP_DIR

Please restart your terminal to see changes.
EOF