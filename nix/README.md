
# Install Nix

```bash
# Official installer
sh <(curl -L https://nixos.org/nix/install) --daemon

# Enable flakes (add to ~/.config/nix/nix.conf)
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```


# Install Home-manager using Flakes

Create a `flake.nix` file in `~/.config/home-manager/`:

Here is the [flake.nix](.config/home-manager/flake.nix) file.

## Install the flake and switch

```bash
# Install using flakes
nix run home-manager/master -- init --switch

# Future updates
home-manager switch --flake ~/.config/home-manager#dev
```

# Configure Home Manager

Create `~/.config/home-manager/home.nix` with your development tools:

Here is the [home.nix](.config/home-manager/home.nix) file.


# Apply the Configuration

Apply the Home Manager configuration
Replace `YOUR_USERNAME`/`dev` in the configuration file with your actual username, then apply the configuration:

```bash
home-manager switch -b backup --flake ~/.config/home-manager#dev
```

# Set up Shell Integration

Add Home Manager to your shell profile. Add this line to your `~/.bashrc` or `~/.zshrc`:

```bash
# Add to ~/.bashrc or ~/.zshrc
source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
```

For direnv to work properly with your shell, restart your terminal or run:

```bash
source ~/.bashrc  # or ~/.zshrc if you use zsh
```

# Verify Installation

```bash
# Test each tool
aws --version
kubectl version --client
eksctl version
argocd version --client
terraform version
helm version
python3 --version
pip --version
direnv --version
jq --version
bat --version
htop --version
fzf --version
volta --version

# Test new additions
zellij --version
git --version
nu --version
fish --version
rg --version
fd --version
eza --version
zoxide --version
delta --version
lazygit --version
gh --version
k9s version
yq --version
```