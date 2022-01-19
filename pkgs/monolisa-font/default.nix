{ runCommand }:

runCommand "monolisa-font" { } ''
  d=$out/share/fonts/truetype
  mkdir --parents $d
  ln -s ${../../.secrets/MonoLisa-Regular.otf} --target-directory=$d
''
