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
    nodejs 
    openssh
    gnupg
  ];
  services.docker.enable = true;
}
