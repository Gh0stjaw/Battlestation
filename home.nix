{ config, pkgs, ... }:

{
  home.username = "bjoh";
  home.homeDirectory = "/home/bjoh";

  home.packages = with pkgs; [
    steam
    mangohud
    gamemode
    
  ];
  home.stateVersion = "23.05";

  programs.home-manager = {
    enable = true;
  };
  
}