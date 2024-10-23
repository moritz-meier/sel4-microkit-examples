{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    sel4-nix-utils.url = "github:dlr-ft/sel4-nix-utils";
  };

  outputs =
    {
      nixpkgs,
      rust-overlay,
      sel4-nix-utils,
      ...
    }:
    let
      system = "x86_64-linux";
      overlays = [
        (import rust-overlay)
        sel4-nix-utils.overlays.default
      ];
      pkgs = import nixpkgs { inherit system overlays; };

      crossPkgs = {
        aarch64 = import nixpkgs {
          localSystem = system;
          crossSystem = {
            config = "aarch64-unknown-none-elf";
          };
        };
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {

        env.LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";

        env.MICROKIT_SDK = pkgs.microkit-sdk;
        env.SEL4_INCLUDE_DIRS = "${pkgs.microkit-sdk}/board/qemu_virt_aarch64/debug/include/";

        packages = with pkgs; [

          crossPkgs.aarch64.stdenv.cc

          pkgs.llvmPackages.libclang.lib

          pkgs.qemu_full

          pkgs.microkit-sdk

          (rust-bin.selectLatestNightlyWith (
            toolchain:
            toolchain.default.override {
              extensions = [
                "rust-src"
                "rustfmt"
                "rust-analyzer"
              ];
              targets = [ "aarch64-unknown-none" ];
            }
          ))
        ];
      };
    };
}
