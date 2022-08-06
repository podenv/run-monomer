{
  description = "Podenv";
  nixConfig.bash-prompt = "[nix(podenv)] ";

  inputs = {
    nixpkgs.url =
      "github:NixOS/nixpkgs/d46be5b0e8baad998f8277e04370f0fd30dde11b";
    nixGL.url = "github:guibou/nixGL/047a34b2f087e2e3f93d43df8e67ada40bf70e5c";
    nixGL.inputs.nixpkgs.follows = "nixpkgs";
    monomer.url =
      "github:fjvallarino/monomer/5852155b727027e20f5bd0793b9e8df7354f9afc";
  };

  outputs = { self, nixpkgs, nixGL, monomer }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      haskellOverrides = {
        overrides = hpFinal: hpPrev: {
          monomer = pkgs.haskell.lib.dontCheck
            ((hpPrev.callCabal2nix "monomer" monomer { GLEW = pkgs.glew; }));

          sdl2 = pkgs.haskell.lib.dontCheck hpPrev.sdl2_2_5_3_3;
        };
      };
      haskellPackages = pkgs.haskell.packages.ghc923.override haskellOverrides;
      ghc = haskellPackages.ghcWithPackages (p: [ p.monomer ]);
      nixGLIntel = nixGL.packages.x86_64-linux.nixGLIntel;
      roboto_font = "${pkgs.roboto}/share/fonts/truetype/Roboto-Regular.ttf";
      demo = pkgs.writeScriptBin "run-monomer" ''
        #!/bin/sh
        export ROBOTO_TTF="${roboto_font}"
        exec ${nixGLIntel}/bin/nixGLIntel ${ghc}/bin/runhaskell ${self}/Demo.hs
      '';
    in {
      packages."x86_64-linux".default = demo;
      devShell."x86_64-linux" = pkgs.mkShell {
        buildInputs = [ nixGLIntel ghc ];
        ROBOTO_TTF = "${roboto_font}";
      };
    };
}
