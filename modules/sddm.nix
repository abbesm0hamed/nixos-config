{ config, lib, pkgs, ... }:

let
  locals = import ../hosts/workstation/locals.nix { inherit pkgs; };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    
    theme = "sddm-astronaut-theme";

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
