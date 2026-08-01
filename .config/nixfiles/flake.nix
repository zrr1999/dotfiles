{
  description = "User CLI packages replacing x-cmd";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      mkCli = system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.buildEnv {
          name = "dotfiles-cli";
          paths = with pkgs; [
            ast-grep
            atuin
            bat
            bitwarden-cli
            bottom
            delta
            difftastic
            duf
            dust
            fastfetch
            fd
            fzf
            gh
            git-lfs
            gitoxide
            gitui
            helix
            hyperfine
            just
            lsd
            lua
            progress
            procs
            pueue
            ripgrep
            sd
            starship
            yadm
            zellij
          ];
          pathsToLink = [ "/bin" ];
        };
    in
    {
      packages = forAllSystems (system:
        let
          cli = mkCli system;
        in
        {
          default = cli;
          dotfiles-cli = cli;
        });
    };
}
