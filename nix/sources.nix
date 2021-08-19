{ ocamlVersion ? "4_12" }:
let
  overlays =
    builtins.fetchTarball
      https://github.com/anmonteiro/nix-overlays/archive/a08228586b4e1faeb5120b1fee56d276cb0f71d1.tar.gz;

in
import "${overlays}/sources.nix" {
  overlays = [
    (import overlays)
    (self: super: {
      ocamlPackages =
        (super.ocaml-ng."ocamlPackages_${ocamlVersion}");

      pkgsCross.musl64.pkgsStatic = super.pkgsCross.musl64.pkgsStatic.appendOverlays [
        (self: super: {
          ocamlPackages = super.ocaml-ng."ocamlPackages_${ocamlVersion}";
        })
      ];
    })
  ];
}
