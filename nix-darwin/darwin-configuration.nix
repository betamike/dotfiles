{ config, pkgs, lib, ... }:

let
  hostname = "talos";
in {
  environment.systemPackages = [
    pkgs.cargo
    pkgs.colima
    pkgs.coreutils
    pkgs.difftastic
    pkgs.direnv
    pkgs.findutils
    pkgs.gh
    pkgs.gnugrep
    pkgs.go
    pkgs.git
    pkgs.graphviz
    pkgs.jq
    pkgs.keychain
    pkgs.kind
    pkgs.hack-font
    pkgs.htop
    pkgs.fzf
    pkgs.neovim
    pkgs.poetry
    pkgs.ripgrep
    pkgs.tmux
    pkgs.tree
    pkgs.vim
    pkgs.watchman
    pkgs.watch
  ];

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    brews = [
      "awscli"
      "azure-cli"
      "code-minimap"
      "docker"
      "docker-buildx"
      "helix"
      "mas"
      "mutagen"
      "node"
      "skhd"
      "yabai"
    ];
    taps = [
      "1password/tap"
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
      "cameracontroller"
      "dash"
      "drawio"
      "elgato-control-center"
      "elgato-stream-deck"
      "gather"
      "google-chrome"
      "google-cloud-sdk"
      "git-credential-manager-core"
      "firefox"
      "hammerspoon"
      "heynote"
      "hiddenbar"
      "iterm2"
      "kitty"
      "linearmouse"
      "linear-linear"
      "logseq"
      "loom"
      "notable"
      "orbstack"
      "raycast"
      "remarkable"
      "signal"
      "slack"
      "spotify"
      "stats"
      "tomatobar"
      "visual-studio-code"
      "yubico-yubikey-personalization-gui"
      "xbar"
      "zoom"
    ];
    masApps = {
      "Clocker" = 1056643111;
      "Twingate" = 1501592214;
      "pullBar" = 1601913905;
    };
  };

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

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
