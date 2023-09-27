## Battlestation

AKA dotfiles

This is a:
- learning project => work in progress

#### Intended setup consists of:
NixOS w/ home-manager, flakes and possibly some setup with hydra and/or nixops
  - bspwm or xmonad (most likely a setup where I can choose)
    - LightDM
    - rofi
    - polybar
  - configs and bash scripts included -> user agnostic
  - zsh and fish, dependant on other vars
  - wezterm and foot for the same reasons
  - neovim w/ a simple LazyVim setup (faithful horse)
  - tmux
  - qutebrowser / chrome
  - separate profiles for devEnv (devShells), gfx (rendering, qual optimizations)
    - ensure lib paths being exposed to the correct resources
  - krita, aesprite, gimp & blender
    - wacom settings
  - homelab sync -> proxmox LXC services (code server, hydra jobs, nixops)
    - move from ddwrt to pfsense vm main routing
  - misc QOL apps includes
    - ncspot
      - mpd
    - steam
      - gamemode
      - mangohud
    - discord
    - irc client
    - btop
