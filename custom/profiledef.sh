#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="alice"
iso_label="alice_$(date +%Y%m%d)"
iso_publisher="Arch LInux Custom Easy <https://github.com/custom-archlinux>"
iso_application="Arch LInux Custom Easy Live/Rescue CD"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:700"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
)
