#!/usr/bin/env bash

fail="no"

bad="$(echo -e '\e[31m * \e[0m')"
good="$(echo -e '\e[32m * \e[0m')"

defer_failure() {
    echo "${bad}$@"
    fail="yes"
}

assert_true() {
    [ "$?" -ne 0 ] && defer_failure "$@"
}

assert_false() {
    [ "$?" -eq 0 ] && defer_failure "$@"
}

check_no_tarball() {
    tarball_name="${1}"
    shift

    for i in "$@"; do
	manifest="${i}/Manifest"
	grep -Hn "${tarball_name}" "${manifest}"
	assert_false "${manifest} contains a ${tarball_name} tarball"
    done
}

check_depend_on_beadm() {
    for i in sys-kernel/genkernel/*.ebuild sys-boot/grub/*.ebuild sys-apps/bemerge/*.ebuild; do
	grep -q sys-apps/beadm "${i}"; assert_true "${i} does not depend on beadm"
    done
}

check_fetching_from_linux_be() {
    for i in $(ls -1 */*/*.ebuild | grep -v zfsbootmenu); do
	grep -Hn 'EGIT_REPO_URI=' "${i}" | grep -v "gitlab.com/linux-be/"; assert_false "${i} uses a non-linux-be git URI"
    done
}

check_zfs_useflags() {
    for i in sys-kernel/genkernel/*.ebuild sys-boot/grub/*.ebuild; do
	grep -Hn 'IUSE=' "${i}" | grep -v "zfs"; assert_false "${i} does not have a zfs* useflag"
    done
}

check_live_with_no_stable_patches() {
    for i in */*/*9999*.ebuild; do
	grep -Hn -E "(PV|[0-9]+.[0-9]+.[0-9]+).*\.patch" "${i}"; assert_false "${i} live ebuild uses a patch from a stable release"
    done
}


check_fetching_from_linux_be
check_depend_on_beadm
check_zfs_useflags
check_live_with_no_stable_patches

check_no_tarball genkernel sys-kernel/genkernel
check_no_tarball grub sys-boot/grub


if [ "$fail" = yes ]; then
    echo "${bad}sanity check failed (see assertions above)"
    exit 1
else
    echo "${good}sanity check passed"
fi
