{ config, lib, pkgs, ... }:

let
  locals = import ../hosts/workstation/locals.nix { inherit pkgs; };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    
    settings = {
      General = {
        DefaultSession = "niri.desktop";
        EnableAvatars = false;
      };
      
      Theme = {
        # Font configuration from locals
        Font = locals.fonts.main;
        FontSize = locals.fonts.size;
        
        # Clean theme settings
        Current = "breeze";
        CursorTheme = "Adwaita";
        CursorSize = "24";
      };
    };
  };

  # Emergency fallback desktop (lightweight)
  # To enable fallback: rebuild with --override-input or set to true
  services.xserver.enable = true;  # Still needed for XFCE fallback
  services.xserver.desktopManager.xfce.enable = lib.mkDefault false;  # Disabled by default
  services.xserver.displayManager.gdm.enable = false;
}
