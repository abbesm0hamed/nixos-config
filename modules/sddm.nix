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
    
    theme = "sddm-astronaut-theme";
    
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
  
  # Install sddm-astronaut theme package
  environment.systemPackages = with pkgs; [
    sddm-astronaut
  ];
}
