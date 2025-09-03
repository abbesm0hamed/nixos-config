{ config, lib, pkgs, inputs, ... }:
let
  versions = import ../../versions.nix;
  locals = import ./locals.nix { inherit pkgs; };
in
{
  # Import modules
  imports = [
    ../../globals.nix 
    ../../modules/shell.nix
    ../../modules/tmux.nix
    ../../modules/git.nix
  ];
  
  # Basic info
  home.username = "abbes";
  home.homeDirectory = "/home/abbes";
  home.stateVersion = versions.homeManager;


  # Install your packages here (keeping it minimal for fast setup)
  home.packages = with pkgs; [
    # browser
    # brave
    chromium
    inputs.zen-browser.packages."${pkgs.system}".default
    
    # Terminal & Shell
    ghostty
    foot
    cliphist
    dysk
    
    # Wayland & Window Manager
    niri
    swww
    swaybg  # For backdrop wallpaper in overview mode 
    imagemagick  # For wallpaper blur effects
    fuzzel  # Application launcher
    switcheroo
    localsend
    
    # mako  # Lightweight notification daemon
    swaynotificationcenter  # SwayNC notification daemon
    libnotify  # Provides notify-send command
    swaylock-effects  # Screen locker with effects (better for wlroots/Niri)
    wl-clipboard  # Wayland clipboard utilities
    grim  # Screenshot utility
    slurp  # Screen area selection
    # davinci-resolve
    
    # Essential Development
    fnm  # Fast Node Manager
    windsurf
    
    # Languages & Runtimes
    nodejs_24  # Latest LTS Node.js
    python3
    python3Packages.pip
    python3Packages.virtualenv
    rustc
    cargo
    go
    
    # Container & Cloud tools
    docker
    docker-compose
    kubectl
    terraform

    # Database Management Tools
    dbeaver-bin         # Universal database tool (80+ databases)
    
    # API & Network tools
    httpie  # Better curl alternative
    # bruno  # API testing
    # postman
    yaak

    
    # Code quality & formatting
    shellcheck  # Shell script linting
    shfmt  # Shell script formatting
    
    # Performance & debugging
    hyperfine  # Benchmarking tool
    tokei  # Code statistics
    dust  # Better du
    procs  # Better ps
    
    # C/C++ Development (needed for Neovim plugins)
    gcc
    gnumake
    cmake

    # mostly for gaming
    xwayland-satellite

    # Waybar and related tools
    waybar
    pavucontrol
    jq
    wlsunset
    
    # Network & Bluetooth Management
    networkmanagerapplet  # nm-connection-editor
    blueman  # Bluetooth manager
    
    # System Control Tools (for system-controls.sh)
    gammastep  # Night light/blue light filter
    swayidle   # Idle management
    brightnessctl  # Brightness control
    lm_sensors  # Hardware sensors (temperature, etc.)

    # System Monitoring & Info
    nh  # NixOS Helper - better CLI for nixos-rebuild and nix commands
    
    # Qt6 support (essential for Qt-based applications)
    qt6.qtbase   # Core Qt6 framework (includes qtwayland)
    qt6.qttools  # Qt6 development tools

    # Hardware Detection Tools
    usbutils  # Provides lsusb command
    pciutils  # Provides lspci command
    lshw      # Hardware lister
    ethtool
    
    # Fingerprint Authentication
    fprintd  # Fingerprint daemon
    libfprint  # Fingerprint library
    
    # Battery & Power Management Tools
    powertop  # Power consumption analyzer
    acpi  # Battery status
    tlp  # Power management
    auto-cpufreq  # Automatic CPU frequency scaling
    
    # Theme and cursor support
    adwaita-icon-theme  # Default GNOME icon and cursor theme
    gtk4  # GTK4 for modern theme support

    # libreoffice-qt6-fresh

    # Social media apps
    slack
    discord

    # PDF viewers and document tools
    zathura      # Lightweight PDF viewer with vim-like keybindings

    # Graphics and hardware acceleration
    vulkan-tools # Vulkan utilities
    
    # Add to home.packages
    # gimp        # Image editing
    # inkscape    # Vector graphics
    # obs-studio  # Screen recording (you have commented)    

    # Archive & Compression
    zip
    xz
    unzip
    p7zip

    # System Call Monitoring & Debugging
    strace                  # system call monitoring
    ltrace                  # library call monitoring
    lsof                    # list open files
  ];

  home.file = {
    # Shell & Terminal configs
    ".config/ghostty".source = ../../dotfiles/.config/ghostty;
    ".config/starship.toml".source = ../../dotfiles/.config/starship/starship.toml;
    ".config/lazygit".source = ../../dotfiles/.config/lazygit;
    
    # Wayland & Window Manager configs
    ".config/niri".source = ../../dotfiles/.config/niri;
    ".config/fuzzel".source = ../../dotfiles/.config/fuzzel;
    ".config/waybar".source = ../../dotfiles/.config/waybar;
    
    # Development configs
    ".config/nvim".source = ../../dotfiles/.config/nvim;
    
    # System tools configs
    ".config/btop".source = ../../dotfiles/.config/btop;
    ".config/cava".source = ../../dotfiles/.config/cava;
    ".config/fastfetch".source = ../../dotfiles/.config/fastfetch;
    ".config/ranger".source = ../../dotfiles/.config/ranger;
    
    # SwayNC notification center
    ".config/swaync".source = ../../dotfiles/.config/swaync;
    
    # Swaylock screen locker
    ".config/swaylock".source = ../../dotfiles/.config/swaylock;
    
    # Backgrounds
    ".config/backgrounds".source = ../../dotfiles/.config/backgrounds;
  };

  programs.nh.enable = true;
  
  # programs.virt-manager.enable = true;

  # Environment variables
  home.sessionVariables = {
    # Core environment
    EDITOR = "nvim";
    BROWSER = "zen";
    TERMINAL = "ghostty";
    
    # Terminal and color support
    TERM = "xterm-256color";
    COLORTERM = "truecolor";
    
    # Wayland environment (for better app compatibility)
    NIXOS_OZONE_WL = "1";  # Enable Wayland for Electron apps
    MOZ_ENABLE_WAYLAND = "1";  # Enable Wayland for Firefox
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    
    # Development environment
    DEVELOPMENT_MODE = "1";
    
    # Node.js and npm
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    NODE_OPTIONS = "--max-old-space-size=4096";  # Increase Node.js memory
    
    # Python
    PYTHONDONTWRITEBYTECODE = "1";
    PYTHONUNBUFFERED = "1";
    PYTHONPATH = "$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH";
    
    # Rust
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";
    RUST_BACKTRACE = "1";  # Better error messages
    
    # Go
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    GO111MODULE = "on";  # Modern Go modules
    
    # Development tools
    DOCKER_BUILDKIT = "1";  # Enable BuildKit for Docker
    COMPOSE_DOCKER_CLI_BUILD = "1";  # Use BuildKit with docker-compose
    
    # Performance and caching
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    
    # Path additions
    PATH = "$HOME/.npm-global/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin:$PATH";
  };
}
