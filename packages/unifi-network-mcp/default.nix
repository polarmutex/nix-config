{
  lib,
  python3,
  fetchPypi,
  fetchFromGitHub,
}: let
  # unifi-core's network extra requires aiounifi>=92 for error classes
  # (e.g. AuthenticationRateLimitError) that nixpkgs' pinned v90 lacks.
  aiounifi93 = python3.pkgs.aiounifi.overrideAttrs (old: rec {
    version = "93";
    src = fetchFromGitHub {
      owner = "Kane610";
      repo = "aiounifi";
      tag = "v${version}";
      hash = "sha256-hPRn46Oeuj9UnB7rT243g2aMirtWoC88CPg1E5S4OMo=";
    };
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail "setuptools==84.0.0" "setuptools" \
        --replace-fail "wheel==0.48.0" "wheel"
    '';
    doCheck = false;
    dontUsePytestCheck = true;
  });

  unifi-core = python3.pkgs.buildPythonPackage rec {
    pname = "unifi-core";
    version = "0.4.29";
    pyproject = true;

    src = fetchPypi {
      pname = "unifi_core";
      inherit version;
      hash = "sha256-3RDNtLF/Kmem280GT1lIuXgG7EgvUhGNC2ThwnZ1qWs=";
    };

    build-system = with python3.pkgs; [hatchling hatch-vcs];

    # nixpkgs pins aiohttp/mcp below the floors these wheels declare; skip the
    # strict version check rather than vendoring newer copies of both.
    dontCheckRuntimeDeps = true;

    dependencies = with python3.pkgs; [
      aiohttp
      pydantic
      pyyaml
    ];

    optional-dependencies.network = [aiounifi93];

    pythonImportsCheck = ["unifi_core"];

    meta = {
      description = "UniFi controller connectivity: auth, detection, retry, exceptions";
      homepage = "https://github.com/sirkirby/unifi-mcp";
      license = lib.licenses.mit;
    };
  };

  unifi-mcp-shared = python3.pkgs.buildPythonPackage rec {
    pname = "unifi-mcp-shared";
    version = "0.6.8";
    pyproject = true;

    src = fetchPypi {
      pname = "unifi_mcp_shared";
      inherit version;
      hash = "sha256-PDaJLAfcXFS7aDeZKDy6Llt+TsxHx3qlTHQPqwkpkFg=";
    };

    build-system = with python3.pkgs; [hatchling hatch-vcs];

    # nixpkgs pins aiohttp/mcp below the floors these wheels declare; skip the
    # strict version check rather than vendoring newer copies of both.
    dontCheckRuntimeDeps = true;

    dependencies = with python3.pkgs;
      [
        unifi-core
        cryptography
        pydantic-settings
        pyjwt
        python-multipart
        starlette
        click
        omegaconf
        pyyaml
        jsonschema
        python-dotenv
        mcp
      ]
      ++ mcp.optional-dependencies.cli;

    pythonImportsCheck = ["unifi_mcp_shared"];

    meta = {
      description = "Shared MCP server patterns: permissions, confirmation, lazy loading, config";
      homepage = "https://github.com/sirkirby/unifi-mcp";
      license = lib.licenses.mit;
    };
  };
in
  python3.pkgs.buildPythonApplication rec {
    pname = "unifi-network-mcp";
    version = "0.27.1";
    pyproject = true;

    src = fetchPypi {
      pname = "unifi_network_mcp";
      inherit version;
      hash = "sha256-gVejDHhxtQFvg2Z/dN4UKV5U8e6LPnoHDaULAjiKmBw=";
    };

    build-system = with python3.pkgs; [hatchling hatch-vcs];

    # nixpkgs pins aiohttp/mcp below the floors these wheels declare; skip the
    # strict version check rather than vendoring newer copies of both.
    dontCheckRuntimeDeps = true;

    dependencies = with python3.pkgs;
      [
        unifi-mcp-shared
        unifi-core
        aiounifi93
        cryptography
        pydantic-settings
        pyjwt
        python-multipart
        starlette
        click
        aiohttp
        pyyaml
        python-dotenv
        omegaconf
        jsonschema
        typing-extensions
        mcp
      ]
      ++ mcp.optional-dependencies.cli;

    pythonImportsCheck = ["unifi_network_mcp"];

    meta = {
      description = "MCP server exposing the UniFi Network Controller API";
      homepage = "https://github.com/sirkirby/unifi-mcp";
      license = lib.licenses.mit;
      mainProgram = "unifi-network-mcp";
    };
  }
