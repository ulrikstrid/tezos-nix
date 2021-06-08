{ ocamlVersion ? "4_10" }:
let
  overlays =
    builtins.fetchTarball
      https://github.com/anmonteiro/nix-overlays/archive/bc48be2191fe97dfab2a17e846b2c3a9013f55c7.tar.gz;

in
import "${overlays}/sources.nix" {
  overlays = [
    (import overlays)
    (self: super: {
      ocamlPackages =
        (super.ocaml-ng."ocamlPackages_${ocamlVersion}" //
          {
            ocaml-migrate-parsetree = super.ocaml-ng."ocamlPackages_${ocamlVersion}".ocaml-migrate-parsetree-2-1;
            ocaml-migrate-parsetree-1-8 = super.ocaml-ng."ocamlPackages_${ocamlVersion}".ocaml-migrate-parsetree-2-1;
          });

      pkgsCross.musl64.pkgsStatic = super.pkgsCross.musl64.pkgsStatic.appendOverlays [
        (self: super: {
          ocamlPackages = super.ocaml-ng."ocamlPackages_${ocamlVersion}";
        })
      ];
    })
  ];
}
