# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature

DESCRIPTION="ZFS Bootloader for root-on-ZFS systems"
HOMEPAGE="https://github.com/zbm-dev/zfsbootmenu"

inherit git-r3
EGIT_REPO_URI="https://github.com/zbm-dev/zfsbootmenu.git"

LICENSE="MIT"
SLOT="0"

RDEPEND="sys-fs/zfs
	sys-kernel/dracut
	app-shells/fzf
	sys-apps/kexec-tools
	sys-block/mbuffer
	dev-perl/Config-IniFiles
	dev-perl/YAML-PP
	dev-perl/Sort-Versions
	dev-perl/boolean
"

src_install() {
	default

	insinto /etc/zfsbootmenu
	newins "${FILESDIR}"/config.yaml config.yaml
}

pkg_postinst() {
	optfeature \
		"creating a unified EFI executable (which bundles the kernel, initramfs and command line)" \
		sys-boot/systemd-boot
}
