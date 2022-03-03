{ config, pkgs, ... }:

let
  hostname = "talos";
in {
  environment.systemPackages = [
    pkgs.coreutils
    pkgs.direnv
    pkgs.findutils
    pkgs.gh
    pkgs.gnugrep
    pkgs.jq
    pkgs.keychain
    pkgs.hack-font
    pkgs.fzf
    pkgs.neovim
    pkgs.ripgrep
    pkgs.tmux
    pkgs.tree
    pkgs.vim
  ];

  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup = "zap";
    brews = [
      "mas"
    ];
    taps = [ "homebrew/cask" ];
    casks = [
     "1password"
      "alfred"
      "amethyst"
      "google-chrome"
      "ferdi"
      "firefox"
      "iterm2"
      "logseq"
      "signal"
      "slack"
      "spotify"
      "zoom"
    ];
    masApps = {
      "Clocker" = 1056643111;
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
  system.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
  };

  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
