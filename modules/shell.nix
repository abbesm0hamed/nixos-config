{ config, lib, pkgs, ... }:
{
  # Fish plugins and dependencies
  home.packages = with pkgs; [
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
    # CLI tools for aliases
    lsd
    bat
    ripgrep
    fd
    zoxide
    starship
    fastfetch

    # Version control & collaboration
    gh  # GitHub CLI
    delta  # Better git diff
    lazygit  # TUI for git

    tmux
    neovim
    cava
    btop
    
    # File Management
    tree
    ranger

    ffmpeg
  ];

  # Fish shell configuration
  programs.fish = {
    enable = true;
    
    # Enhanced initialization with all your settings
    interactiveShellInit = ''
      # Disable fish greeting
      set fish_greeting ""
      
      # Vi keybindings
      set fish_key_bindings fish_vi_key_bindings
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      
      # Environment variables
      set -gx EDITOR nvim
      set -gx BROWSER firefox
      set -gx PATH $PATH $HOME/go/bin
      
      # Initialize tools if available
      if command -v starship >/dev/null
        starship init fish | source
      end
      
      if command -v zoxide >/dev/null
        zoxide init fish | source
      end
      
      if command -v fnm >/dev/null
        fnm env --use-on-cd | source
      end
      
      # Terminal sequences for AGS
      if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
        cat ~/.cache/ags/user/generated/terminal/sequences.txt
      end
    '';

    # Shell aliases - comprehensive set
    shellAliases = {
      # General Productivity
      lns = "ln -s";
      ll = "lsd -la";
      ls = "lsd";
      tree = "lsd --tree";
      v = "nvim";
      c = "clear";
      lg = "lazygit";
      ff = "fastfetch";
      ".." = "cd ..";
      "cd" = "z";
      
      # Better CLI defaults
      cat = "bat";
      grep = "rg";
      find = "fd";
      
      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gpl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      glog = "git log --oneline --graph --decorate";
      
      # Development tools
      k = "kubectl";
      tf = "terraform";
      py = "python3";
      pip = "pip3";

      # NixOS Package Management
      nix-search = "nix search nixpkgs";
      nix-shell = "nix-shell -p";
      rebuild = "sudo nixos-rebuild switch";
      rebuild-test = "sudo nixos-rebuild test";
      rebuild-update = "sudo nixos-rebuild switch --upgrade";
      nix-gc = "sudo nix-collect-garbage -d";
      nix-list = "nix-env -q";
      
      # Quick Navigation
      "..." = "cd ../..";
      "...." = "cd ../../..";
      nixcfg = "cd ~/nixos-config";
      
      # Docker Power Tools
      dc = "sudo docker-compose";
      dr = "sudo docker";
      
      # Tmux Session Management
      txfr = "tmuxifier";
      tm = "tmux";
      ta = "tmux attach-session -t";
      tn = "tmux new-session -s";
      tl = "tmux list-sessions";
      tk = "tmux kill-session -t";
      tka = "tmux kill-server";
      txsrc = "tmux source-file ~/.tmux.conf";
      
      # System monitoring
      diskusg = "df -h | grep /dev/nvme0n1p2";
    };

    # Custom functions
    functions = {
      # Kill process on specific port
      killport = {
        description = "Kill process running on specified port";
        body = ''
          if test -z $argv[1]
            echo "🔥 Usage: killport <port>"
            return 1
          end
          set -l pid (lsof -ti :$argv[1])
          if test -n "$pid"
            echo "💀 Killing process on port $argv[1] (PID: $pid)"
            kill -9 $pid
          else
            echo "🤷 No process found on port $argv[1]"
          end
        '';
      };

      # Quick directory creation and navigation
      mkcd = {
        description = "Create directory and cd into it";
        body = ''
          mkdir -p $argv[1] && cd $argv[1]
        '';
      };

      # Home directory shortcut
      home = {
        description = "Navigate to home directory";
        body = ''
          cd ~
        '';
      };

      # Universal archive extractor
      extract = {
        description = "Extract various archive formats";
        body = ''
          if test -f $argv[1]
            switch $argv[1]
              case '*.tar.bz2'
                tar xjf $argv[1]
              case '*.tar.gz'
                tar xzf $argv[1]
              case '*.bz2'
                bunzip2 $argv[1]
              case '*.rar'
                unrar x $argv[1]
              case '*.gz'
                gunzip $argv[1]
              case '*.tar'
                tar xf $argv[1]
              case '*.tbz2'
                tar xjf $argv[1]
              case '*.tgz'
                tar xzf $argv[1]
              case '*.zip'
                unzip $argv[1]
              case '*.Z'
                uncompress $argv[1]
              case '*.7z'
                7z x $argv[1]
              case '*'
                echo "🤔 '$argv[1]' cannot be extracted via extract()"
            end
          else
            echo "🚫 '$argv[1]' is not a valid file"
          end
        '';
      };
    };
  };

  programs.zoxide = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # FZF fuzzy finder
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [ "--height 40%" "--border" ];
  };

  # Bat for syntax highlighting
  programs.bat = {
    enable = true;
  };
}
