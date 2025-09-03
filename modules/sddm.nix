{ config, lib, pkgs, ... }:

{
  # Display Manager and Wayland Compositor
  # SDDM has better Wayland support than LightDM
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    
    theme = "sddm-astronaut-theme";
    
    settings = {
      General = {
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
