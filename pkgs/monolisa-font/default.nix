{ runCommand }:

runCommand "monolisa-font" { } ''
  d=$out/share/fonts/truetype
  mkdir --parents $d
  ln -s ${../../.secrets/MonoLisa-Regular-Nerd-Font-Complete.otf} --target-directory=$d
''
