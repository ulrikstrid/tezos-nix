let
  pkgs = import ./nix/sources.nix { };
  inherit (pkgs) lib;
  tezosPkgs = pkgs.recurseIntoAttrs (import ./nix { inherit pkgs; }).native;
  tezosDrvs = lib.filterAttrs (_: value: lib.isDerivation value) tezosPkgs;

  filterDrvs = inputs:
    lib.filter
      (drv:
        # we wanna filter our own packages so we don't build them when entering
        # the shell. They always have `pname`
        !(lib.hasAttr "pname" drv) ||
        drv.pname == null ||
        !(lib.any (name: name == drv.pname || name == drv.name) (lib.attrNames tezosDrvs)))
      inputs;
in
with pkgs;

(mkShell {
  inputsFrom = lib.attrValues tezosDrvs;
  buildInputs = with ocamlPackages; [ utop fswatch redemon ppx_let_locs lsp jsonrpc ocaml-lsp odoc ];
}).overrideAttrs (o: {
  propagatedBuildInputs = filterDrvs o.propagatedBuildInputs;
  buildInputs = filterDrvs o.buildInputs;
})
