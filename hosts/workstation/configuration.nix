{ config, lib, pkgs, ... }:

let
  versions = import ../../versions.nix;
  locals = import ./locals.nix { inherit pkgs; };
in
{
  imports = [
    ../../globals.nix # Import shared settings
    ./hardware-configuration.nix
    ./stylix.nix
  ];

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  
  # LUKS disk encryption support
  boot.initrd.luks.devices = {
    # Example LUKS setup - uncomment and configure for real hardware
    # "luks-root" = {
    #   device = "/dev/disk/by-uuid/YOUR-LUKS-UUID-HERE";
    #   preLVM = true;
    # };
  };
  
  # Enable LUKS support in initrd
  boot.initrd.availableKernelModules = [ "aes" "xts" "sha256" "sha512" ];
  boot.supportedFilesystems = [ "ext4" "btrfs" "xfs" "ntfs" ];

  system.autoUpgrade = {
    enable = false;  # Set to true if you want automatic updates
  };
  
  # Enable flakes and nix command
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
    
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    
    # Automatic store optimization
    optimise = {
      automatic = true;
      dates = [ "03:45" ];
    };  
  };



  # VirtualBox optimizations (disable for real hardware)
  # boot.initrd.checkJournalingFS = false;  # VM-specific
  # virtualisation.virtualbox.guest.enable = true;  # VM-specific

  # Graphics and hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # For 32-bit applications and games
    
    # Mesa drivers for Intel/AMD/Nouveau graphics
    extraPackages = with pkgs; [
      mesa  # Use mesa instead of mesa.drivers
      # Intel hardware video acceleration
      intel-media-driver
      intel-vaapi-driver
      # VDPAU support
      libvdpau-va-gl
    ];
    
    # 32-bit driver support
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa  # Use mesa instead of mesa.drivers
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  # Network
  networking.hostName = locals.hostname;
  networking.networkmanager.enable = true;
  
  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];  # Add ports as needed: 22 80 443
    allowedUDPPorts = [ ];
    # allowPing = true;  # Uncomment if needed
  };
  
  # DNS will be handled automatically by NetworkManager
  # Optional: Custom DNS servers (uncomment if you want to override ISP DNS)
  # networking.nameservers = [ "8.8.8.8" "1.1.1.1" "1.0.0.1" "9.9.9.9" ];
  
  # Enable systemd-resolved for better DNS handling
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "8.8.8.8" "1.1.1.1" ];
    extraConfig = ''
      DNS=8.8.8.8 1.1.1.1 1.0.0.1
      FallbackDNS=9.9.9.9 149.112.112.112
    '';
  };

  # Time zone
  time.timeZone = "Africa/Tunis";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Display Manager and Wayland Compositor
  # SDDM has better Wayland support than LightDM
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    
    # Simple configuration with custom background
    theme = "breeze";
    settings = {
      General = {
        # Set custom background
        Background = toString locals.wallpapers.blurred;
        
        # Hide user avatars and user list
        EnableAvatars = "false";
        UserPicture = "false";
      };
    };
  };  
  
  # Emergency fallback desktop (lightweight)
  # To enable fallback: rebuild with --override-input or set to true
  services.xserver.enable = true;  # Still needed for XFCE fallback
  services.xserver.desktopManager.xfce.enable = lib.mkDefault false;  # Disabled by default
  
  # Primary compositor
  programs.niri.enable = true;
  
  services.autorandr.enable = true;  # Auto display profiles

  # Enable Wayland protocols
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config.common.default = "*";
    wlr.enable = true;
  };

  # Enable sound with PipeWire (modern audio system)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;  # Don't auto-power on boot (saves battery)
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;  # Enable experimental features
      };
    };
  };
  
  # Enable Blueman service for GUI management
  services.blueman.enable = true;

  # Fingerprint authentication
  services.fprintd = {
    enable = true;
    tod.enable = true;  # Enable Touch OEM Drivers for better hardware support
    tod.driver = pkgs.libfprint-2-tod1-goodix;  # Common driver, adjust if needed
  };

  # PAM configuration for fingerprint authentication
  security.pam.services = {
    # Enable fingerprint for login (lightdm/display manager)
    lightdm.fprintAuth = true;
    
    # Enable fingerprint for sudo
    sudo.fprintAuth = true;
    
    # Enable fingerprint for screen unlock (if using a screen locker that supports PAM)
    swaylock.fprintAuth = true;
    
    # Enable fingerprint for system authentication prompts
    polkit-1.fprintAuth = true;
  };

  # Enable fish shell system-wide
  programs.fish.enable = true;

  # User account
  users.users.abbes = {
    isNormalUser = true;
    description = "abbes";
    extraGroups = [ "networkmanager" "wheel" "vboxsf" "docker" "podman" ];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  # Container support
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };
  
  # Podman as Docker alternative (lighter weight)
  virtualisation.podman = {
    enable = false;
    dockerCompat = true;  # Docker compatibility layer
    defaultNetwork.settings.dns_enabled = true;
  };

  # Power Management for Battery Life
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;  # Limit CPU to 80% on battery
      
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;  # Battery charge limiting
      
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
    };
  };

  # Additional power optimizations
  services.thermald.enable = true;  # Thermal management (compatible with TLP)
  # services.auto-cpufreq.enable = true;  # DISABLED - conflicts with TLP
  
  services.printing.enable = lib.mkDefault true;
  services.avahi.enable = lib.mkDefault true;
  
  # File system services
  services.udisks2.enable = true;  # Auto-mount USB drives
  services.gvfs.enable = true;     # Virtual file system (for file managers)
  
  # Security services
  security.polkit.enable = true;         # Policy kit for privilege escalation
  services.gnome.gnome-keyring.enable = true;  # Secret service for passwords
  
  # SSH for remote recovery (disabled by default)
  services.openssh = {
    enable = lib.mkDefault false;  # Enable when needed: set to true
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  environment.sessionVariables = {
    # Enable Wayland for Chromium-based apps
    NIXOS_OZONE_WL = "1";
  };

  # System packages (minimal, let home-manager handle user packages)
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    
    # SDDM theme requirements
    libsForQt5.qt5.qtgraphicaleffects  # For blur effects
    libsForQt5.qt5.qtquickcontrols2    # For modern themes
    libsForQt5.qt5.qtsvg               # For SVG support
    libsForQt5.sddm-kcm               # SDDM configuration module
  ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.space-mono
      victor-mono
      noto-fonts-emoji
      amiri
      # Optional: add some common fallbacks
      noto-fonts
      liberation_ttf
      # Font Awesome for waybar icons
      font-awesome
      nerd-fonts.symbols-only
    ];
    
    fontconfig.enable = true;
  };

  system.stateVersion = versions.nixos;
}
