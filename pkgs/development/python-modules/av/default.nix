{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, numpy
, ffmpeg
, pkg-config
}:

buildPythonPackage rec {
  pname = "av";
  version = "9.1.0";
  disabled = isPy27; # setup.py no longer compatible

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fKcjYCU+UR8NwQwJ+tIj1LeRvPUS5d+I3itaGVHqAa0=";
  };

  checkInputs = [ numpy ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ffmpeg ];

  # Tests require downloading files from internet
  doCheck = false;

  meta = {
    description = "Pythonic bindings for FFmpeg/Libav";
    homepage = "https://github.com/mikeboers/PyAV/";
    license = lib.licenses.bsd2;
  };
}
