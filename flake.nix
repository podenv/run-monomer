{
  inputs = {
    hspkgs.url =
      "github:podenv/hspkgs/cd711c5967c1313b6f91d1d40c7d68bfd561cfbe";
  };

  outputs = { self, hspkgs }:
    let
      pkgs = hspkgs.pkgs;
      ghc = pkgs.hspkgs.ghcWithPackages (p: [ p.monomer ]);
      demo = hspkgs.mk-nixgl-command ghc "runhaskell ${self}/Demo.hs";
    in {
      packages."x86_64-linux".default = demo;
      devShell."x86_64-linux" = pkgs.mkShell {
        buildInputs = [ pkgs.nixGLIntel ghc ];
        ROBOTO_TTF = pkgs.roboto_font;
      };
    };
}
