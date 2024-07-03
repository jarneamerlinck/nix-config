{ stdenv, fetchFromGitHub, python3, python3Packages }:
{
  spiderfoot = buildPythonPackage rec {
    pname = "spiderfoot";
    version = "v4.0";
    src = fetchFromGitHub {
      owner = "smicallef";
      repo = "spiderfoot";
      rev = "${version}";
      sha256 = "1mjrdx56aky5ch6bb07cmlqs1hds15dfqnmw0ka28rxd7y1qpiif";
    };

    meta = with stdenv.lib; {
      description = "SpiderFoot automates OSINT for threat intelligence and mapping your attack surface.";
      homepage = "https://github.com/smicallef/spiderfoot";
      license = licenses.mit;
      # maintainers = with maintainers; [ your-github-username ];
    };
  };
}
