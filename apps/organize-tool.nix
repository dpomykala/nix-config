/*
Nix package for the organize-tool Python application.

Additional Python dependencies built for MacOS (Darwin) system:
- mdfind-wrapper
- macos-tags

Runtime dependencies included with the package:
- exiftool - for extracting EXIF data
- poppler-utils - for parsing PDF files

https://organize.readthedocs.io
https://github.com/tfeldmann/organize
*/
{
  exiftool,
  fetchFromGitHub,
  lib,
  poppler-utils,
  python3Packages,
}: let
  # Required for macos-tags (Darwin system only)
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

    build-system = with python3Packages; [setuptools];

    nativeCheckInputs = with python3Packages; [pytestCheckHook];

    pythonImportsCheck = ["mdfind"];
  };

  # Required for organize-tool (Darwin system only)
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

    # Use postry-core as a build backend
    # Relax requirements for xattr (pythonRelaxDeps fails with this)
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail "poetry>=0.12" "poetry-core" \
        --replace-fail "poetry.masonry.api" "poetry.core.masonry.api" \
        --replace-fail "xattr = \"^0.9.7\"" "xattr = \"*\""
    '';

    build-system = with python3Packages; [poetry-core];

    dependencies = with python3Packages; [
      mdfind-wrapper
      xattr
    ];

    nativeCheckInputs = with python3Packages; [pytestCheckHook];

    disabledTestPaths = [
      # File system access
      "tests/test_tags.py::test_tags"
    ];

    pythonImportsCheck = ["macos_tags"];
  };

  # Required for organize-tool
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

    build-system = with python3Packages; [poetry-core];

    nativeCheckInputs = with python3Packages; [pytestCheckHook];

    pythonImportsCheck = ["simplematch"];
  };
in
  python3Packages.buildPythonApplication rec {
    pname = "organize-tool";
    version = "3.3.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "tfeldmann";
      repo = "organize";
      rev = "v${version}";
      hash = "sha256-me7TF/KP7uqsLSOyU3OfCUVoi0QPC4fWzfx4UEBZOVw=";
    };

    build-system = with python3Packages; [poetry-core];

    dependencies = with python3Packages;
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
      ++ lib.optionals stdenv.hostPlatform.isDarwin [macos-tags];

    pythonRelaxDeps = [
      "docx2txt"
      "exifread"
      "rich"
    ];

    # Make sure that runtime dependencies are available
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [exiftool poppler-utils])
    ];

    nativeCheckInputs = with python3Packages; [
      pyfakefs
      pytestCheckHook
    ];

    pythonImportsCheck = ["organize"];

    meta = {
      changelog = "https://github.com/tfeldmann/organize/blob/v${version}/CHANGELOG.md";
      description = "The file management automation tool";
      homepage = "https://organize.readthedocs.io";
      license = lib.licenses.mit;
      mainProgram = "organize";
    };
  }
