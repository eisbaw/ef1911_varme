with (import (builtins.fetchTarball {
  url = "https://github.com/nixos/nixpkgs/tarball/21.05";
  sha256 = "1ckzhh24mgz6jd1xhfgx0i9mijk6xjqxwsshnvq789xsavrmsc36";
}) {});

mkShell {

  buildInputs = [
    python39
    python39Packages.poetry
    python39Packages.pandas
  ];

  shellHook = ''
   source $(poetry env info --path)/bin/activate
  '';
}
