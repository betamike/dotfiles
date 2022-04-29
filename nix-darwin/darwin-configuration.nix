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
    pkgs.go
    pkgs.jq
    pkgs.keychain
    pkgs.hack-font
    pkgs.fzf
    pkgs.neovim
    pkgs.pulumi-bin
    pkgs.ripgrep
    pkgs.tmux
    pkgs.tree
    pkgs.vim
    pkgs.watchman
  ];

  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup = "zap";
    brews = [
      "mas"
      "mutagen"
    ];
    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
      "mutagen-io/mutagen"
    ];
    casks = [
     "1password"
      "alfred"
      "amethyst"
      "cameracontroller"
      "dash"
      "google-chrome"
      "google-cloud-sdk"
      "ferdi"
      "firefox"
      "iterm2"
      "logseq"
      "loom"
      "remarkable"
      "signal"
      "slack"
      "spotify"
      "visual-studio-code"
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
