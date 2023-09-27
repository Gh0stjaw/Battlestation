# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      home-manager/nixos
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
nix = {
  package = pkgs.nixFlakes;
  extraOptions = ''
  experimental-features = nix-command flakes
  '';
};

  networking.hostName = "hmk"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Pantheon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;
  services.xserver.windowManager.bspwm = {
    enable = true;
    sxhkd.package = pkgs.sxhkd;
  };
  # Configure keymap in X11
  services.xserver = {
    layout = "no";
    xkbVariant = "nodeadkeys";
    videoDrivers = [ "amdgpu" ];
  };
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  boot.kernelParams = [
    "radeon.si_support=0"
    "radeon.cik_support=0"
    "amdgpu.si_support=1"
    "amdgpu.cik_support=1"
  ];  
  systemd.tmpfiles.rules = [
    "L+      /opt/rocm/hip     -     -     -     -     ${pkgs.hip}"
  ];

  # Configure console keymap
  console.keyMap = "no";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bjoh = {
    isNormalUser = true;
    description = "Bjarne Hanserud";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      google-chrome
    #  thunderbird
    ];
  };
services.postgresql = {
  enable = true;
  ensureDatabases = [ "ghostjaw" "hydra" ];
  ensureUsers = [
  {
  name = "ghostjaw";
  ensurePermissions = {
      "DATABASE ghostjaw" = "ALL PRIVILEGES";
    };  
  }
  {
  name = "hydra";
  ensurePermissions = {
  "DATABASE hydra" = "ALL PRIVILEGES";  
  };
  }
  {
    name = "bjoh";
    ensurePermissions = {
      "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
    };
  }
  ];
};
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  git
wezterm
foot
blender-hip
zsh
neovim
curl
wget
sxhkd
fzf
ripgrep
pkg-config
krita
postgresql
thefuck
exa
steam
gamemode
mangohud
vscode
ulauncher
gnumake
helix
  ];
programs.wezterm = {
  enableZshIntegration = true;
  extraConfig = ''
  local wezterm = require 'wezterm'
  local config = {}
  config.color_scheme = 'dracula'
  return config
  '';
};
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:
programs.neovim = {
  withNodeJs = true;
  withRuby = true;
  withPython3 = true;
  defaultEditor = true;
};
programs.zsh = { 
	enable = true;
	enableCompletion = true;
	syntaxHighlighting = { 
		enable = true;
		};
	autosuggestions = {
		enable = true;
		};
	ohMyZsh = { 
		enable = true;
		plugins = [ "git" "fzf" "thefuck" ];
		theme = "linuxonly";
    };
	};
environment.shells = with pkgs; [ zsh ];
environment.binsh = "${pkgs.dash}/bin/dash";


  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
