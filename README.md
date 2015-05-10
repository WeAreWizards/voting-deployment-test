# Voting test application

This application is used to illustrate how a simple Django application can be
deployed using Ansible and Nix.

## Application structure

    # The ansible playbook and its supporting files
    sandbox1.pem # Not commited
    playbook.yml
    files/voting.ini.j2 # uwsgi configuration

    # The nix configuration
    default.nix # default nix expression for the app
    server.nix # nixops configuration
    state.nixops # state file (not commited)

    # Python project files
    README.md
    MANIFEST.in
    setup.py

    # Django project
    voting/

## Ansible deployment

To use the ansible deployment the environment should contain the following
variables:

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- EC2_REGION

Also, a AWS keypair named 'sandbox1' should be created in AWS and saved
locally as 'sandbox1.pem'.

Ansible and boto must also be installed:

```bash
$ pip install ansible boto
```

Finally to actually run the deployment:

```bash
$ ansible-playbook playbook.yml
```

## Nix deployment

Install Nix http://nixos.org/nix/download.html

Then to build the package :

```bash
$ nix-build
```

Or to access an environment with the package installed

```bash
$ nix-shell
```

To deploy 

```bash
$ nixops create server.nix --state nixops.state --name voting
```

```bash
$ nixops list --state state.nixops
```
