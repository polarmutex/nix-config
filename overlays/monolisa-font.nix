final: _: {
  monolisa-font = final.runCommand "monolisa-font" { } ''
    d=$out/share/fonts/opentype
    mkdir --parents $d
    ln -s ${../../.secrets/MonoLisaCustom-Bold.otf} --target-directory=$d
    ln -s ${../../.secrets/MonoLisaCustom-BoldItalic.otf} --target-directory=$d
    ln -s ${../../.secrets/MonoLisaCustom-Light.otf} --target-directory=$d
    ln -s ${../../.secrets/MonoLisaCustom-LightItalic.otf} --target-directory=$d
    ln -s ${../../.secrets/MonoLisaCustom-Medium.otf} --target-directory=$d
    ln -s ${../../.secrets/MonoLisaCustom-MediumItalic.otf} --target-directory=$d
    ln -s ${../../.secrets/MonoLisaCustom-Regular.otf} --target-directory=$d
    ln -s ${../../.secrets/MonoLisaCustom-RegularItalic.otf} --target-directory=$d

  '';
}
