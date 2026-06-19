# Copyright (C) Nitrokey GmbH
# SPDX-License-Identifier: Unlicense

{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "libfido2";
  buildInputs = with pkgs.buildPackages; [
    clang-tools
    gnumake
    libfido2
  ];
}
