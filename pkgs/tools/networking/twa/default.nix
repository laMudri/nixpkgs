{ stdenv
, bash
, curl
, fetchFromGitHub
, gawk
, host
, lib
, makeWrapper
, ncurses
, netcat
}:

stdenv.mkDerivation rec {
  name = "twa-${version}";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "twa";
    rev = version;
    sha256 = "0b3wg6ia4dbf47baz3c6jinsi31n8iq7jrlsq86jr2ncggq7hlhj";
  };

  dontBuild = true;

  buildInputs = [ makeWrapper bash gawk curl netcat host.dnsutils ];

  installPhase = ''
    install -Dm 0755 twa "$out/bin/twa"
    install -Dm 0755 tscore "$out/bin/tscore"
    install -Dm 0644 twa.1 "$out/share/man/man1/twa.1"
    install -Dm 0644 README.md "$out/share/doc/twa/README.md"

    wrapProgram "$out/bin/twa" \
      --prefix PATH : ${stdenv.lib.makeBinPath [ curl netcat ncurses host.dnsutils ]}
  '';

  meta = with lib; {
    description = "A tiny web auditor with strong opinions";
    homepage = https://github.com/trailofbits/twa;
    license = licenses.mit;
    maintainers = with maintainers; [ avaq ];
    platforms = platforms.unix;
  };
}
