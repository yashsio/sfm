{
  description = "SFM - Suckless File Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          sfm = pkgs.stdenv.mkDerivation {
            pname = "sfm";
            version = "unstable";
            src = ./.;

            installFlags = [ "PREFIX=$(out)" ];

            meta = with pkgs.lib; {
              description = "Suckless file manager";
              homepage = "https://github.com/yashsio/sfm";
              license = licenses.mit;
              platforms = platforms.unix;
              mainProgram = "sfm";
            };
          };
          default = self.packages.${system}.sfm;
        }
      );
    };
}
