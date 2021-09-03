{ pkgs, stdenv, lib, ocamlPackages, static ? false, fetchzip, opaline, doCheck }:

with ocamlPackages;

let version = "9.1-dev";

in

rec {
  tezos-stdlib = buildDunePackage {
    pname = "tezos-stdlib";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_stdlib" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      hex
      lwt
      zarith
      ppx_inline_test
    ];

    checkInputs = [
      bigstring
      lwt_log
      alcotest
      alcotest-lwt
      crowbar
      lib-test
      qcheck-alcotest
    ];

    inherit doCheck;
  };

  tezos-stdlib-unix = buildDunePackage {
    pname = "tezos-stdlib-unix";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_stdlib" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      # base-unix
      data-encoding
      tezos-error-monad
      tezos-lwt-result-stdlib
      tezos-event-logging
      tezos-stdlib
      re
      lwt
      ptime
      mtime
      ipaddr

      pkgs.libev
    ];

    inherit doCheck;
  };

  tezos-clic = buildDunePackage {
    pname = "tezos-clic";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_clic" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-stdlib
      tezos-stdlib-unix
      tezos-error-monad
      tezos-lwt-result-stdlib
      re
    ];

    checkInputs = [
      alcotest
      alcotest-lwt
    ];

    inherit doCheck;
  };

  tezos-crypto = buildDunePackage {
    pname = "tezos-crypto";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_crypto" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-stdlib
      data-encoding
      tezos-error-monad
      tezos-lwt-result-stdlib
      tezos-rpc
      tezos-clic
      lwt
      bls12-381
      tezos-hacl-glue
      zarith
      secp256k1-internal
      ringo
      tezos-test-helpers
      bisect_ppx
      ppx_tools_versioned
    ];

    checkInputs = [
      tezos-hacl-glue-unix
      bls12-381-unix
      alcotest
      alcotest-lwt
      tezos-test-helpers
    ];

    inherit doCheck;
  };

  tezos-hacl-glue = buildDunePackage {
    pname = "tezos-hacl-glue";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_hacl_glue/virtual" ];
    };

    useDune2 = true;

    inherit doCheck;
  };

  tezos-hacl-glue-unix = buildDunePackage {
    pname = "tezos-hacl-glue-unix";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_hacl_glue/unix" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      hacl-star
      tezos-hacl-glue
    ];

    inherit doCheck;
  };

  hacl-star-raw-empty = buildDunePackage {
    pname = "hacl-star-raw-empty";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_hacl_glue/js" ];
    };

    useDune2 = true;


    inherit doCheck;
  };

  tezos-hacl-glue-js = buildDunePackage {
    pname = "tezos-hacl-glue-js";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_hacl_glue/js" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      hacl-star
      js_of_ocaml
      zarith_stubs_js
      tezos-hacl-glue
      hacl-star-raw-empty
      js_of_ocaml-ppx
      menhir
    ];

    inherit doCheck;
  };

  tezos-error-monad = buildDunePackage {
    pname = "tezos-error-monad";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_error_monad" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-stdlib
      data-encoding
      lwt
      lwt-canceler
      tezos-lwt-result-stdlib
    ];

    checkInputs = [
      alcotest
      alcotest-lwt
    ];

    inherit doCheck;
  };

  tezos-event-logging = buildDunePackage {
    pname = "tezos-event-logging";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_event_logging" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-stdlib
      tezos-lwt-result-stdlib
      tezos-error-monad
      data-encoding
      lwt_log
      lwt
    ];

    inherit doCheck;
  };

  tezos-micheline = buildDunePackage {
    pname = "tezos-micheline";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_micheline" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-error-monad
      data-encoding
      uutf
      ppx_inline_test
    ];

    checkInputs = [
      alcotest
      alcotest-lwt
    ];

    inherit doCheck;
  };

  tezos-micheline-rewriting = buildDunePackage {
    pname = "tezos-micheline-rewriting";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_benchmark/lib_micheline_rewriting" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-micheline
      zarith
      tezos-stdlib
      tezos-error-monad
    ];

    checkInputs = [
      alcotest
      alcotest-lwt
      tezos-client-alpha
      tezos-protocol-alpha
    ];

    inherit doCheck;
  };

  tezos-benchmark-type-inference-alpha = buildDunePackage {
    pname = "tezos-benchmark-type-inference-alpha";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "proto_alpha/lib_benchmark/lib_benchmark_type_inference" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-stdlib
      tezos-error-monad
      tezos-crypto
      tezos-protocol-alpha
      tezos-micheline
      tezos-micheline-rewriting
      hashcons
    ];

    checkInputs = [
      tezos-client-alpha
    ];

    inherit doCheck;
  };

  tezos-protocol-plugin-alpha = buildDunePackage {
    pname = "tezos-protocol-plugin-alpha";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "proto_alpha/lib_plugin" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-protocol-alpha
    ];

    checkInputs = [
      tezos-client-alpha
    ];

    inherit doCheck;
  };

  tezos-validator = buildDunePackage {
    pname = "tezos-validator";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "bin_validation" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-context
      tezos-stdlib-unix
      tezos-protocol-environment
      tezos-protocol-updater
      tezos-shell
      tezos-shell-context
      tezos-validation
      lwt-exit
    ];

    inherit doCheck;
  };

  tezos-validation = buildDunePackage {
    pname = "tezos-validation";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_validation" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-context
      tezos-shell-context
      tezos-shell-services
      tezos-protocol-updater
    ];

    inherit doCheck;
  };

  tezos-shell = buildDunePackage {
    pname = "tezos-shell";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_shell" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-version
      tezos-p2p
      tezos-context
      tezos-store
      tezos-shell-services
      tezos-p2p-services
      tezos-protocol-updater
      tezos-validation
      tezos-stdlib-unix
      tezos-requester
      tezos-workers
      lwt-watcher
      lwt-canceler
      lwt-exit
    ];

    checkInputs = [
      alcotest
      alcotest-lwt
      qcheck-alcotest
      crowbar
      lib-test
      tezos-test-services
    ];

    inherit doCheck;
  };

  tezos-rpc = buildDunePackage {
    pname = "tezos-rpc";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_rpc" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-error-monad
      data-encoding
      resto
      resto-directory
    ];

    checkInputs = [
      alcotest
      alcotest-lwt
    ];

    inherit doCheck;
  };

  tezos-rpc-http = buildDunePackage {
    pname = "tezos-rpc-http";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_rpc_http" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      resto-directory
      resto-cohttp
      resto-cohttp-client
    ];

    inherit doCheck;
  };

  tezos-rpc-http-server = buildDunePackage {
    pname = "tezos-rpc-http-server";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_rpc_http" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-rpc-http
      resto-cohttp-server
      resto-acl
    ];

    inherit doCheck;
  };

  tezos-rpc-http-client = buildDunePackage {
    pname = "tezos-rpc-http-client";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_rpc_http" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-rpc-http
      resto-cohttp-client
    ];

    inherit doCheck;
  };

  tezos-rpc-http-client-unix = buildDunePackage {
    pname = "tezos-rpc-http-client-unix";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_rpc_http" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-stdlib-unix
      cohttp-lwt-unix
      lwt
      tezos-rpc-http-client
    ];

    inherit doCheck;
  };

  tezos-signer-services = buildDunePackage {
    pname = "tezos-signer-services";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_signer_services" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-client-base
      tezos-rpc
    ];

    inherit doCheck;
  };

  tezos-base = buildDunePackage {
    pname = "tezos-base";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_base" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-stdlib
      tezos-crypto
      tezos-hacl-glue
      data-encoding
      tezos-error-monad
      tezos-event-logging
      tezos-micheline
      tezos-rpc
      ptime
      ezjsonm
      ipaddr
      tezos-hacl-glue-unix
      bls12-381-unix
    ];

    checkInputs = [
      lib-test
      qcheck-alcotest
    ];

    inherit doCheck;
  };

  tezos-base-unix = buildDunePackage {
    pname = "tezos-base-unix";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_base/unix" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-stdlib
      tezos-crypto
      tezos-hacl-glue
      data-encoding
      tezos-error-monad
      tezos-event-logging
      tezos-micheline
      tezos-rpc
      ptime
      ezjsonm
      ipaddr
    ];

    checkInputs = [
      lib-test
      qcheck-alcotest
    ];

    inherit doCheck;
  };

  lib-test = buildDunePackage {
    pname = "lib-test";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_test" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      qcheck-alcotest
      alcotest
      alcotest-lwt
      hashcons
      pyml
    ];
  };

  tezos-lwt-result-stdlib = buildDunePackage {
    pname = "tezos-lwt-result-stdlib";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_lwt_result_stdlib" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      lwt
    ];

    checkInputs = [
      alcotest
      alcotest-lwt
      lib-test
      qcheck-alcotest
    ];

    inherit doCheck;
  };

  tezos-client-alpha = buildDunePackage {
    pname = "tezos-protocol-alpha";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "proto_alpha/lib_protocol" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-protocol-environment
      tezos-protocol-alpha
      tezos-shell-services
      tezos-client-base-unix
      tezos-mockup-registration
      tezos-proxy
      tezos-signer-backends
      tezos-protocol-alpha-parameters
      tezos-protocol-plugin-alpha
      ppx_inline_test
    ];

    checkInputs = [
      alcotest
      alcotest-lwt
    ];

    inherit doCheck;
  };

  bls12-381-gen = buildDunePackage {
    pname = "bls12-381-gen";
    version = "0.4.3";
    external = true;

    src = builtins.fetchurl {
      url = https://gitlab.com/dannywillems/ocaml-bls12-381/-/archive/0.4.3-legacy/ocaml-bls12-381-0.4.3-legacy.tar.bz2;
      sha256 = "1m9934swbp1pxfivm1j4szwkg1499aynrbb114zhd4pl7xhbw9j2";
    };

    useDune2 = true;

    propagatedBuildInputs = [
      ff
      ff-sig
      zarith
      ctypes
    ];

    buildInputs = [
      dune-configurator
    ];

    inherit doCheck;
  };

  bls12-381-legacy = buildDunePackage {
    pname = "bls12-381-legacy";

    inherit (bls12-381-gen) src version external useDune2;

    propagatedBuildInputs = [
      ff
      zarith
      ctypes
      bls12-381-gen
      tezos-rust-libs
    ];

    buildInputs = [
      dune-configurator
    ];

    OPAM_SWITCH_PREFIX = "${ocamlPackages.tezos-rust-libs}/lib/ocaml/${ocaml.version}/site-lib";

    inherit doCheck;
  };

  bls12-381 = buildDunePackage {
    pname = "bls12-381";
    version = "1.0.0-dev";
    external = true;

    useDune2 = true;

    src = builtins.fetchurl {
      url = https://gitlab.com/dannywillems/ocaml-bls12-381/-/archive/43db3c9c43de3c160461ad7075e8b19244d1cf40/ocaml-bls12-381-43db3c9c43de3c160461ad7075e8b19244d1cf40.tar.bz2;
      sha256 = "1pxswvf9wlvfrn84mjr4j6lizx39ihzsy8hi71ys26fj7bmzmdms";
    };

    propagatedBuildInputs = [
      ff
      ff-sig
      zarith
      ctypes
    ];

    buildInputs = [
      dune-configurator
    ];

    inherit doCheck;
  };

  bls12-381-unix = buildDunePackage {
    pname = "bls12-381-unix";
    inherit (bls12-381) version external src useDune2;

    propagatedBuildInputs = [
      hex
      zarith
      ctypes
      bls12-381
    ];

    buildInputs = [
      dune-configurator
    ];

    inherit doCheck;
  };

  tezos-rust-libs = buildDunePackage rec {
    pname = "tezos-rust-libs";
    version = "1.1";
    external = true;

    src = fetchzip {
      url = https://gitlab.com/tezos/tezos-rust-libs/-/archive/v1.1/tezos-rust-libs-v1.1.zip;
      sha256 = "08wpcq6cbdvxdhazcpqzz4pywagy3fdbys07q2anbk6lq45rc2w6";
    };

    buildInputs = with ocamlPackages; [
      topkg
      findlib
    ];

    propagatedBuildInputs = [ pkgs.cargo pkgs.rustc ];

    buildPhase = ''
      mkdir .cargo
      mv cargo-config .cargo/config
      cargo build --target-dir target --release
    '';

    installPhase = ''
      ${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR/lib -name ${pname}
    '';

    meta = {
      description = "Tezos: all rust dependencies and their dependencies";
      license = lib.licenses.mit;
    };

    createFindlibDestdir = true;
  };

  tezos-protocol-alpha = buildDunePackage {
    pname = "tezos-protocol-alpha";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "proto_alpha/lib_protocol" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-protocol-compiler
    ];

    inherit doCheck;
  };

  tezos-alpha-test-helpers = buildDunePackage {
    pname = "tezos-alpha-test-helpers";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "proto_alpha/lib_protocol/test/helpers" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-stdlib-unix
      tezos-shell-services
      tezos-protocol-environment
      tezos-protocol-alpha
      tezos-protocol-alpha-parameters
      tezos-client-alpha
      alcotest-lwt
    ];

    inherit doCheck;
  };

  tezos-protocol-alpha-parameters = buildDunePackage {
    pname = "tezos-protocol-alpha-parameters";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "proto_alpha/lib_parameters" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-protocol-environment
      tezos-protocol-alpha
    ];

    inherit doCheck;
  };

  tezos-protocol-environment = buildDunePackage {
    pname = "tezos-protocol-environment";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_protocol_environment" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-protocol-environment
      tezos-protocol-environment-sigs
      tezos-protocol-environment-structs
      tezos-context
    ];

    inherit doCheck;
  };

  tezos-protocol-environment-structs = buildDunePackage {
    pname = "tezos-protocol-environment-structs";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_protocol_environment" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-stdlib
      tezos-crypto
      tezos-protocol-environment-packer
      bls12-381-legacy
      data-encoding
    ];

    inherit doCheck;
  };

  tezos-protocol-environment-sigs = buildDunePackage {
    pname = "tezos-protocol-environment-sigs";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_protocol_environment" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-stdlib
      tezos-protocol-environment-packer
    ];

    inherit doCheck;
  };

  tezos-protocol-environment-packer = buildDunePackage {
    pname = "tezos-protocol-environment-packer";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_protocol_environment" ];
    };

    useDune2 = true;

    inherit doCheck;
  };

  tezos-proxy = buildDunePackage {
    pname = "tezos-proxy";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_context" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-client-base
      tezos-mockup-proxy
      tezos-protocol-environment
      tezos-rpc
      tezos-shell-services
      tezos-context
    ];

    checkInputs = [
      alcotest
      alcotest-lwt
      qcheck-alcotest
      crowbar
      tezos-test-services
      lib-test
    ];

    inherit doCheck;
  };

  tezos-context = buildDunePackage {
    pname = "tezos-context";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_context" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-protocol-environment
      tezos-context
      irmin
      irmin-pack
    ];

    inherit doCheck;
  };

  tezos-shell-context = buildDunePackage {
    pname = "tezos-shell-context";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_protocol_environment" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-protocol-environment
      tezos-context
    ];

    inherit doCheck;
  };

  tezos-node = buildDunePackage {
    pname = "tezos-node";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "bin_node" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-version
      tezos-rpc-http-server
      tezos-p2p
      tezos-shell
      tezos-workers
      tezos-protocol-updater
      tezos-validator
      cmdliner
      lwt
      lwt-exit
      tls
      cstruct
      ocp-ocamlres

      pprint

      bls12-381-unix
      tezos-hacl-glue-unix
    ];

    checkInputs = [
      tezos-node
      tezos-protocol-compiler
      tezos-protocol-alpha-parameters
    ];

    inherit doCheck;
  };

  tezos-client = buildDunePackage {
    pname = "tezos-client";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "bin_client" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-client-base
      tezos-client-base-unix
      tezos-client-genesis
      tezos-client-genesis-carthagenet

      tezos-mockup-commands
      tezos-signer-backends

      bls12-381-unix
      tezos-hacl-glue-unix
    ];

    checkInputs = [
      tezos-node
      tezos-protocol-compiler
      tezos-protocol-alpha-parameters
    ];

    inherit doCheck;
  };

  tezos-client-commands = buildDunePackage {
    pname = "tezos-client-commands";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_client_commands" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-client-base
      tezos-rpc
      tezos-shell-services
      tezos-signer-backends
      tezos-stdlib-unix
    ];

    checkInputs = [
      tezos-node
      tezos-protocol-compiler
      tezos-protocol-alpha-parameters
    ];

    inherit doCheck;
  };

  tezos-protocol-genesis = buildDunePackage {
    pname = "tezos-protocol-genesis";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "proto_genesis/lib_protocol" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-protocol-compiler
    ];

    inherit doCheck;
  };

  tezos-client-genesis = buildDunePackage {
    pname = "tezos-client-genesis";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "proto_genesis/lib_client" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-shell-services
      tezos-client-base
      tezos-client-commands
      tezos-protocol-environment
      tezos-protocol-genesis
      tezos-proxy
    ];

    inherit doCheck;
  };

  tezos-protocol-genesis-carthagenet = buildDunePackage {
    pname = "tezos-protocol-genesis-carthagenet";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "proto_genesis_carthagenet/lib_protocol" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-protocol-compiler
    ];

    inherit doCheck;
  };

  tezos-client-genesis-carthagenet = buildDunePackage {
    pname = "tezos-client-genesis-carthagenet";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "proto_genesis_carthagenet/lib_client" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-shell-services
      tezos-client-base
      tezos-client-commands
      tezos-protocol-environment
      tezos-protocol-genesis-carthagenet
    ];

    inherit doCheck;
  };

  tezos-client-base = buildDunePackage {
    pname = "tezos-client-base";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_client_base" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-stdlib-unix
      tezos-shell-services
      tezos-context
      tezos-rpc-http
      cmdliner
      tezos-sapling
    ];

    checkInputs = [
      alcotest
    ];

    inherit doCheck;
  };

  tezos-client-base-unix = buildDunePackage {
    pname = "tezos-client-base-unix";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_client_base_unix" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-client-base
      lwt-exit
    ];

    checkInputs = [
      tezos-test-services
    ];

    inherit doCheck;
  };

  tezos-sapling = buildDunePackage {
    pname = "tezos-sapling";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_sapling" ];
    };

    useDune2 = true;

    buildInputs = [
      pkgs.cargo
      pkgs.rustc
    ];

    propagatedBuildInputs = [
      hex
      ctypes
      data-encoding
      tezos-crypto
      tezos-stdlib
      tezos-error-monad
    ];

    checkInputs = [
      tezos-test-services
      alcotest
      alcotest-lwt
    ];

    inherit doCheck;

    # TODO: Don't be so hacky
    shellHook = ''
      export OPAM_SWITCH_PREFIX="${ocamlPackages.tezos-rust-libs}/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib"
    '';
  };

  tezos-shell-services = buildDunePackage {
    pname = "tezos-shell-services";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_shell_services" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-workers
      tezos-p2p-services
      tezos-version
    ];

    inherit doCheck;
  };

  tezos-workers = buildDunePackage {
    pname = "tezos-workers";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_workers" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-stdlib-unix
      ringo
    ];

    inherit doCheck;
  };

  tezos-p2p = buildDunePackage {
    pname = "tezos-p2p";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_p2p" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-stdlib-unix
      tezos-p2p-services
      lwt
      lwt-watcher
      lwt-canceler
      ringo
    ];

    checkInputs = [
      tezos-test-services
      alcotest
      alcotest-lwt
      astring
    ];

    inherit doCheck;
  };

  tezos-p2p-services = buildDunePackage {
    pname = "tezos-p2p-services";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_p2p_services" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
    ];

    inherit doCheck;
  };

  tezos-version = buildDunePackage {
    pname = "tezos-version";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_version" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
    ];

    inherit doCheck;
  };

  tezos-mockup = buildDunePackage {
    pname = "tezos-mockup";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_mockup" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-stdlib-unix
      tezos-client-base
      tezos-rpc
      tezos-p2p-services
      tezos-p2p
      tezos-protocol-environment
      resto-cohttp-self-serving-client
    ];

    checkInputs = [
      tezos-mockup-proxy
      tezos-mockup-registration
      tezos-test-services
    ];

    inherit doCheck;
  };

  tezos-mockup-registration = buildDunePackage {
    pname = "tezos-mockup-registration";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_mockup" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-client-base
      tezos-shell-services
      tezos-protocol-environment
    ];

    checkInputs = [
      tezos-mockup-proxy
      tezos-mockup-registration
      tezos-test-services
    ];

    inherit doCheck;
  };

  tezos-mockup-proxy = buildDunePackage {
    pname = "tezos-mockup-proxy";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_mockup_proxy" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-client-base
      tezos-protocol-environment
      tezos-rpc-http
      tezos-rpc-http-client
      tezos-shell-services
      resto-cohttp-self-serving-client
    ];

    inherit doCheck;
  };

  tezos-mockup-commands = buildDunePackage {
    pname = "tezos-mockup-commands";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_mockup" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-client-commands
      tezos-client-base
      tezos-mockup
      tezos-mockup-registration
    ];

    inherit doCheck;
  };

  tezos-signer-backends = buildDunePackage {
    pname = "tezos-signer-backends";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_signer_backends" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-stdlib-unix
      tezos-client-base
      tezos-rpc-http-client-unix
      tezos-signer-services
      tezos-shell-services
      ledgerwallet-tezos
    ];

    checkInputs = [
      alcotest
      alcotest-lwt
    ];

    inherit doCheck;
  };

  tezos-test-services = buildDunePackage {
    pname = "tezos-test-services";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_test_services" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      alcotest-lwt
    ];

    checkInputs = [
      tezos-stdlib-unix
    ];

    inherit doCheck;
  };

  tezos-test-helpers = buildDunePackage {
    pname = "tezos-test-helpers";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "./src/lib_test" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      alcotest
      alcotest-lwt
      qcheck
      qcheck-alcotest
    ];
  };

  tezos-requester = buildDunePackage {
    pname = "tezos-requester";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_requester" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-stdlib-unix
      lwt-watcher
    ];

    checkInputs = [
      alcotest
      alcotest-lwt
      tezos-test-services
    ];

    inherit doCheck;
  };

  tezos-legacy-store = buildDunePackage {
    pname = "tezos-legacy-store";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_store/legacy" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-context
      tezos-lmdb
      tezos-validation
      tezos-shell-services
      tezos-stdlib-unix
      tezos-protocol-updater
      lwt-watcher

      pkgs.lmdb
    ];

    checkInputs = [
      alcotest
      alcotest-lwt
    ];

    inherit doCheck;
  };

  tezos-store = buildDunePackage {
    pname = "tezos-store";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_store" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      index
      camlzip
      tar-unix
      ringo-lwt
      digestif
      tezos-shell-services
      tezos-stdlib-unix
      tezos-context
      tezos-validation
      tezos-legacy-store
    ];

    checkInputs = [
      alcotest
      alcotest-lwt
    ];

    inherit doCheck;
  };

  tezos-protocol-updater = buildDunePackage {
    pname = "tezos-protocol-updater";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "protocol_updater" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-micheline
      tezos-shell-services
      tezos-protocol-compiler
      tezos-shell-context
      tezos-stdlib-unix
      tezos-context
      lwt-exit
    ];

    inherit doCheck;
  };

  tezos-protocol-compiler = buildDunePackage {
    pname = "tezos-protocol-compiler";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "protocol_compiler" ];
    };

    useDune2 = true;

    buildInputs = [
      tezos-hacl-glue-unix
    ];

    propagatedBuildInputs = [
      # base-unix
      tezos-base
      tezos-version
      tezos-protocol-environment-sigs
      tezos-protocol-environment
      tezos-stdlib-unix
      ocp-ocamlres
      re
    ];

    inherit doCheck;
  };

  tezos-lmdb = buildDunePackage {
    pname = "tezos-lmdb";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "vendors/ocaml-lmdb" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      rresult
    ];

    checkInputs = [
      cstruct
      alcotest
    ];

    inherit doCheck;
  };

  tezos-snoop = buildDunePackage
    {
      pname = "tezos-snoop";

      version = version;

      src = lib.filterGitSource {
        src = ./../src;
        dirs = [ "bin_snoop" ];
      };

      useDune2 = true;

      propagatedBuildInputs = [
        tezos-base
        tezos-benchmark
        tezos-benchmark-examples
        tezos-shell-benchmarks
        tezos-benchmarks-proto-alpha
        tezos-stdlib-unix
        tezos-clic
        pyml
        pyml-plot
        ocamlgraph
        latex
      ];

      inherit doCheck;
    };

  numerics = buildDunePackage {
    pname = "numerics";
    version = "1.0";

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "vendors/numerics" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      numerics
    ];

    inherit doCheck;
  };

  staTz = buildDunePackage {
    pname = "staTz";
    version = "1.0";

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "vendors/statz" ];
    };

    useDune2 = true;

    inherit doCheck;
  };

  benchmark-utils = buildDunePackage {
    pname = "benchmark-utils";
    version = "1.0";

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "vendors/benchmark-utils" ];
    };

    useDune2 = true;

    inherit doCheck;
  };

  pyml-plot = buildDunePackage {
    pname = "pyml-plot";
    version = "1.0";

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "vendors/pyml-plot" ];
    };

    propagatedBuildInputs = [
      pyml
    ];

    useDune2 = true;

    inherit doCheck;
  };

  tezos-benchmark = buildDunePackage {
    pname = "tezos-benchmark";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_benchmark" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-stdlib
      tezos-stdlib-unix
      tezos-micheline
      tezos-clic
      data-encoding
      staTz
      benchmark-utils
      pyml-plot
      pkgs.autoconf
      hashcons
      ocaml-migrate-parsetree-2
    ];

    inherit doCheck;
  };

  tezos-benchmarks-proto-alpha = buildDunePackage {
    pname = "tezos-benchmarks-proto-alpha";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "proto_alpha/lib_benchmarks_proto" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-benchmark
      tezos-benchmark-alpha
      tezos-protocol-environment
      tezos-protocol-alpha
      tezos-protocol-alpha-parameters
      tezos-shell-benchmarks
      tezos-micheline
      tezos-alpha-test-helpers
      tezos-sapling
    ];

    inherit doCheck;
  };

  tezos-benchmark-examples = buildDunePackage {
    pname = "tezos-benchmark-examples";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_benchmark" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-benchmark
    ];

    checkInputs = [
      alcotest
    ];

    inherit doCheck;
  };

  tezos-benchmark-alpha = buildDunePackage {
    pname = "tezos-benchmark-alpha";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "src/proto_alpha/lib_benchmark" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-benchmark
      tezos-protocol-environment
      tezos-protocol-alpha
      tezos-alpha-test-helpers
      tezos-protocol-alpha-parameters
      tezos-micheline-rewriting
      tezos-benchmark-type-inference-alpha
      hashcons
      benchmark-utils
      tezos-alpha-test-helpers
      staTz
    ];

    checkInputs = [
      tezos-micheline
      tezos-error-monad
      alcotest
      alcotest-lwt
    ];

    inherit doCheck;
  };

  tezos-benchmark-proto-alpha = buildDunePackage {
    pname = "tezos-benchmark-proto-alpha";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_benchmarks_proto" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-benchmark
      tezos-benchmark-alpha
      tezos-protocol-environment
      tezos-protocol-alpha
      tezos-protocol-alpha-parameters
      tezos-shell-benchmarks
      tezos-micheline
      tezos-alpha-test-helpers
      tezos-sapling
    ];

    checkInputs = [
      alcotest
    ];

    inherit doCheck;
  };

  tezos-shell-benchmarks = buildDunePackage {
    pname = "tezos-shell-benchmarks";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "lib_shell_benchmarks" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      tezos-base
      tezos-benchmark
      tezos-context
      tezos-shell-context
      tezos-micheline
    ];

    checkInputs = [
      alcotest
    ];

    inherit doCheck;
  };

  latex = buildDunePackage {
    pname = "latex";
    version = version;

    src = lib.filterGitSource {
      src = ./../src/bin_snoop/latex;
    };

    useDune2 = true;

    inherit doCheck;
  };

  flextesa = buildDunePackage {
    pname = "latex";
    version = version;

    src = lib.filterGitSource {
      src = ./..vendors/flextesa-lib;
    };

    propagatedBuildInputs = [
      genspio
      dum
      tezos-stdlib-unix
      lwt
      fmt
      cohttp-lwt-unix
      tezos-base
    ];

    useDune2 = true;

    inherit doCheck;
  };

  ledgerwallet = buildDunePackage {
    pname = "ledgerwallet";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "vendors/ocaml-ledger-wallet" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      rresult
      cstruct
      hidapi
    ];

    inherit doCheck;
  };

  ledgerwallet-tezos = buildDunePackage {
    pname = "ledgerwallet-tezos";
    version = version;

    src = lib.filterGitSource {
      src = ./../src;
      dirs = [ "vendors/ocaml-ledger-wallet" ];
    };

    useDune2 = true;

    propagatedBuildInputs = [
      ledgerwallet
    ];

    inherit doCheck;
  };
}
