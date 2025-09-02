{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "abbesm0hamed";
    userEmail = "abbesmohamed717@gmail.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      diff.tool = "vimdiff";
      merge.tool = "vimdiff";
      
      # GitHub CLI integration
      credential.helper = "store";
      
      # Better diff and merge
      diff.algorithm = "patience";
      merge.conflictstyle = "diff3";
    };
    
    # GPG signing disabled - no key configured
    # signing = {
    #   key = "YOUR_GPG_KEY_ID";
    #   signByDefault = true;
    # };
  };
  
  # SSH configuration for GitHub
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "${config.home.homeDirectory}/.ssh/github";
      };
    };
  };
  
  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "nvim";
    };
  };
}
