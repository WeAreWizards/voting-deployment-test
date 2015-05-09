let
  region = "eu-west-1";

in {
  resources.ec2KeyPairs.sandbox2-pair = { inherit region; };
  resources.ec2SecurityGroups.http-ssh = {
      inherit region;
      rules = [
          { fromPort = 22; toPort = 22; sourceIp = "0.0.0.0/0"; }
          { fromPort = 80; toPort = 80; sourceIp = "0.0.0.0/0"; }
          { fromPort = 443; toPort = 443; sourceIp = "0.0.0.0/0"; }
      ];
  };

  network.description = "Voting";
  network.enableRollback = true;

  voting-server = { config, resources, pkgs, ... }:
  let
      app = import ./default.nix { pkgs = pkgs; };
  in
  {
      deployment.targetEnv = "ec2";
      deployment.ec2.ami = "ami-0126a576"; # for instance types == t1.micro
      deployment.ec2.region = region;
      deployment.ec2.instanceType = "t1.micro";
      deployment.ec2.tags = { Name = "sandbox2"; };
      deployment.ec2.keyPair = resources.ec2KeyPairs.sandbox2-pair;
      deployment.ec2.securityGroups = [ resources.ec2SecurityGroups.http-ssh ];

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
