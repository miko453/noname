{ pkgs, ... }: {
  packages = with pkgs; [
    sudo
    htop
    vim
    curl
    wget
    git
    novnc
    python3Minimal
    qemu
    qemu-utils
  ];
  services.docker.enable = true;
}
