# axshell-core built from this checkout
{ pkgs, lib ? pkgs.lib }:

pkgs.rustPlatform.buildRustPackage {
  pname = "axshell-core";
  version = (lib.importTOML ../Cargo.toml).package.version;

  src = lib.fileset.toSource {
    root = ./..;
    fileset = lib.fileset.unions [ ../Cargo.toml ../Cargo.lock ../src ../assets ../LICENSE ];
  };
  cargoLock.lockFile = ../Cargo.lock;
  buildInputs = [ pkgs.sqlite ];

  postInstall = ''
    install -Dm644 assets/org.axshell.Core.service $out/share/dbus-1/services/org.axshell.Core.service
    substituteInPlace $out/share/dbus-1/services/org.axshell.Core.service --replace-fail @out@ $out
  '';

  meta = {
    description = "A core of services for AxShell in Rust";
    homepage = "https://github.com/mora1ss/axshell-core";
    license = lib.licenses.agpl3Plus;
    mainProgram = "axshell-core";
    platforms = lib.platforms.linux;
  };
}
