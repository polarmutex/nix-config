{pkgs, ...}:
{
  home.packages =  with pkgs; [
      vscode
  ];

  xsession = {
    profileExtra = "compton &";
  };
}
