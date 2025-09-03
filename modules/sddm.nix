{ config, lib, pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    
    settings = {
      General = {
        EnableAvatars = "false";
        UserPicture = "false";
      };
    };
  };
}
