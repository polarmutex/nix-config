{ pkgs, lib, fetchurl, appimageTools }:
appimageTools.wrapType2 rec {
  pname = "stacks-task-manager";
  version = "1.6.3";

  src = fetchurl {
    url = "https://github.com/stacks-task-manager/stacks/releases/download/v${version}/Stacks-Linux-${version}.AppImage";
    sha256 = "sha256-WC2qpr2B3hTyyJwQziSArrB0M41wduxPPcUHbPlmmcI=";
  };

  profile = ''
    export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
  '';

  meta = with lib; {
    description = "Your personal kanban to do and project manager";
    homepage = "https://github.com/stacks-task-manager/stacks";
    #license = licenses.none;
    maintainers = with maintainers; [ polarmutex ];
    platforms = [ "x86_64-linux" ];
  };

}
