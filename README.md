# run-monomer

A nix flake wrapper that uses [nixGL](https://github.com/guibou/nixGL) to start [monomer](https://github.com/fjvallarino/monomer) project on any x86-64-linux.

- Run the demo: `nix run github:podenv/run-monomer`
- Which is equivalent to: `nix develop --command nixGLIntel runhaskell ./Demo.hs`
