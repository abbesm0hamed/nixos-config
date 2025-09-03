{ config, lib, pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    
    theme = "sddm-astronaut-theme";
    extraPackages = with pkgs; [ sddm-astronaut ];
    
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
