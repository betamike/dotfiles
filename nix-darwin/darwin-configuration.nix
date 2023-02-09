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
    pkgs.git
    pkgs.jq
    pkgs.keychain
    pkgs.hack-font
    pkgs.htop
    pkgs.fzf
    pkgs.neovim
    pkgs.ripgrep
    pkgs.tmux
    pkgs.tree
    pkgs.vim
    pkgs.watchman
  ];

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    brews = [
      "mas"
      "mutagen"
      "node"
      "semgrep"
      "skhd"
      "yabai"
    ];
    taps = [
      "1password/tap"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/services"
      "microsoft/git"
      "mutagen-io/mutagen"
      "koekeishiya/formulae"
    ];
    casks = [
     "1password"
     "1password-cli"
      "alacritty"
      "alfred"
      "altair-graphql-client"
      "amethyst"
      "asana"
      "cameracontroller"
      "dash"
      "drawio"
      "elgato-control-center"
      "elgato-stream-deck"
      "google-chrome"
      "google-cloud-sdk"
      "ferdi"
      "firefox"
      "istat-menus"
      "iterm2"
      "logseq"
      "loom"
      "raycast"
      "remarkable"
      "signal"
      "slack"
      "spotify"
      "visual-studio-code"
      "yubico-yubikey-personalization-gui"
      "zoom"
    ];
    masApps = {
      "Clocker" = 1056643111;
      "Twingate" = 1501592214;
      "pullBar" = 1601913905;
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
