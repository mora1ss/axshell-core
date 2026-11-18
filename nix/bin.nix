# axshell-core from the binary of the latest GitHub release, which installs in seconds.
# release.json names that release; the release workflow updates it on master after each one.
{ pkgs, lib ? pkgs.lib }:

let
  release = lib.importJSON ./release.json;
in
pkgs.stdenv.mkDerivation {
  pname = "axshell-core";
  inherit (release) version;

  src = pkgs.fetchurl {
    url = "https://github.com/mora1ss/axshell-core/releases/download/v${release.version}/axshell-core-${release.version}-x86_64-linux.tar.gz";
    inherit (release) hash;
  };

  # The tarball holds usr/ with the binary, the D-Bus service file and the licence
  sourceRoot = "usr";

  # The binary links only glibc and libgcc_s; autoPatchelf points it at Nix's
  nativeBuildInputs = [ pkgs.autoPatchelfHook ];
  buildInputs = [ pkgs.stdenv.cc.cc.lib ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r bin share $out/
    substituteInPlace $out/share/dbus-1/services/org.axshell.Core.service --replace-fail /usr/bin $out/bin
    runHook postInstall
  '';

  meta = {
    description = "A core of services for AxShell in Rust";
    homepage = "https://github.com/mora1ss/axshell-core";
    license = lib.licenses.agpl3Plus;
    mainProgram = "axshell-core";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
