{
  lib,
  python3Packages,
  fetchFromGitHub,
  makeWrapper,
}:
python3Packages.buildPythonApplication rec {
  pname = "flippertools";
  version = "unstable-2023-08-26";

  src = fetchFromGitHub {
    owner = "astrospark";
    repo = "flippertools";
    rev = "0dcf76e7e08b1dfba2322ad99a8b62ebe7057a8e";
    hash = "sha256-HRK8iCOJdgXJoKQ6Ld3e3UHph10I3LWS+P8nP5pFbfI=";
  };

  format = "other";

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = with python3Packages; [
    tzlocal
    hexdump
  ];

  # No build phase needed - it's just Python scripts
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python3Packages.python.sitePackages}
    mkdir -p $out/bin

    # Install Python modules directly to site-packages (not in subdirectory)
    # This allows direct imports like "from flipperfile import FlipperFile"
    cp flipperfile.py $out/${python3Packages.python.sitePackages}/
    cp flipperfileformatter.py $out/${python3Packages.python.sitePackages}/
    cp scratchcodeformatter.py $out/${python3Packages.python.sitePackages}/
    cp jsonformatter.py $out/${python3Packages.python.sitePackages}/
    cp pythoncodeformatter.py $out/${python3Packages.python.sitePackages}/

    # Install data files
    cp mappings.json $out/${python3Packages.python.sitePackages}/
    cp strings.json $out/${python3Packages.python.sitePackages}/

    # Install CLI scripts to libexec first, then we'll create wrappers
    mkdir -p $out/libexec/flippertools
    for tool in flipper2svg flipper2text flipperdiff; do
      cp $tool.py $out/libexec/flippertools/$tool
      chmod +x $out/libexec/flippertools/$tool
    done

    runHook postInstall
  '';

  postFixup = ''
    # Create proper wrappers that set PYTHONPATH
    for tool in flipper2svg flipper2text flipperdiff; do
      makeWrapper $out/libexec/flippertools/$tool $out/bin/$tool \
        --prefix PYTHONPATH : "$out/${python3Packages.python.sitePackages}:$PYTHONPATH"
    done
  '';

  # Tests would require sample project files
  doCheck = false;

  meta = with lib; {
    description = "Command-line utilities for working with LEGO MINDSTORMS EV3 Classroom and SPIKE project files";
    longDescription = ''
      flippertools provides command-line utilities for working with LEGO MINDSTORMS
      EV3 Classroom and SPIKE project files (.lmsp, .llsp, .llsp3). The tools enable
      users to convert project files to text, generate SVG visualizations, and show
      differences between two project files in unified diff format. It integrates
      with git for version control workflows.

      Includes three main tools:
      - flipperdiff: Compares two project files
      - flipper2text: Converts project files to readable text
      - flipper2svg: Generates SVG representations of projects
    '';
    homepage = "https://github.com/astrospark/flippertools";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [polarmutex];
    mainProgram = "flipper2text";
    platforms = platforms.unix;
  };
}
