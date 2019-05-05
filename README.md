# GNU/Linux Boot Environments Gentoo overlay

## Installation

Add the repository using [Layman](https://wiki.gentoo.org/wiki/Layman):
```
yes | layman -a linux-be

installed_overlay=/var/lib/layman/linux-be
```

Set the required useflags and accept the keywords:
```
mkdir -p /etc/portage/package.use
ln -s "$installed_overlay"/Documentation/package.use/linux-be.use /etc/portage/package.use/

mkdir -p /etc/portage/package.accept_keywords
ln -s "$installed_overlay"/Documentation/package.accept_keywords/linux-be.keywords /etc/portage/package.accept_keywords/
```

There are multiple branches of `zfs` with `beadm`:
- one based on `zfs`'s `master` branch,
- one based on `zfs`'s `zfs-0.7-release` branch.

`libbe` and `beadm` have the same functionality in either of them.

To use the version based on `zfs` `master`:
```
ln -s "$installed_overlay"/Documentation/package.accept_keywords/linux-be-zfs-master.keywords /etc/portage/package.accept_keywords/
```

To use the version based on `zfs-0.7-release`:
```
ln -s "$installed_overlay"/Documentation/package.accept_keywords/linux-be-zfs-0.7.keywords /etc/portage/package.accept_keywords/
```

Install all the packages:
```
emerge -avt {zfs{,-kmod},grub,genkernel,bemerge}::linux-be
```

Finish the installation as in [Installing linux-be](https://gitlab.com/linux-be/zfs/wikis/linux-be-installation/Installing-linux-be).
