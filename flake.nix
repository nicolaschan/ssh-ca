{
  description = "SSH CA tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    createCa = pkgs.writeShellApplication {
      name = "create-ca";
      runtimeInputs = [ pkgs.yubikey-manager pkgs.openssh ];
      text = builtins.readFile ./scripts/create-ca.sh;
    };
    signUserKey = pkgs.writeShellApplication {
      name = "sign-user-key";
      runtimeInputs = [ pkgs.openssh pkgs.net-tools pkgs.opensc ];
      runtimeEnv = {
        PKCS11_PROVIDER = "${pkgs.opensc}/lib/opensc-pkcs11.so";
      };
      text = builtins.readFile ./scripts/sign-user-key.sh;
    };
    signHostKey = pkgs.writeShellApplication {
      name = "sign-host-key";
      runtimeInputs = [ pkgs.openssh pkgs.opensc ];
      runtimeEnv = {
        PKCS11_PROVIDER = "${pkgs.opensc}/lib/opensc-pkcs11.so";
      };
      text = builtins.readFile ./scripts/sign-host-key.sh;
    };
  in {
    packages.x86_64-linux = {
      inherit createCa signUserKey signHostKey;
      default = createCa;
    };

    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [
        bash
        net-tools
        opensc
        yubikey-manager

        createCa
        signUserKey
        signHostKey
      ];
    };
  };
}
