{
  description = "agentmail - Python SDK (external packaging)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat, ... }:
    let
      version = "0.2.20";
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;

        agentmailSrc = pkgs.fetchFromGitHub {
          owner = "agentmail-to";
          repo = "agentmail-python";
          rev = version;
          hash = "sha256-zpmZF2JOcvDi5imFwwpq1uSmCI9GyvN/OzpON16fwko=";
        };

        agentmail = python.pkgs.buildPythonPackage {
          pname = "agentmail";
          inherit version;
          format = "pyproject";
          src = agentmailSrc;

          nativeBuildInputs = [
            python.pkgs.poetry-core
          ];

          propagatedBuildInputs = with python.pkgs; [
            httpx
            pydantic
            pydantic-core
            typing-extensions
            websockets
          ];

          pythonImportsCheck = [ "agentmail" ];
          doCheck = false;
        };
      in
      {
        packages.default = python.withPackages (_: [ agentmail ]);
        packages.agentmail = agentmail;

        devShells.default = pkgs.mkShell {
          packages = [
            (python.withPackages (_: [ agentmail ]))
          ];
        };
      }
    ) // {
      overlays.default = final: prev: {
        pythonPackagesExtensions = (prev.pythonPackagesExtensions or []) ++ [
          (python-final: python-prev: {
            agentmail = python-final.buildPythonPackage {
              pname = "agentmail";
              inherit version;
              format = "pyproject";
              src = final.fetchFromGitHub {
                owner = "agentmail-to";
                repo = "agentmail-python";
                rev = version;
                hash = "sha256-zpmZF2JOcvDi5imFwwpq1uSmCI9GyvN/OzpON16fwko=";
              };

              nativeBuildInputs = [
                python-final.poetry-core
              ];

              propagatedBuildInputs = with python-final; [
                httpx
                pydantic
                pydantic-core
                typing-extensions
                websockets
              ];

              pythonImportsCheck = [ "agentmail" ];
              doCheck = false;
            };
          })
        ];
      };
    };
}
