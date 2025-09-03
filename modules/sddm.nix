{ config, lib, pkgs, ... }:

{
  # Display Manager and Wayland Compositor
  # SDDM has better Wayland support than LightDM
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    
    # Custom astronaut theme
    package = pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";
    extraPackages = [ pkgs.sddm-astronaut ];
    
    settings = {
      General = {
        # Hide user avatars and user list
        EnableAvatars = "false";
        UserPicture = "false";
      };
    };
  };
}
