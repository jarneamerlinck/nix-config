{ pkgs, stdenv, fetchFromGitHub, python3Packages }:
let
  inherit (python3Packages) buildPythonPackage;
in
{
spiderfoot = stdenv.mkDerivation rec {
    pname = "spiderfoot";
    version = "v4.0";
    src = fetchFromGitHub {
      owner = "smicallef";
      repo = "spiderfoot";
      rev = "${version}";
      sha256 = "0nrzi13jy7hdg2r8cv6sjq73az09fga8fl81x5b7by8bnlmdmwif";
    };
    buildInputs = with pkgs; [
      python311
    ];
    # Ensure the required dependencies are installed
    propagatedBuildInputs = with python3Packages; [
      setuptools
      # adblockparser
      dnspython
      exifread
      cherrypy
      cherrypy-cors
      mako
      beautifulsoup4
      lxml
      netaddr
      pysocks
      requests
      ipwhois
      ipaddr
      phonenumbers
      # pygexf
      pypdf2
      python-whois
      secure
      pyopenssl
      python-docx
      python-pptx
      networkx
      cryptography
      publicsuffixlist
      openpyxl
      pyyaml

    ];
    doCheck = false;
    installPhase = ''
      runHook preInstall

      # Install the main executable
      mkdir -p $out/bin
      cp sf.py $out/bin/spiderfoot
      chmod +x $out/bin/spiderfoot

      runHook postInstall
    '';

  };
}
