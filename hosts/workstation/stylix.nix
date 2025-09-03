{ pkgs, ... }:

let
  locals = import ./locals.nix { inherit pkgs; };
in
{
  # Enable Stylix for system-wide theming
  stylix.enable = true;
  # stylix.enableReleaseChecks = false;  # Suppress version mismatch warnings
  
  # Base16 color scheme - you can change this to any base16 theme
  # Popular options: "gruvbox-dark-hard", "nord", "dracula", "tokyo-night-dark", "catppuccin-mocha"
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  # Set wallpaper from locals.nix (Stylix can generate colors from your wallpaper)
  stylix.image = locals.wallpapers.main;
  
  stylix.cursor = {
    theme = "capitaine-cursors";
    size = 28;
  };
  
  # Font configuration
  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.space-mono;
      name = "SpaceMono Nerd Font";
    };
    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };
    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
    };
    sizes = {
      applications = 12;
      terminal = 14;
      desktop = 12;
      popups = 12;
    };
  };
  
  # Override specific colors
  stylix.override = {
    # Base colors - moderately darker variants of Catppuccin Mocha
    base00 = "111318";
    base01 = "141420"; 
    base02 = "252538"; 
    base03 = "383850";
    base04 = "4a4a64";
    base05 = "cdd6f4";
    base06 = "f2cdcd";
    base07 = "f5e0dc";
    base08 = "f38ba8";
    base09 = "fab387";
    base0A = "f9e2af";
    base0B = "a6e3a1";
    base0C = "94e2d5";
    base0D = "89b4fa";
    base0E = "cba6f7";
    base0F = "f2cdcd";
  };
}
