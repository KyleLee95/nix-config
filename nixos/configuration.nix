# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  environment = {
	systemPackages = with pkgs; [
	  vim
	  wget
	  git
	  fzf
	  rm-improved


	  gnomeExtensions.pop-shell
	  gnome3.gnome-tweaks
	  xclip

	  nerdfonts
	  lsd
	  thefuck

	  #nvim nightly
	  inputs.neovim-nightly-overlay.packages.${pkgs.system}.default


	  #langauages
	  typescript

	  #nvim lsps

	  lua-language-server


	  nil #nix language server
      nixfmt-classic





	  inputs.helix.packages."${pkgs.system}".helix
	];
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      #neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # FIXME: Add the rest of your current configuration


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  # networking.wirless.enable = true; Enables wirless support via wpa_supplicant.


  # Enable networking
  networking.networkmanager.enable = true;

  # time zone
  time.timeZone = "America/New_York";

  # Select internationalization props
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
	  LC_ADDRESS = "en_US.UTF-8";
	  LC_IDENTIFICATION = "en_US.UTF-8";
	  LC_MEASUREMENT = "en_US.UTF-8";
	  LC_MONETARY = "en_US.UTF-8";
	  LC_NAME = "en_US.UTF-8";
	  LC_NUMERIC = "en_US.UTF-8";
	  LC_PAPER = "en_US.UTF-8";
	  LC_TELEPHONE= "en_US.UTF-8";
	  LC_TIME = "en_US.UTF-8";
  };

  # Enable X11
  services.xserver.enable = true;

  # Enable GNOME DE
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.gnome.sessionPath = [pkgs.gnomeExtensions.pop-shell];


  # System76 hardware config
  hardware.system76.enableAll = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
	  enable =true;
	  alsa.enable = true;
	  alsa.support32Bit =true;
	  pulse.enable = true;
  };
  # If you want ot use JACK apps
  # jack.enable = true;

  # Enable touchpad support (left here for posterity but gnome already handles this)
  # services.xserver.libinput.enable = true;
  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users.kyle = {
				  isNormalUser = true;
				  extraGroups = ["networkmanager" "wheel"];
				  packages = with pkgs; [];
				  # openssh.authorizedKeys.keys = [# TODO: Add your SSH public key(s) here, if you plan on using SSH to connect];
				  # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      #Opinionated: use keys only.
      # Remove if you want to SSH using passwords
 #     PasswordAuthentication = false;
	};
  };
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";#
}

