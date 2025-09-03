{ config, lib, pkgs, ... }:

let
  # Import wallpaper paths from locals.nix
  # Note: We need to go up one level since this is in modules/
  locals = import ../hosts/workstation/locals.nix { inherit pkgs; };
in
{
  # Display Manager and Wayland Compositor
  # SDDM has better Wayland support than LightDM
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    
    # Theme configuration
    theme = "sddm-astronaut-theme";
    extraPackages = with pkgs; [ sddm-astronaut ];
    
    # Custom settings
    settings = {
      General = {
        # Custom background from locals.nix
        Background = toString locals.wallpapers.blurred;
        
        # Hide user avatars and user list
        EnableAvatars = "false";
        UserPicture = "false";
      };
    };
  };
}
