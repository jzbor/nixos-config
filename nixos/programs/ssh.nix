{ ... }:

{
  programs.ssh = {
    agentTimeout = "1h";
    startAgent = true;
    extraConfig = "AddKeysToAgent yes";
  };
}
