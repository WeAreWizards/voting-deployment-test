{
  network.description = "Voting";
  network.enableRollback = true;

  voting-server = { config, resources, pkgs, ... }:
  let
      app = import ./default.nix { pkgs = pkgs; };
  in
  {
      environment.systemPackages = [ pkgs.python27Packages.gunicorn ];

      networking.firewall.enable = false;

      systemd.services.voting = {
        description = "voting server";
        after = [ "network.target" ];
        environment = { PYTHONUSERBASE = "${app}"; };
        serviceConfig = {
          ExecStartPre = "${app}/bin/manage.py syncdb --noinput";
          ExecStart = "${pkgs.python27Packages.gunicorn}/bin/gunicorn voting.wsgi";
          Restart = "always";
          User = "django";
        };
      };

      users.extraUsers = {
        django = { };
      };

      services.nginx.enable = true;
      services.nginx.config = ''
  events { }
  http {
    include ${pkgs.nginx}/conf/mime.types;

    server {
      listen 80 default_server;
      server_name _;

      location /static/ {
          alias ${app}/lib/python2.7/site-packages/voting/static/;
      }

      location / {
        proxy_pass http://localhost:8000;
      }
    }
  }
  '';

      services.openssh.enable = true;
  };
}
