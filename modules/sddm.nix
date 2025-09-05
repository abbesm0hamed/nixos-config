{ config, lib, pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    
    settings = {
      General = {
        # Set your custom wallpaper path
        Background = "/home/abbes/.config/backgrounds/blurry-snaky.jpg";
        DefaultSession = "niri.desktop";
      };
    };
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = false;
}
