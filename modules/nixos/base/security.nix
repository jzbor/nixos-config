_:

{
  # Replace sudo with doas
  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [{
    users = [ "jzbor" ];
    persist = true;
  }];

  security.pam.services.i3lock.enable = true;
}

