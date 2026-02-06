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
    gnumake
  ];
  services.docker.enable = true;
}
