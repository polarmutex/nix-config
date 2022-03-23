{ pkgs, lib, fetchurl, appimageTools }:
appimageTools.wrapType2 rec {
  pname = "stacks-task-manager";
  version = "1.8.2";

  src = fetchurl {
    url = "https://github.com/stacks-task-manager/stacks/releases/download/v${version}/Stacks-Linux-${version}.AppImage";
    sha256 = "sha256-c79s94+svO7vX5D7WoZfn8bw2uuLeWSWv4dGvRGqzqM=";
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
