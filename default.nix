with import <nixpkgs> {};
{ pkgs ? import <nixpkgs> {} }:

pythonPackages.buildPythonPackage {
    name = "voting";

    propagatedBuildInputs = [
        pkgs.python27Packages.django
        pkgs.python27Packages.sqlite3
        pkgs.python27Packages.gunicorn
    ];

    preBuild = ''
        ${python}/bin/python voting/manage.py collectstatic --noinput;
    '';

    src = ./.;
}
