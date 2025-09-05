# Local configuration variables for this workstation
# This file contains host-specific settings that can be imported by other modules

{ pkgs, ... }:

{
  # Wallpaper configuration - Centralized image paths
  wallpapers = {
    # Main wallpaper for Stylix theming and workspace backgrounds
    main = ../../dotfiles/.config/backgrounds/snaky.jpg;
    
    # Blurred version for lock screen and overview backdrop
    blurred = ../../dotfiles/.config/backgrounds/blurry-snaky.jpg;
    
    # Alternative wallpapers (add more as needed)
    # alternative2 = ../../dotfiles/.config/backgrounds/mountain.jpg;
  };
  
  # Host-specific settings
  hostname = "workstation";
  
  # User preferences
  user = {
    name = "abbes";
    description = "Abbes";
  };
  
  # Font configuration
  fonts = {
    # System UI font (for SDDM, system dialogs)
    main = "Inter";
    # Terminal/code font (for terminals, waybar, fuzzel, notifications)
    mono = "SpaceMono Nerd Font";
    # Font size for UI elements
    size = "12";
  };
  
  # Display configuration
  display = {
    # Add display-specific settings here if needed
    # e.g., resolution, scaling, etc.
  };
  
  # Hardware-specific settings
  hardware = {
    # Add hardware-specific settings here
    # e.g., GPU type, special drivers, etc.
  };
}