{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      haskellOverrides = self: super: {
        lcolonq-prelude = self.callCabal2nix "lcolonq-prelude" ./. {};
      };
      haskellPackages = pkgs.haskell.packages.ghc94.override {
        overrides = haskellOverrides;
      };
      lcolonq-prelude = haskellPackages.lcolonq-prelude;
    in {
      devShells.x86_64-linux.default = haskellPackages.shellFor {
        packages = hspkgs: with hspkgs; [
          lcolonq-prelude
        ];
        withHoogle = true;
        buildInputs = [
          # haskellPackages.haskell-language-server
        ];
      };
      packages.x86_64-linux = {
        default = haskellPackages.lcolonq-prelude;
        inherit lcolonq-prelude;
      };
    };
}
