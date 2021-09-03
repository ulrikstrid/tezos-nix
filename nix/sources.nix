{ ocamlVersion ? "4_12" }:
let
  overlays =
    builtins.fetchTarball
      https://github.com/anmonteiro/nix-overlays/archive/dc22fffe3250a2f454ee75e8e5fd3262aae08441.tar.gz;

in

import "${overlays}/sources.nix" {
  overlays = [
    (import overlays)
    (self: super: {
      ocamlPackages = (super.ocaml-ng."ocamlPackages_${ocamlVersion}");

      pkgsCross.musl64.pkgsStatic = super.pkgsCross.musl64.pkgsStatic.appendOverlays [
        (self: super: {
          ocamlPackages = super.ocaml-ng."ocamlPackages_${ocamlVersion}";
        })
      ];
    })
  ];
}
