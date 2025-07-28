{
  pkgs,
  whitelist,
  ...
}: {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    warn-dirty = false;
  };
  imports = [
    ./hardware-configuration.nix
    ./zsh
    ./hyprland
    ./neovim
    ./tmux
  ];
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;

  networking.hostName = "nixos"; # Define your hostname.

  time.timeZone = "Africa/Algiers";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.abdennour = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      brave
      gh
      ripgrep
      fd
      jq
      ytarchive
      ffmpeg
      zoxide
      fzf
      delta
      zip
      unzip
      tldr
      glab
      comma
      nurl
      epiphany
      htop
      bluetuith
      ddcutil
      batsignal
      kanshi
      kitty
      (flameshot.override {enableWlrSupport = true;})
      (import ./packages/spotify.nix {pkgs = pkgs;})
      whitelist
      (mpv.override {scripts = with mpvScripts; [mpris mpv-cheatsheet memo];})
      stremio
      slack
      code-cursor
    ];
  };

  programs.starship.enable = true;
  programs.waybar.enable = true;

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Abdennour Zahaf";
        email = "zfnori@gmail.com";
      };
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };
  services.playerctld.enable = true;

  programs.nh = {
    enable = true;
    flake = "/home/abdennour/Projects/dotfiles";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1d";
  };

  programs.direnv = {
    enable = true;
    silent = true;
  };

  virtualisation.docker.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [];

  system.userActivationScripts.dotfiles = builtins.readFile ./scripts/symlink-config.sh;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
