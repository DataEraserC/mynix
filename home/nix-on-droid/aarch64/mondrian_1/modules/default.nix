{
  config,
  catppuccin-urxvt,
  ...
} @ args: {
  imports = [
    ./font.nix
    ./development.nix
    ./creative.nix
    ./menu.nix
    ./dewm.nix
    ./browers.nix
    ../../../common/modules/x11_catppuccin.nix # broken but can use to avoid gc
  ];
}
