# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="A library and a utility for managing Boot Environments"
HOMEPAGE="https://gitlab.com/linux-be/zfs"

inherit git-r3
EGIT_REPO_URI="https://gitlab.com/linux-be/zfs.git"

LICENSE="CDDL"
SLOT="0"
IUSE="test-suite"

DEPEND="sys-fs/zfs[test-suite?]
	sys-apps/util-linux
"

RDEPEND="${DEPEND}
	!sys-fs/zfs:0/libbe
"

RESTRICT="test"

src_configure() {
	local emesonargs=(
		$(meson_use test-suite install_tests)
	)
	meson_src_configure
}
