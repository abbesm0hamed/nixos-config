{ config, lib, pkgs, ... }:

let
  locals = import ../hosts/workstation/locals.nix { inherit pkgs; };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    
    # Theme configuration
    theme = "breeze";
    
    # Custom settings
    settings = {
      General = {
        # Use custom background image
        Background = toString locals.wallpapers.blurred;
        
        # Disable user avatars for cleaner look
        EnableAvatars = false;
        
        # Session configuration
        DefaultSession = "niri.desktop";
      };
      
      Theme = {
        # Font configuration
        Font = "SpaceMono Nerd Font";
        FontSize = "12";
        
        # Colors (Catppuccin Mocha theme)
        Current = "breeze";
        CursorTheme = "Adwaita";
        CursorSize = "24";
      };
      
      Users = {
        # User configuration
        MaximumUid = "60000";
        MinimumUid = "1000";
        
        # Hide shell users
        HideShells = "/bin/false,/usr/bin/nologin,/sbin/nologin";
      };
    };
  };
  
  # Required packages for SDDM theming
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtsvg
  ];
}
