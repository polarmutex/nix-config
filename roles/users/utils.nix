{ config, ... }:

rec {

  link = path:
      config.lib.file.mkOutOfStoreSymlink ../.. + "/${path}";
}
