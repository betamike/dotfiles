{ config, pkgs, lib, ... }:

let
  hostname = "talos";
in {
  environment.systemPackages = [
    pkgs.cargo
    pkgs.cmake
    pkgs.coreutils
    pkgs.direnv
    pkgs.findutils
    pkgs.gh
    pkgs.gnugrep
    pkgs.go
    # pkgs.git
    pkgs.jq
    pkgs.hack-font
    pkgs.keychain
    pkgs.kind
    pkgs.kubernetes-helm
    pkgs.htop
    pkgs.fzf
    pkgs.neovim
    pkgs.opentofu
    pkgs.poetry
    pkgs.ripgrep
    pkgs.tmux
    pkgs.tree
    pkgs.vim
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
      "code-minimap"
      "docker"
      "docker-buildx"
      "helix"
      "mas"
      "node"
      "skhd"
      "yabai"
    ];
    taps = [
      "1password/tap"
      "homebrew/cask-drivers"
      "homebrew/services"
      "koekeishiya/formulae"
    ];
    casks = [
      "1password"
      "1password-cli"
      "alacritty"
      "bluesnooze"
      "dash"
      "elgato-control-center"
      "elgato-stream-deck"
      "gather"
      "google-chrome"
      "google-cloud-sdk"
      "git-credential-manager-core"
      "firefox"
      "heynote"
      "iterm2"
      "jordanbaird-ice"
      "linearmouse"
      "linear-linear"
      "notunes"
      "orbstack"
      "raycast"
      "signal"
      "slack"
      "spotify"
      "stats"
      "tomatobar"
      "visual-studio-code"
      "yubico-yubikey-personalization-gui"
      "zoom"
    ];
    masApps = {
      "Clocker" = 1056643111;
      "Twingate" = 1501592214;
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
