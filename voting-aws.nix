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

  voting-server = { config, resources, pkgs, ... }:
  {
      deployment.targetEnv = "ec2";
      deployment.ec2.ami = "ami-0126a576"; # for instance types == t1.micro
      deployment.ec2.region = region;
      deployment.ec2.instanceType = "t1.micro";
      deployment.ec2.tags = { Name = "sandbox2"; };
      deployment.ec2.keyPair = resources.ec2KeyPairs.sandbox2-pair;
      deployment.ec2.securityGroups = [ resources.ec2SecurityGroups.http-ssh ];
  };
}
