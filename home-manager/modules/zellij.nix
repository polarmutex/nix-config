{self, ...}: {
  programs.zellij = {
    enable = true;
    package = self.packages.x86_64-linux.my-zellij;
    settings = {
      theme = "kanagawa";
      themes = {
        kanagawa = {
          fg = "#dcd7ba";
          bg = "#1f1f28";
          black = "#727169";
          red = "#e82424";
          green = "#98bb6c";
          yellow = "#e6c384";
          blue = "#7fb4ca";
          magenta = "#938aa9";
          cyan = "#7aa89f";
          white = "#dcd7ba";
          orange = "#FFA066";
        };
        gruvbox-dark = {
          fg = "#D5C4A1";
          bg = "#282828";
          black = "#3C3836";
          red = "#CC241D";
          green = "#98971A";
          yellow = "#D79921";
          blue = "#3C8588";
          magenta = "#B16286";
          cyan = "#689D6A";
          white = "#FBF1C7";
          orange = "#D65D0E";
        };
      };
    };
  };
  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
        pane size=1 borderless=true {
            plugin location="zellij:tab-bar"
        }
        pane
        pane size=2 borderless=true {
            plugin location="zellij:status-bar" {
                supermode true
            }
        }
    }
  '';
}
