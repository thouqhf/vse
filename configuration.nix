{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in

{
  imports =
    [ 
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];
   
  home-manager.users.thought = { config, pkgs, ... }: {
    programs = {
      vim = {
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
          set encoding=utf-8             " Устанавливаем кодировку UTF-8
          set fileencodings=utf-8        " Поддержка кодировки UTF-8 для файлов
          set nocompatible               " Отключаем совместимость с vi
          filetype plugin indent on      " Включаем поддержку плагинов
          set number                     " Включаем абсолютную нумерацию для текущей строки
          set numberwidth=1              " Ширина номера строки
          highlight LineNr ctermfg=NONE guifg=NONE  " Отключаем цвет для номеров строк
          highlight CursorLineNr ctermfg=NONE guifg=NONE  " Отключаем цвет для текущего номера строки
          highlight NonText ctermfg=NONE guifg=NONE
          syntax on                      " Включаем подсветку синтаксиса
          set scrolloff=5                " Отступ от края экрана при прокрутке
          set background=dark            " Тёмная тема
          set expandtab                  " Заменяем табуляции на пробелы
          set tabstop=4                  " Количество пробелов для табуляции
          set shiftwidth=4               " Количество пробелов при автодобавлении отступов
          set softtabstop=4              " Количество пробелов при автотабуляции
          set smarttab                   " Умное поведение табуляции
          set smartindent                " Умное выравнивание для кода
          set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
          set modelines=0     " Отключаем CVE-2007-2438 уязвимость
          set backspace=indent,eol,start " Больше возможностей для удаления текста
          set nowrap                     " Отключаем перенос строк
          set ruler                      " Показывать текущие координаты курсора
          set mouse=a                    " Включаем поддержку мыши
          au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
          au BufWrite /private/etc/pw.* set nowritebackup nobackup
          set hlsearch                   " Включаем подсветку поиска
          set incsearch                  " Поиск по мере ввода
          set ic                         " Игнорировать регистр при поиске
          set smartcase                  " Игнорировать регистр, если нет заглавных букв
          set laststatus=0
          :map <F7> :!nasm -f elf % && ld -m elf_i386 %<.o -o %<.exe && rm %<.o && ./%<.exe<CR> && rm %<.exe
        '';
      };
    };
    gtk = {
      enable = true;
      theme = {
        name = "Graphite-Dark";
        package = pkgs.graphite-gtk-theme;
      };
    };
    xdg.configFile = {
      "hypr/hyprland.conf".text = '' 
        #MONITORS
          monitor = eDP-1, 1920x1080, 0x0, 1
          monitor = HDMI-A-1, 1920x1080, -1920x0, 1
        #MY PROGRAMS
          $terminal = kitty
          $fileManager = thunar
          $menu = wofi --show drun
          $browser = firefox
          $bar = waybar
          $calculator = gnome-calculator --mode=keyboard
          $paint = krita
          $network = nekoray
        #AUTOSTART
          exec-once = hyprpaper & dunst
          exec-once = /lib/polkit-gnome/polkit-gnome-authentication-agent-1
          exec-once = wl-clipboard-history -t
          exec-once = wl-paste --watch cliphist store
          exec-once = wl-clip-persist --clipboard regular --display wayland-1
        #ENVIRONMENT VARIABLES
          env = XCURSOR_SIZE,24
          env = XCURSOR_THEME,Adwaita
          env = HYPRCURSOR_SIZE,24
        #LOOK AND FEEL
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
        #INPUT
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
        #KEYBINDINGS
          $mainMod = SUPER
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
          bind = ALT, left, movewindow, l
          bind = ALT, right, movewindow, r
          bind = ALT, up, movewindow, u
          bind = ALT, down, movewindow, d
          bind = CTRL, right, resizeactive, 20 0
          bind = CTRL, left, resizeactive, -20 0
          bind = CTRL, up, resizeactive, 0 -20
          bind = CTRL, down, resizeactive, 0 20
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
        #WINDOWS AND WORKSPACES
          windowrule = suppressevent maximize, class:.*
          windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
          windowrulev2 = float, class:^(org.gnome.Calculator)$
          windowrulev2 = size 400 500, class:^(org.gnome.Calculator)$
          windowrulev2 = center, class:^(org.gnome.Calculator)$
          layerrule = blur, $bar
      '';
      "hypr/hyprpaper.conf".text = ''
        preload = /home/thought/vse/Kartinki/wallpapers/tree.jpg
        wallpaper = eDP-1,/home/thought/vse/Kartinki/wallpapers/tree.jpg
        preload = /home/thought/vse/Kartinki/wallpapers/tree.jpg
        wallpaper = HDMI-A-1,/home/thought/vse/Kartinki/wallpapers/tree.jpg
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
        height=28%
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
          ### Display ###
            # Display notifications on monitor with mouse focus
            follow = mouse
            origin = top-right
            offset = (18, 16)
            width = 300
            height = 150
            # Show number of hidden notifications
            indicate_hidden = yes
            # Shrink window if smaller than width
            shrink = no
            # Set transparency of notifications
            transparency = 0
            # Height of whole notification    
            notification_height = 0
            # Height of seperators
            separator_height = 1
            # Text and seperator padding
            padding = 8
            # Horizontal padding
            horizontal_padding = 8
            # Width of frame around window
            frame_width = 0
            # Color of frame around window
            frame_color = "#424242"
            # Sort messages by urgency
            sort = yes
            # Idle seconds
            idle_threshold = 0
          ### Text ### 
            # Set font of notifications
            font = JetBrains Mono 10
            # Spacing between lines 
            line-height = 0
            # Markup parsing
            markup = full
            # Message format:
            # %a - appname
            # %s - summary
            # %b - body
            # %i - iconname (with path)
            # %I - iconname (without path)
            # %p - progress value (if set)
            # %n - progress value no extra characters
            # %% - literal %
            format = "<b>%a</b>\n<i>%s</i>\n%b"
            # Align message text horizontally
            alignment = center
            # Align message text vertically
            vertical_alignment = center
            # Show age of message if message is older than x seconds
            show_age_threshold = -1
            # Split notifications into multiple lines
            word_wrap = no
            # If message too long, add ellipsize to...
            ellipsize = middle
            # Ignore newlines in notifications
            ignore_newline = no
            # Stack duplicate notifications
            stack_duplicates = true
            # Hide number of duplicate notifications
            hide_duplicate_count = true
            # Show indicatiors  for urls and actions
            show_indicators = no 
          ### Icons ### 
            # Disable icons
            icon_position = off
          ### History ### 
            # Length of history
            history_length = 20 
          ### Misc ### 
            # Dmenu path
            dmenu = /usr/bin/dmenu -p dunst:
            # Browser
            browser = /usr/bin/firefox -new-tab
            # Always run scripts
            always_run_script = true
            # Title of notification
            title = Dunst
            # Notification class
            class = Dunst
            # Print notification on startup
            startup_notification = false
            # Dunst verbosity
            verbosity = mesg
            # Corner radius of dunst
            corner_radius = 9
            # Ignore dbus closeNotification message
            ignore_dbusclose = false
          ### Mouse ###
            # Left click
            mouse_left_click = close_current
            # Middle click
            mouse_middle_click = do_action
            # Right click
            mouse_right_click = do_action
        [shortcuts]
            # Close one notification
            close = ctrl+space
            # Close all notifications
            close_all = ctrl+shift+space
        [urgency_normal]
            # Normal urgency notifications
            background = "#272727"
            foreground = "#ffffff"
            timeout = 5
        [urgency_critical]
            # High urgency notifications
            background = "#ffffff"
            foreground = "#272727"
            timeout = 5
      '';
    };
    home.stateVersion = "25.05";
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        intel-vaapi-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    nvidia = {
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
      modesetting.enable = true;
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  boot.loader = {
    grub = {
      device = "nodev";
      enable = true;
      efiSupport = true;
    };
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Moscow";

  services = {
    xserver.videoDrivers = ["nvidia"];
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    dbus.enable = true;
    printing = {
      enable = true;
      drivers = with pkgs; [ hplip ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    libinput.enable = true;
    openssh.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "sugar-dark";
      };
    };
  };

  users = {
    users.thought = {
      isNormalUser = true;
      extraGroups = [ "wheel" "lp" "vboxusers" "networkmanager" "audio" "pipewire" ];
    };
    defaultUserShell = pkgs.zsh;
  };

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

  programs = {
    firefox.enable = true;
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
    hyprland.enable = true;
    nekoray = {
      enable = true;
      tunMode.enable = true;
    };
    gamemode.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ 
    git gcc binutils nasm btop fastfetch musikcube tmux
    jetbrains.clion
    discord easyeffects
    prismlauncher jdk24
    libreoffice-fresh
    lmms
    kitty waybar wofi dunst hyprpaper hyprshot brightnessctl xfce.thunar adwaita-icon-theme krita gnome-calculator
    sddm-sugar-dark qt5.qtbase qt5.qtsvg qt5.qtquickcontrols2 qt5.qtgraphicaleffects
    xdg-desktop-portal-hyprland polkit_gnome bluez bluez-tools blueman wl-clipboard wl-clip-persist
    mesa vulkan-tools vulkan-loader vulkan-validation-layers protonup
  ];
  
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [ jetbrains-mono font-awesome noto-fonts noto-fonts-cjk-sans noto-fonts-cjk-serif ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal ];
  };

  documentation.enable = false;

  system.stateVersion = "25.05";

}
