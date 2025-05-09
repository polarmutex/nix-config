{exec, ...}: {
  readSops = name: exec ["sops" "-d" name];
}
