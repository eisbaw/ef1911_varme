with (import (builtins.fetchTarball {
  url = "https://github.com/nixos/nixpkgs/tarball/21.05";
  sha256 = "1ckzhh24mgz6jd1xhfgx0i9mijk6xjqxwsshnvq789xsavrmsc36";
}) {});

mkShell {

  buildInputs = [
    stdenv.cc.cc.lib
    python39
    python39Packages.poetry
    python39Packages.pandas
  ];

  shellHook = ''
   export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${stdenv.cc.cc.lib}/lib/"

   source $(poetry env info --path)/bin/activate
  '';
}
