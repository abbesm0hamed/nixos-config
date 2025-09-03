{ config, lib, pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    
    # Use stable breeze theme to avoid build issues
    theme = "breeze";
    
    settings = {
      General = {
        EnableAvatars = "false";
        UserPicture = "false";
      };
    };
  };
  
  environment.systemPackages = with pkgs; [
    sddm-astronaut
  ];
}
