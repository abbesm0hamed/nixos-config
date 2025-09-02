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

    # Qt6 support (essential for Qt-based applications)
    qt6.qtbase   # Core Qt6 framework
    qt6.qttools  # Qt6 development tools

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
    EDITOR = "nvim";
    BROWSER = "zen";
    
    # Development environment
    TERM = "xterm-256color";
    COLORTERM = "truecolor";
    
    # Node.js and npm
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    
    # Python
    PYTHONDONTWRITEBYTECODE = "1";
    PYTHONUNBUFFERED = "1";
    
    # Rust
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";
    
    # Go
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    
    # Path additions
    PATH = "$HOME/.npm-global/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH";
  };

  # GTK and cursor theme configuration to fix Gdk-Message errors
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  # Home cursor theme (for Wayland)
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
