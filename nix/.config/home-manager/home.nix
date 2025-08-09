{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "dev"; # Replace with your actual username
  home.homeDirectory = "/home/dev"; # Replace with your actual home directory

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05"; # Use "24.05" for latest stable or keep as-is for master

  # The home.packages option allows you to install Nix packages into your environment
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono

    # Dotfiles
    stow

    # AWS and Kubernetes tools
    awscli2
    kubectl
    eksctl
    argocd

    # Infrastructure as Code
    terraform
    helm

    # Programming languages and package managers
    python3
    python3Packages.pip
    php84
    php84Packages.composer
    #nodejs_20  # Node.js for modern web development

    # Terminal and shell tools
    zellij     # Modern terminal multiplexer
    nushell    # Modern shell with structured data
    fish       # Friendly interactive shell

    # Development utilities
    direnv
    jq
    bat
    htop
    fzf
    volta

    # Additional recommended tools
    ripgrep    # Fast grep alternative (rg)
    fd         # Fast find alternative
    eza        # Modern ls replacement
    zoxide     # Smart cd command
    delta      # Better git diff viewer
    lazygit    # Terminal git UI
    gh         # GitHub CLI
    #docker     # Container runtime
    #docker-compose # Container orchestration
    k9s        # Kubernetes cluster management
    stern      # Multi-pod log tailing for Kubernetes
    yq         # YAML processor (like jq for YAML)
    tree       # Directory tree viewer
    curl       # HTTP client
    wget       # File downloader
    unzip      # Archive extraction
    zip        # Archive creation
    rsync      # File synchronization
    #tmux       # Terminal multiplexer (alternative to zellij)
    #neovim     # Modern vim
    micro      # Simple terminal editor
    starship   # Cross-shell prompt

    #(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Home Manager can also manage your environment variables
  home.sessionVariables = {
    EDITOR = "vim"; # or your preferred editor
  };

  # home.sessionPath = [ "$HOME/.volta/bin" ];

  # Enable direnv integration
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true; # Enable for nushell
    #enableFishIntegration = true;    # Enable for fish
    nix-direnv.enable = true;
  };

  # Configure fish shell
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "eza -la";
      la = "eza -la";
      ls = "eza";
      cat = "bat";
      ".." = "cd ..";
      "..." = "cd ../..";
      k = "kubectl";
      tf = "terraform";
      lg = "lazygit";
      # Kubernetes aliases
      kgp = "kubectl get pods";
      kgs = "kubectl get services";
      kgd = "kubectl get deployments";
      # Git aliases
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";

      sail="sh $([ -f sail ] && echo sail || echo vendor/bin/sail)";
    };
    functions = {
      # Custom fish functions
      mkcd = "mkdir -p $argv[1]; and cd $argv[1]";
      backup = "cp $argv[1] $argv[1].backup";
      extract = ''
        switch $argv[1]
          case '*.tar.bz2'
            tar xjf $argv[1]
          case '*.tar.gz'
            tar xzf $argv[1]
          case '*.bz2'
            bunzip2 $argv[1]
          case '*.rar'
            unrar x $argv[1]
          case '*.gz'
            gunzip $argv[1]
          case '*.tar'
            tar xf $argv[1]
          case '*.tbz2'
            tar xjf $argv[1]
          case '*.tgz'
            tar xzf $argv[1]
          case '*.zip'
            unzip $argv[1]
          case '*'
            echo "Unknown archive format"
        end
      '';
    };
    interactiveShellInit = ''
      # Custom fish configuration
      set -g fish_greeting ""  # Disable greeting

      # Fish-specific settings
      set fish_color_command blue
      set fish_color_param cyan
      set fish_color_redirection yellow
      set fish_color_comment brblack
      set fish_color_error red
      set fish_color_escape bryellow
      set fish_color_operator brgreen
      set fish_color_quote green
      set fish_color_autosuggestion brblack

      set -gx VOLTA_HOME $HOME/.volta
      fish_add_path $VOLTA_HOME/bin

      set -gx COMPOSER_HOME $HOME/.config/composer/vendor
      fish_add_path $VOLTA_HOME/bin
    '';
  };

  # Configure Nushell
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config = {
        show_banner: false
        completions: {
          case_sensitive: false
          quick: true
          partial: true
        }
      }
    '';
    shellAliases = {
      ll = "ls -la";
      la = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      k = "kubectl";
      tf = "terraform";
    };
    envFile.text = ''
      $env.VOLTA_HOME = ([$nu.home-path ".volta"] | path join)
      $env.PATH = [$"($env.VOLTA_HOME)/bin", ...$env.PATH]
    '';
  };

  # Configure zoxide (smart cd)
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    #enableFishIntegration = true;  # Enable for fish
  };

  # Configure fzf
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    #enableFishIntegration = true;  # Enable for fish
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--border"
      "--layout=reverse"
      "--info=inline"
    ];
  };

  # Configure bat (better cat)
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less -FR";
    };
  };

  # Configure starship prompt
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    #enableFishIntegration = true;  # Enable for fish
    settings = {
      format = "$all$character";
      add_newline = false;

      # Character configuration
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };

      # Directory configuration
      directory = {
        truncation_length = 3;
        truncate_to_repo = false;
        style = "bold cyan";
      };

      # Git configuration
      git_branch = {
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        style = "bold yellow";
        conflicted = "⚡";
        deleted = "✘";
        modified = "●";
        staged = "✓";
        untracked = "?";
      };

      # Language-specific configurations
      nodejs = {
        symbol = " ";
        style = "bold green";
      };

      python = {
        symbol = " ";
        style = "bold blue";
      };

      php = {
        symbol = " ";
        style = "bold purple";
      };

      docker_context = {
        symbol = " ";
        style = "bold blue";
      };

      kubernetes = {
        disabled = false;
        symbol = "☸ ";
        style = "bold blue";
        context_aliases = {
          "dev" = "development";
          "prod" = "production";
        };
      };

      terraform = {
        symbol = "💠 ";
        style = "bold purple";
      };

      aws = {
        symbol = " ";
        style = "bold yellow";
      };

      # Package managers
      package = {
        symbol = " ";
        style = "bold green";
      };
    };
  };

  # Configure bash (if you use bash)
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "eza -la";
      la = "eza -la";
      ls = "eza";
      cat = "bat";
      ".." = "cd ..";
      "..." = "cd ../..";
      k = "kubectl";
      tf = "terraform";
      lg = "lazygit";
    };
    bashrcExtra = ''
      # Custom bash configuration
      #export EDITOR=vim

      # Kubernetes aliases
      alias kgp="kubectl get pods"
      alias kgs="kubectl get services"
      alias kgd="kubectl get deployments"

      # Git aliases
      alias gs="git status"
      alias ga="git add"
      alias gc="git commit"
      alias gp="git push"
      alias gl="git pull"

      alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

      export VOLTA_HOME="$HOME/.volta"
      export PATH="$VOLTA_HOME/bin:$PATH"

      export COMPOSER_HOME="$HOME/.config/composer/vendor"
      export PATH="$COMPOSER_HOME/bin:$PATH"
    '';
  };

  programs.zsh = {
    enable = true;
  };

  # Configure git (optional but recommended)
  programs.git = {
    enable = true;
    userName = "DevRedempti";
    userEmail = "dev.redempti@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "vim";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
    delta.enable = true;
  };

  programs.neovim.enable = true;

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}