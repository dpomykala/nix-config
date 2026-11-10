/*
  Nix package for the organize-tool Python application.

  This file also builds the Python dependencies that nixpkgs lacks:
  - simplematch
  - macos-tags and its dependency mdfind-wrapper, on macOS only

  The package puts these runtime dependencies on its PATH:
  - exiftool, which reads EXIF data
  - poppler-utils, which parses PDF files

  https://organize.readthedocs.io
  https://github.com/tfeldmann/organize
*/
{
  exiftool,
  fetchFromGitHub,
  lib,
  poppler-utils,
  python3Packages,
}:
let
  # Required by macos-tags (macOS only)
  mdfind-wrapper = python3Packages.buildPythonPackage rec {
    pname = "mdfind-wrapper";
    version = "0.1.5";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "dmkskn";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-oA63nq3RzD7pozQirqx6SpUR/fdkGB1dNlxM9yDPvqU=";
    };

    build-system = with python3Packages; [ setuptools ];

    nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

    pythonImportsCheck = [ "mdfind" ];
  };

  # Required by organize-tool (macOS only)
  macos-tags = python3Packages.buildPythonPackage rec {
    pname = "macos-tags";
    version = "1.5.1";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "dmkskn";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-WHXETLG7F9faf3amahorGUivd1qGVDO7sCl61ymdmRY=";
    };

    # Build with poetry-core instead of poetry, and relax the xattr version
    # here, because pythonRelaxDeps fails for this package
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail "poetry>=0.12" "poetry-core" \
        --replace-fail "poetry.masonry.api" "poetry.core.masonry.api" \
        --replace-fail "xattr = \"^0.9.7\"" "xattr = \"*\""
    '';

    build-system = with python3Packages; [ poetry-core ];

    dependencies = with python3Packages; [
      mdfind-wrapper
      xattr
    ];

    nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

    disabledTestPaths = [
      # Needs file system access
      "tests/test_tags.py::test_tags"
    ];

    pythonImportsCheck = [ "macos_tags" ];
  };

  # Required by organize-tool
  simplematch = python3Packages.buildPythonPackage rec {
    pname = "simplematch";
    version = "1.4";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "tfeldmann";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-ONB6G5peAy0Ov84H4Z4aXO7rXlKohN4wyAP8Tv/rpTw=";
    };

    build-system = with python3Packages; [ poetry-core ];

    nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

    pythonImportsCheck = [ "simplematch" ];
  };
in
python3Packages.buildPythonApplication rec {
  pname = "organize-tool";
  version = "unreleased";
  rev = "feature/support-other-text-formats";
  pyproject = true;

  src = fetchFromGitHub {
    inherit rev;

    owner = "dpomykala";
    repo = "organize";
    hash = "sha256-WDUORzfqA/AtrXEKA8qN23cu34mKVTqGifH1oS6Todg=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies =
    with python3Packages;
    [
      exifread
      jinja2
      pyyaml
      send2trash
      arrow
      docopt-ng
      docx2txt
      natsort
      pdfminer-six
      platformdirs
      pydantic
      python
      rich
      simplematch
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ macos-tags ];

  pythonRelaxDeps = [
    "docx2txt"
    "exifread"
    "rich"
  ];

  # Put the runtime dependencies on the PATH of organize
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      exiftool
      poppler-utils
    ])
  ];

  nativeCheckInputs = with python3Packages; [
    pyfakefs
    pytestCheckHook
  ];

  pythonImportsCheck = [ "organize" ];

  meta = {
    changelog = "https://github.com/dpomykala/organize/blob/${rev}/CHANGELOG.md";
    description = "The file management automation tool";
    homepage = "https://organize.readthedocs.io";
    license = lib.licenses.mit;
    mainProgram = "organize";
  };
}
