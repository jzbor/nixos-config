{ pkgs, ... }:

{
  # Define user accounts
  users.users = {
    jzbor = {
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" "video" "scanner" "adbusers" "dialout" ];
      isNormalUser = true;
      initialHashedPassword = "$y$j9T$8MXAsfQbb5EfFEENhATiC1$20plmLWRRjuGJZR2uxODYiTsZ6KKL6hrjaBnKs8c597";
    };
    guest = {
      extraGroups = [];
      isNormalUser = true;
      initialHashedPassword = "$y$j9T$Y5SWVProFs7edHT2KJzOs0$WbLvOevHGLXmZKA2UZCXGU8hi.u2A43QK8rffZiuL3.";
    };
  };
}

