{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
in

{
  imports =
    [ 
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  boot.loader = {
    grub = {
      device = "nodev";
      enable = true;
      efiSupport = true;
    };
    efi.canTouchEfiVariables = true;
  };

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  time.timeZone = "Europe/Moscow";

  documentation.enable = false;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  users = {
    users.thought = {
      isNormalUser = true;
      extraGroups = [ "wheel" "lp" "networkmanager" "audio" "pipewire" "vboxusers" ];
    };
    defaultUserShell = pkgs.zsh;
  };

  virtualisation.virtualbox.host.enable = true;

  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    blueman.enable = true;
    dbus.enable = true;
    libinput.enable = true;
    openssh.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      theme = "sddm-astronaut-theme";
      extraPackages = with pkgs; [ kdePackages.qtmultimedia ];
    };
    printing = {
      enable = true;
      drivers = with pkgs; [ hplip ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  programs = {
    nano.enable = false;
    zsh = {
      enable = true;
      shellAliases = {
        ls = "ls --color";
      };
      promptInit = "PROMPT='➜ [%c] '";
      interactiveShellInit = ''
        if [ ! -f ~/.zshrc ]; then
          touch ~/.zshrc
        fi
        bindkey -v '^?' backward-delete-char
        HISTSIZE=5000
        HISTFILE=~/.zsh_history
        SAVEHIST=$HISTSIZE
        HISTDUP=erase
        setopt appendhistory
        setopt sharehistory
        setopt hist_ignore_space
        setopt hist_ignore_all_dups
        setopt hist_ignore_dups
        setopt hist_save_no_dups
        setopt hist_find_no_dups
        bindkey '^k' history-search-backward
        bindkey '^j' history-search-forward
      '';
    };
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    throne = {
      enable = true;
      tunMode.enable = true;
    };
    gamemode.enable = true;
    steam.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ 
    git gcc binutils nasm btop fastfetch musikcube tmux oniux
    jetbrains.clion
    librewolf brave
    discord easyeffects
    prismlauncher javaPackages.compiler.openjdk25
    libreoffice-fresh krita
    kitty waybar wofi dunst hyprpaper hyprshot brightnessctl xfce.thunar gnome-calculator wayscriber adwaita-icon-theme sddm-astronaut
    polkit_gnome wl-clipboard wl-clip-persist
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland xdg-desktop-portal-gtk ];
  };
  
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [ jetbrains-mono font-awesome noto-fonts noto-fonts-cjk-sans noto-fonts-cjk-serif ];
  };

  home-manager.users.thought = { config, pkgs, ... }: {
    gtk = {
      enable = true;
      theme = {
        name = "Graphite-Dark";
        package = pkgs.graphite-gtk-theme;
      };
    };
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ syntastic nerdtree ];
      extraConfig = ''
        nnoremap <C-b> :NERDTreeToggle<CR>
        nnoremap <C-y> "+y
        vnoremap <C-y> "+y
        nnoremap <Esc> :nohlsearch<CR>
        noremap <Up> <NOP>
        noremap <Down> <NOP>
        noremap <Left> <NOP>
        noremap <Right> <NOP>
        noremap! <Up> <NOP>
        noremap! <Down> <NOP>
        noremap! <Left> <NOP>
        noremap! <Right> <NOP>
        nnoremap <C-D> <C-D>zz
        nnoremap <C-U> <C-U>zz
        set encoding=utf-8
        set fileencodings=utf-8
        set nocompatible
        filetype plugin indent on
        set number
        set numberwidth=1
        highlight LineNr ctermfg=NONE guifg=NONE
        highlight CursorLineNr ctermfg=NONE guifg=NONE
        highlight NonText ctermfg=NONE guifg=NONE
        syntax on
        set scrolloff=5
        set background=dark
        set expandtab
        set tabstop=4
        set shiftwidth=4
        set softtabstop=4
        set smarttab
        set smartindent
        set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
        set modelines=0
        set backspace=indent,eol,start
        set nowrap
        set ruler
        set mouse=a
        au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
        au BufWrite /private/etc/pw.* set nowritebackup nobackup
        set hlsearch
        set incsearch
        set ic
        set smartcase
        set laststatus=0
        :map <F7> :!nasm -f elf % && ld -m elf_i386 %<.o -o %<.exe && rm %<.o && ./%<.exe<CR> && rm %<.exe
      '';
    };
    xdg.configFile = {
      "hypr/hyprland.conf".text = '' 
        ###MONITORS###
        monitor = eDP-1, 1920x1080@144, 0x0, 1
        monitor = HDMI-A-1, 1920x1080@60, -1920x0, 1
        ###MY PROGRAMS###
        $terminal = kitty
        $fileManager = thunar
        $menu = wofi --show drun
        $browser = librewolf
        $bar = waybar
        $calculator = gnome-calculator --mode=keyboard
        $paint = wayscriber -a
        $network = Throne
        ###AUTOSTART###
        exec-once = hyprpaper & dunst
        exec-once = /lib/polkit-gnome/polkit-gnome-authentication-agent-1
        exec-once = wl-clipboard-history -t
        exec-once = wl-paste --watch cliphist store
        exec-once = wl-clip-persist --clipboard regular --display wayland-1
        ###ENVIRONMENT VARIABLES###
        env = XCURSOR_SIZE,24
        env = XCURSOR_THEME,Adwaita
        env = HYPRCURSOR_SIZE,24
        ###LOOK AND FEEL###
        general {
          gaps_in = 3
          gaps_out = 6, 8, 8, 8
          border_size = 0
          col.active_border = rgba(ffffffff) rgba(ffffffff) 45deg
          col.inactive_border = rgba(ffffffff)
          resize_on_border = false
          allow_tearing = false
          layout = dwindle
        }
        decoration {
          rounding = 8
          rounding_power = 2
          active_opacity = 1.0
          inactive_opacity = 1.0
          shadow {
            enabled = true
            range = 15
            render_power = 5
            color = rgba(00000000)
          }
          blur {
            enabled = true
            size = 3
            passes = 1
            new_optimizations = true
            ignore_opacity = true
            xray = false
            popups = true
            vibrancy = 0.1696
          }
        }
        animations {
          enabled = yes
          bezier = easeOutQuint,0.23,1,0.32,1
          bezier = easeInOutCubic,0.65,0.05,0.36,1
          bezier = linear,0,0,1,1
          bezier = almostLinear,0.5,0.5,0.75,1.0
          bezier = quick,0.15,0,0.1,1
          animation = global, 1, 10, default
          animation = border, 1, 5.39, easeOutQuint
          animation = windows, 1, 4.79, easeOutQuint
          animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
          animation = windowsOut, 1, 1.49, linear, popin 87%
          animation = fadeIn, 1, 1.73, almostLinear
          animation = fadeOut, 1, 1.46, almostLinear
          animation = fade, 1, 3.03, quick
          animation = layers, 1, 3.81, easeOutQuint
          animation = layersIn, 1, 4, easeOutQuint, fade
          animation = layersOut, 1, 1.5, linear, fade
          animation = fadeLayersIn, 1, 1.79, almostLinear
          animation = fadeLayersOut, 1, 1.39, almostLinear
          animation = workspaces, 1, 1.94, almostLinear, fade
          animation = workspacesIn, 1, 1.21, almostLinear, fade
          animation = workspacesOut, 1, 1.94, almostLinear, fade
        }
        dwindle {
          pseudotile = true
          preserve_split = true
        }
        master {
          new_status = master
        }
        misc {
          force_default_wallpaper = -1
          disable_hyprland_logo = false
        }
        ###INPUT###
        input {
          kb_layout = us,ru
          kb_variant =
          kb_model =
          kb_options = grp:caps_toggle
          kb_rules =
          follow_mouse = 1
          sensitivity = -1.0
          touchpad {
            natural_scroll = true
          }
        }
        device {
          name = elan0412:01-04f3:3240-touchpad
          sensitivity = 0
        }
        ###KEYBINDINGS###
        $mainMod = SUPER
        $subMod = ALT
        $thirdMod = CTRL
        bind = $mainMod, C, killactive,
        bind = $mainMod, Y, exit,
        bind = $mainMod, V, togglefloating,
        bind = $mainMod, O, pseudo,
        bind = $mainMod, J, togglesplit,
        bind = $mainMod, F, fullscreen,
        bind = $mainMod, Q, exec, $terminal
        bind = $mainMod, B, exec, $browser
        bind = $mainMod, R, exec, $menu
        bind = $mainMod, E, exec, $fileManager
        bind = $mainMod, W, exec, pkill $bar || $bar
        bind = $mainMod, K, exec, $calculator
        bind = $mainMod, P, exec, $paint
        bind = $mainMod, N, exec, $network
        bind = $mainMod, left, movefocus, l
        bind = $mainMod, right, movefocus, r
        bind = $mainMod, up, movefocus, u
        bind = $mainMod, down, movefocus, d
        bind = $subMod, left, movewindow, l
        bind = $subMod, right, movewindow, r
        bind = $subMod, up, movewindow, u
        bind = $subMod, down, movewindow, d
        bind = $thirdMod, right, resizeactive, 20 0
        bind = $thirdMod, left, resizeactive, -20 0
        bind = $thirdMod, up, resizeactive, 0 -20
        bind = $thirdMod, down, resizeactive, 0 20
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10
        bind = $mainMod, S, togglespecialworkspace, magic
        bind = $mainMod SHIFT, S, movetoworkspace, special:magic
        bind = $mainMod, mouse_down, workspace, e+1
        bind = $mainMod, mouse_up, workspace, e-1
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow
        bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
        bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
        bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-
        bindl = , XF86AudioNext, exec, playerctl next
        bindl = , XF86AudioPause, exec, playerctl play-pause
        bindl = , XF86AudioPlay, exec, playerctl play-pause
        bindl = , XF86AudioPrev, exec, playerctl previous
        bind = , PRINT, exec, hyprshot -m region --clipboard-only
        ###WINDOWS AND WORKSPACES###
        windowrule = suppressevent maximize, class:.*
        windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
        windowrulev2 = float, class:^(org.gnome.Calculator)$
        windowrulev2 = size 400 500, class:^(org.gnome.Calculator)$
        windowrulev2 = center, class:^(org.gnome.Calculator)$
        layerrule = blur, $bar
      '';
      "hypr/hyprpaper.conf".text = ''
        preload = /home/thought/vse/kartinki/wallpapers/tree.jpg
        wallpaper = eDP-1,/home/thought/vse/kartinki/wallpapers/tree.jpg
        preload = /home/thought/vse/kartinki/wallpapers/tree.jpg
        wallpaper = HDMI-A-1,/home/thought/vse/kartinki/wallpapers/tree.jpg
      '';
      "kitty/kitty.conf".text = ''
        background_opacity 0.75
        font_family     JetBrains Mono
        font_size 14.0
        window_padding_width 10
        foreground #faf0c6
        background #0a0a0a
        selection_foreground #0a0a0a
        selection_background #faf0c6
        confirm_os_window_close 0
      '';
      "waybar/config".text = ''
        {
          "layer": "top",
          "position": "top",
          "margin-top": 6,
          "margin-left": 8,
          "margin-right": 8,
          "height": 30,
          "modules-left": ["hyprland/workspaces"],
          "modules-center": ["hyprland/window"],
          "modules-right": ["group/expand", "clock"],
          "hyprland/workspaces": {
            "format": "{icon}",
            "on-click": "activate",
            "format-icons": {
              "active": "",
              "default": "",
              "empty": ""
            },
            "persistent-workspaces": {
              "*": [ 1,2,3 ]
            }
          },
          "hyprland/window": {
            "format": "{}",
            "max-length": 35,
            "rewrite": {
              "": "Hyprland"
            },
            "separate-outputs": true,
          },
          "group/expand": {
            "orientation": "horizontal",
            "drawer": {
              "transition-duration": 600,
              "transition-to-left": true,
              "click-to-reveal": true
            },
            "modules": ["custom/expand", "temperature", "backlight", "pulseaudio", "network", "battery", "hyprland/language"],
          },
          "custom/expand": {
            "format": "",
            "tooltip": false
          },
          "temperature": {
            "critical-threshold": 80,
            "format": "{icon} {temperatureC}°C",
            "format-icons": ["", "", ""]
          },
          "backlight": {
            "format": "{icon} {percent}%",
            "format-icons": ["◑"],
            "on-scroll-up":   "brightnessctl s 1%+",
            "on-scroll-down": "brightnessctl s 1%-"
          },
          "pulseaudio": {
            "format": "{icon} {volume}%",
            "format-bluetooth": "{volume}% {icon} {format_source}",
            "format-bluetooth-muted": " {icon} {format_source}",
            "format-muted": " {format_source}",
            "format-icons": {
              "headphone": "",
              "hands-free": "",
              "headset": "",
              "phone": "",
              "portable": "",
              "car": "",
              "default": ["", "", ""]
            },
            "on-click": "pavucontrol",
            "on-click-right": "blueman-manager"
          },
          "network": {
            "format-wifi": " {bandwidthDownBytes}",
            "format-ethernet": "{cidr} ",
            "tooltip-format": "{ifname} via {gwaddr} ",
            "format-linked": "{ifname} (No IP) ",
            "format-disconnected": " ⚠ ",
            "format-alt": "{ifname}: {ipaddr}/{cidr}",
            "on-click-right": "kitty nmtui"
          },
          "battery": {
            "states": {
              "warning": 30,
              "critical": 15
            },
            "format": "{icon} {capacity}%",
            "format-full": "{icon} {capacity}%",
            "format-charging": " {capacity}%",
            "format-plugged": " {capacity}%",
            "format-alt": "{time} {icon}",
            "format-icons": ["", "", "", "", ""]
          },
          "hyprland/language": {
            "format": "{short}",
            "on-click": "hyprctl switchxkblayout at-translated-set-2-keyboard next"
          },
          "clock": {
            "tooltip-format": "<tt><small>{calendar}</small></tt>",
            "format-alt": "{:%a %d %B %Y}"
          }
        }
      '';
      "waybar/style.css".text = ''
        * {
          font-family: "JetBrains Mono";
          font-size: 18px;
        }
        window#waybar {
          background: rgba(10, 10, 10, 0.75);
          border-radius: 8px;
          color: #faf0c6;
        }
        .modules-right, .modules-left, .modules-center {
          background-color: rgba(0, 0, 0, 0);
          border-radius: 8px;
          padding: 0 10px;
        }
        #clock, #battery, #battery, #network, #pulseaudio, #backlight, #temperature {
          padding: 0 7px;
        }
        #workspaces button {
          all:unset;
          color: #fe9900;
          padding: 0px 5px;
        }
        #workspaces button.active {
          color: #ff0055;
        }
        #workspaces button.empty {
          color: #0da100;
        }
        #workspaces button.empty.active {
          color: #ff0055;
        }
      '';
      "wofi/config".text = ''
        show=drun
        width=25%
        height=25%
        prompt=Search...
        normal_window=true
        location=center
        gtk-dark=true
        allow_images=true
        image_size=32
        insensitive=true
        allow_markup=true
        no_actions=true
        orientation=vertical
        halign=fill
        content_halign=fill
      '';
      "wofi/style.css".text = ''
        window {
          background-color: #272727;
        }
        * {
          font-family: "Jetbrains Mono";
          color: #fff;
        }
        #scroll {
          padding: 0.5rem;
        }
        #input {
          background-color: #272727;
          color: #ffffff;
          outline: none;
          box-shadow: none;
          border: 0;
          border-radius: 0;
          font-size: 1rem;
          padding: 0.5rem;
        }
        #inner-box {
          margin: 0.5rem;
          font-size: 1rem;
        }
        #img {
          margin: 10px 10px;
        }
        #entry {
          border-radius: 0.5rem;
        }
        #entry:selected {
          background-color: #424242;
          outline: none;
        }
        #text:selected {
          color: #ffffff;
        }
      '';
      "dunst/dunstrc".text = ''
        [global] 
          follow = mouse
          origin = top-right
          offset = (18, 16)
          width = 300
          height = 150
          indicate_hidden = yes
          shrink = no
          transparency = 0
          notification_height = 0
          separator_height = 1
          padding = 8
          horizontal_padding = 8
          frame_width = 0
          frame_color = "#424242"
          sort = yes
          idle_threshold = 0
          font = JetBrains Mono 10
          line-height = 0
          markup = full
          format = "<b>%a</b>\n<i>%s</i>\n%b"
          alignment = center
          vertical_alignment = center
          show_age_threshold = -1
          word_wrap = no
          ellipsize = middle
          ignore_newline = no
          stack_duplicates = true
          hide_duplicate_count = true
          show_indicators = no 
          icon_position = off
          history_length = 20 
          dmenu = /usr/bin/dmenu -p dunst:
          browser = /usr/bin/firefox -new-tab
          always_run_script = true
          title = Dunst
          class = Dunst
          startup_notification = false
          verbosity = mesg
          corner_radius = 9
          ignore_dbusclose = false
          mouse_left_click = close_current
          mouse_middle_click = do_action
          mouse_right_click = do_action
        [shortcuts]
          close = ctrl+space
          close_all = ctrl+shift+space
        [urgency_normal]
          background = "#272727"
          foreground = "#ffffff"
          timeout = 5
        [urgency_critical]
          background = "#ffffff"
          foreground = "#272727"
          timeout = 5
      '';
      "tmux/tmux.conf".text = '' 
        set  -g base-index      1
        setw -g pane-base-index 1
        set  -g focus-events on
        set  -g mouse on
        set  -s escape-time 0
        set  -g history-limit 2000
        set  -g status off
        set  -g pane-border-style fg=default
        set  -g pane-active-border-style fg=default
        bind -n M-Enter new-window
        bind -n M-q split-window -h
        bind -n M-w split-window -v
        bind -n M-d detach
        bind -n M-c kill-pane
        bind -n M-1 select-window -t 1
        bind -n M-2 select-window -t 2
        bind -n M-3 select-window -t 3
        bind -n M-4 select-window -t 4
        bind -n M-5 select-window -t 5
        bind -n M-6 select-window -t 6
        bind -n M-7 select-window -t 7
        bind -n M-8 select-window -t 8
        bind -n M-9 select-window -t 9
        bind -n M-h select-pane -L 
        bind -n M-l select-pane -R
        bind -n M-k select-pane -U 
        bind -n M-j select-pane -D 
      '';
    };
    home.stateVersion = "25.11";
  };

  system.stateVersion = "25.11";

}
