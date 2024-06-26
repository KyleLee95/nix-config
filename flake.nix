{
  description = "Your new nix config";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #Editors
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay/master";
    helix.url = "github:helix-editor/helix/master";
  };

  outputs = {
    self,
    nixpkgs,
    helix,
    neovim-nightly-overlay,
    ...
  } @ inputs: let
    inherit (self) outputs;
	overlays =[
	# add overlays here
	#inputs.neovim-nightly-overlay.overlays.default
 ];
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
       nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};# > Our main nixos configuration file <
        modules = [
		./nixos/configuration.nix
		];
      };
    };

  };
}
