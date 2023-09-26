{
  #  ----      ---      --     -   -  -  --- --
  # Thanks for checking out my NixOS setup
  # You might want to edit parts of this nix
  # to better fit your hardware and/or needs.
  # -- ---  --- -- -- - - - - -- --- ---- --- - 
  # Any questions may be directed to:
  #  https://github.com/gh0stjaw
  # ----  ---  --  -  -  --  ---  --  -  --  --
  
  description = "Ghostjaw's NixOS Setup."
   
  inputs = {
    
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable"
    nixpkgs-nautilus-gtk3.url = "github:NixOS/nixpkgs?ref=37bd398";
    hardware.url = "github:nixos/nixos-hardware";

    # Cargo integration
    inputs.nci.url = "github:yusdacra/nix-cargo-integration";
    
    #impermanence.url = "github:nix-community/impermanence";
    #nix-color.url = "github:misterio77/nix-color";
    
    #emacs-overlay.url = "github:nix-community/emacs-overlay";
    nixvim.url = "github:nix-community/nixvim";
    
    #rycee-nurpkgs = {
    #  url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #nurpkgs.url = "github:nix-community/NUR";
    
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    #nh = {
    #  url = "github:viperml/nh";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    
    #};

    statix = {
      url = github:nerdypepper/statix;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cowsay = {
      url = github:snowfallorg/cowsay;
      inputs.nixpkgs.follows = "nixpkgs";
    };

outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, ... }:

    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;
      
      system = "x86_64-linux";

      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = extraOverlays ++ (lib.attrValues self.overlays);
      };
      pkgs = mkPkgs nixpkgs [ self.overlay ];
      pkgs = mkPkgs nixpkgs-unstable [];
      
      lib = nixpkgs.lib.extend
      (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });
      in {
        lib = lib.my;

        overlay =
        final: prev: {
          unstable = pkgs';
          my = self.packages."${system}";
        };

        overlays =
          mapModules ./overlays import;

        packages."${system}" =
          mapModules ./packages (p: pkgs.callPackage p {});

        nixosConfigurations =
          mapHosts ./hosts {};

        devShell."${system}" =
          import ./shell.nix { inherit pkgs; };

        templates = {
          full = {
            path = ./.;
            description = "Ghostjaw's NixOS config."
          };
        } // import ./templates;
        defaultTemplate = self.templates.full;

        defaultApp."${system}" = {
          type = "app";
          program = ./bin/hey;
        };
      };
      
#      pkgs = import inputs.nixpkgs {
#    inherit system;
#      config.allowUnfree = true;
#      overlays = import ./lib/overlays.nix {inherit inputs system; };
#    };
#
#extraArgs = {}
#
#  outputs = inputs@{ nixpkgs, home-manager, ... }: {
#    nixosConfiguration = {
#      # Main puter
#      hmk = nixpkgs.lib.nixosSystem { 
#        system = "x86_64-linux";
#        specialArgs = { inherit inputs outputs; };
#        modules = [
#          ./configuration.nix
#          home-manager.nixosModules.home-manager
#          {
#            home-manager.useGlobalPkgs = true;
#            home-manager.useUserPackages = true;
#            home-manager.users.bjoh = import ./home.nix;
#          }
#        ];
#      # Proxmox puter
#      };
#    };
#    homeConfigurations = {
#      # Desks
#      "bjoh@hmk" = lib.homeManagerConfiguration {
#        modules = [ ./home/ghostjaw/hmk.nix ];
#        pkgs = pkgsFor.x86_64-linux;
#        extraSpecialArgs = { inherit inputs outputs; };
#      };
#    };
#  };
}