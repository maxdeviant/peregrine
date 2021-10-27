with import <nixpkgs> {};

let
  easy-ps = import (fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "d9a37c75ed361372e1545f6efbc08d819b3c28c8";
    sha256 = "1fklhnddy5pzzbxfyrlprsq1p8b6y9v0awv1a1z0vkwqsd8y68yp";
  }) {
    inherit pkgs;
  };
in
stdenv.mkDerivation {
  name = "peregrine";

  buildInputs = [
    easy-ps.purs
    easy-ps.purs-tidy
    easy-ps.spago
    easy-ps.pulp
    yarn
  ];
}
