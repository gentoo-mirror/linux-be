# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="emerge wrapper for boot environments"
HOMEPAGE="https://gitlab.com/linux-be/bemerge"
inherit git-r3
EGIT_REPO_URI="https://gitlab.com/linux-be/bemerge.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="-doc"

RDEPEND=">=sys-fs/zfs-9999"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_compile() {
	default_src_compile
	use doc && emake doc
}

src_install() {
	dodir /etc/bemerge
	insinto /etc/bemerge
	newins etc/bemerge/portage-hook.sh portage-hook.sh

	use doc && {
		newman man/man3/be.c.3 bemerge-be.c.3
		newman man/man3/bemerge.c.3 bemerge-bemerge.c.3
		newman man/man3/signals.c.3 bemerge-signals.c.3
	}
	doman bemerge.8
	dosbin bemerge
}

pkg_postinst() {
	elog "If you want to automatically create snapshots during package installation,"
	elog "please add the following line to /etc/portage/bashrc:"
	elog "\tsource /etc/bemerge/*"
}
