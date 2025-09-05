{ config, lib, pkgs, ... }:

let
  locals = import ../hosts/workstation/locals.nix { inherit pkgs; };
  # Copy wallpaper to system location for SDDM access
  sddmWallpaper = pkgs.runCommand "sddm-wallpaper" {} ''
    mkdir -p $out
    cp ${locals.wallpapers.blurred} $out/wallpaper.jpg
  '';
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    
    settings = {
      General = {
        # Use wallpaper from system-accessible location
        Background = "${sddmWallpaper}/wallpaper.jpg";
        DefaultSession = "niri.desktop";
        EnableAvatars = false;
      };
    };
  };

  # Emergency fallback desktop (lightweight)
  # To enable fallback: rebuild with --override-input or set to true
  services.xserver.enable = true;  # Still needed for XFCE fallback
  services.xserver.desktopManager.xfce.enable = lib.mkDefault false;  # Disabled by default
  services.xserver.displayManager.gdm.enable = false;
}
